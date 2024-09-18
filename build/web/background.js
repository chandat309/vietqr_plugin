let getLocalStorageInterval;
let reconnectAttempts = 0;
let socketInstance = null;

async function setUserId(userId) {
  await chrome.storage.local.set({ idUser: userId });
}

async function setToken(token) {
  await chrome.storage.local.set({ bearerToken: token });
}

async function setListBankVoice(list) {
  await chrome.storage.local.set({ listBank: list });
}

async function setListBankNotify(list) {
  await chrome.storage.local.set({ listBankNotify: list });
}

async function logoutUser() {
  await chrome.storage.local.remove([
    'idUser',
    'bearerToken',
    'listBank',
    'listBankNotify'
  ]);
}

const clearLocalStorageInterval = () => {
  if (getLocalStorageInterval) clearInterval(getLocalStorageInterval);
};

const isPopupOpen = (listBankNotify, transaction) => {
  const arrayBankNotify =
    typeof listBankNotify === 'string'
      ? JSON.parse(listBankNotify)
      : listBankNotify;

  return arrayBankNotify?.some((bankNotify) => {
    const listNotificationTypes = bankNotify.notificationTypes
      .replace(/[\[\]]/g, '')
      .split(',');
    const isMatchingBank = bankNotify.bankId === transaction.bankId;

    return (
      isMatchingBank &&
      listNotificationTypes.some((notificationType) => {
        switch (notificationType.trim()) {
          case 'CREDIT':
            return transaction.transType === 'C';
          case 'DEBIT':
            return transaction.transType === 'D';
          case 'RECON':
            return (
              transaction.transType === 'C' &&
              (transaction.type === 1 || transaction.type === 0)
            );
          default:
            return false;
        }
      })
    );
  });
};

const listenWebSocket = ({ token, userId, listBank, listBankNotify }) => {
  if (socketInstance) {
    socketInstance.close();
    socketInstance = null;
  }

  socketInstance = new WebSocket(
    `wss://dev.vietqr.org/vqr/socket?userId=${userId}`
  );

  socketInstance.onopen = () => {
    const message = JSON.stringify({
      type: 'auth',
      token,
      listBank,
      listBankNotify
    });
    socketInstance.send(message);
  };

  socketInstance.onmessage = (event) => {
    const data = JSON.parse(event.data);

    if (data.notificationType === 'N05') {
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        if (tabs.length > 0) {
          const activeTab = tabs[0].id;
          chrome.scripting.executeScript(
            {
              target: { tabId: activeTab },
              files: ['content.js']
            },
            () => {
              if (isPopupOpen(listBankNotify, data)) {
                chrome.tabs.sendMessage(activeTab, {
                  action: 'showDialog',
                  transaction: data
                });

                chrome.tabs.sendMessage(activeTab, {
                  action: 'speak',
                  transaction: data,
                  text: data.amount,
                  isSpeech: listBank?.includes(data.bankId)
                });
              }
            }
          );
        }
      });
    }
  };

  socketInstance.onerror = (error) => {
    console.warn('WebSocket error:', error);
  };

  socketInstance.onclose = () => {
    socketInstance = null;
    if (reconnectAttempts < 5) {
      setTimeout(() => {
        reconnectAttempts++;
        listenWebSocket({ token, userId, listBank, listBankNotify });
      }, Math.pow(2, reconnectAttempts) * 2000); // Exponential backoff
    }
  };
};

const checkStorageAndListenWebSocket = async () => {
  const getStorageData = () =>
    new Promise((resolve, reject) => {
      chrome.storage.local.get(
        ['idUser', 'bearerToken', 'listBank', 'listBankNotify'],
        (result) => {
          chrome.runtime.lastError
            ? reject(new Error(chrome.runtime.lastError))
            : resolve(result);
        }
      );
    });

  try {
    const storage = await getStorageData();
    const { idUser, bearerToken, listBank, listBankNotify } = storage;

    if (!idUser) {
      getLocalStorageInterval = setInterval(async () => {
        try {
          const result = await getStorageData();
          const { idUser, bearerToken, listBank, listBankNotify } = result;
          if (idUser) {
            listenWebSocket({
              token: bearerToken,
              userId: idUser,
              listBank,
              listBankNotify
            });
            clearLocalStorageInterval();
          }
        } catch (error) {
          console.error('Error retrieving storage data:', error);
        }
      }, 3000);
    } else {
      listenWebSocket({
        token: bearerToken,
        userId: idUser,
        listBank,
        listBankNotify
      });
    }
  } catch (error) {
    console.error('Error:', error);
  }
};

// Handle extension installation and startup
chrome.runtime.onInstalled.addListener(() => {
  checkStorageAndListenWebSocket();
});

chrome.runtime.onStartup.addListener(() => {
  checkStorageAndListenWebSocket();
});

// Clean up WebSocket when the extension is suspended
chrome.runtime.onSuspend.addListener(() => {
  if (socketInstance) {
    socketInstance.close();
    socketInstance = null;
  }
});

// Watch for changes in localStorage and recheck WebSocket connection
chrome.storage.onChanged.addListener((changes) => {
  if (
    changes.idUser ||
    changes.bearerToken ||
    changes.listBank ||
    changes.listBankNotify
  ) {
    checkStorageAndListenWebSocket();
  }
});
