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

// Boolean to check if the popup is open
const isPopupOpen = (listBankNotify, transaction) => {
  // Ensure listBankNotify is parsed as an array, whether it's a stringified JSON or already an array
  const arrayBankNotify =
    typeof listBankNotify === 'string'
      ? JSON.parse(listBankNotify)
      : listBankNotify;

  // Iterate through each bank notification in the array
  return arrayBankNotify?.some((bankNotify) => {
    // Clean up the notificationTypes by removing brackets and splitting into an array
    const listNotificationTypes = bankNotify.notificationTypes
      .replace(/[\[\]]/g, '')
      .split(',');

    // console.log('listNotificationTypes', listNotificationTypes);
    // Check if the bankId matches the transaction's bankId
    const isMatchingBank = bankNotify.bankId === transaction.bankId;
    // console.log('isMatchingBank', isMatchingBank);

    // If there's a matching bankId, check if the transaction type matches the notification types
    return (
      isMatchingBank &&
      listNotificationTypes.some((notificationType) => {
        switch (notificationType.trim()) {
          case 'CREDIT':
            return transaction.transType === 'C'; // Transaction is a credit
          case 'DEBIT':
            return transaction.transType === 'D'; // Transaction is a debit
          case 'RECON':
            return (
              transaction.transType === 'C' &&
              (transaction.type === 1 || transaction.type === 0) // RECON specific logic
            );
          default:
            return false; // For any unrecognized notificationType
        }
      })
    );
  });
};

const listenWebSocket = ({ token, userId }) => {
  if (socketInstance) {
    // console.log('WebSocket already initialized');
    socketInstance.close();
    socketInstance = null;
  }

  socketInstance = new WebSocket(
    `wss://api.vietqr.org/vqr/socket?userId=${userId}`
  );

  socketInstance.onopen = () => {
    const message = JSON.stringify({
      type: 'auth',
      token
    });
    if (socketInstance.readyState === WebSocket.OPEN) {
      // Only send if the connection is open
      socketInstance.send(message);
      console.log('WebSocket message sent:', message);
    } else {
      console.warn('WebSocket not ready, unable to send message.');
    }
    // console.log('WebSocket connection established');
    // console.log('WebSocket message sent:', message);
  };

  socketInstance.onmessage = (event) => {
    const data = JSON.parse(event.data);
    // console.log('WebSocket message received:', data);

    if (data.notificationType === 'N05') {
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        // console.log('tabs', tabs);

        if (tabs.length > 0) {
          const activeTab = tabs[0];

          // console.log('activeTab', activeTab);

          // Check if the URL is a restricted URL
          const restrictedUrls = ['chrome://', 'edge://'];
          if (restrictedUrls.some((url) => activeTab.url.startsWith(url))) {
            console.warn(
              'Cannot inject script into restricted URL:',
              activeTab
            );
            return; // Exit early if the URL is restricted
          }

          chrome.scripting.executeScript(
            {
              target: { tabId: activeTab.id },
              files: ['content.js']
            },
            async () => {
              // chrome.tabs.sendMessage(activeTab, {
              //   action: 'showDialog',
              //   transaction: data
              // });
              const getStorage = await getStorageData();
              const { listBank, listBankNotify } = getStorage;

              // console.log('listBankNotify', listBankNotify);
              // console.log('isPopupOpen', isPopupOpen(listBankNotify, data));

              if (isPopupOpen(listBankNotify, data) === true) {
                chrome.tabs.sendMessage(activeTab.id, {
                  action: 'showDialog',
                  transaction: data
                });

                const bankList = listBank
                  .replace(/[\[\]]/g, '')
                  .split(',')
                  .map((item) => item.replace(/['"]/g, '').trim());

                // console.log('bankList', bankList);

                const bankFound = bankList.includes(data.bankId);

                // console.log('bankFound', bankFound === true);

                if (bankFound && bankFound === true) {
                  // speakTransactionAmount(data, bankFound && bankFound === true);
                  chrome.tabs.sendMessage(activeTab.id, {
                    action: 'speak',
                    transaction: data,
                    text: data.amount,
                    isSpeech: bankFound && bankFound === true
                  });
                }
              }
            }
          );
        }
      });
    }
  };

  socketInstance.onerror = (event) => {
    console.error('WebSocket error occurred:', event);

    // Check if it's an instance of ErrorEvent
    if (event instanceof ErrorEvent) {
      console.error('ErrorEvent Details:', {
        message: event.message,
        filename: event.filename,
        lineno: event.lineno,
        colno: event.colno,
        error: event.error
      });
    } else if (event instanceof CloseEvent) {
      // Handling for WebSocket closure events
      console.error('WebSocket closed unexpectedly:', {
        code: event.code,
        reason: event.reason,
        wasClean: event.wasClean
      });
    } else {
      // General WebSocket error
      console.error('WebSocket error (unknown type):', event.type);
    }
  };

  socketInstance.onclose = (event) => {
    // console.log('WebSocket closed:', event);
    socketInstance = null;
    if (reconnectAttempts < 5) {
      setTimeout(() => {
        reconnectAttempts++;
        listenWebSocket({ token, userId });
      }, Math.pow(2, reconnectAttempts) * 1000); // Exponential backoff
    }
  };
};

const checkStorageAndListenWebSocket = async () => {
  try {
    const retrieveAndProcessData = async () => {
      const result = await getStorageData();
      const { idUser, bearerToken, listBank, listBankNotify } = result;
      // console.log('Storage retrieved', result);

      if (!idUser) {
        getLocalStorageInterval = setInterval(async () => {
          try {
            const getStorage = await getStorageData();
            const { idUser, bearerToken, listBank, listBankNotify } =
              getStorage;
            // const result = await getStorageData();
            // const { idUser, bearerToken, listBank, listBankNotify } = result;
            if (idUser) {
              listenWebSocket({
                token: bearerToken,
                userId: idUser
                // listId: listBank,
                // listBankNotify: listBankNotify,
              });
              clearInterval(getLocalStorageInterval); // Clear the interval if idUser is found
            }
          } catch (error) {
            console.warn('Error retrieving storage data:', error);
          }
        }, 3000);
      } else {
        listenWebSocket({
          token: bearerToken,
          userId: idUser
          // listBank: listBank,
          // listBankNotify: listBankNotify,
        });
      }
    };

    await retrieveAndProcessData();
  } catch (error) {
    console.warn('Error:', error);
  }
};

const getStorageData = () => {
  return new Promise((resolve, reject) => {
    chrome.storage.local.get(
      ['idUser', 'bearerToken', 'listBank', 'listBankNotify'],
      (result) => {
        if (chrome.runtime.lastError) {
          reject(new Error(chrome.runtime.lastError));
        } else {
          resolve(result);
        }
      }
    );
  });
};

// Handle extension installation and startup
chrome.runtime.onInstalled.addListener(() => {
  // console.log('Extension installed/reloaded');
  checkStorageAndListenWebSocket();
});

chrome.runtime.onStartup.addListener(() => {
  // console.log('Extension started');
  checkStorageAndListenWebSocket();
});

// Clean up WebSocket when the extension is suspended
chrome.runtime.onSuspend.addListener(() => {
  // console.log('Extension is being suspended. Cleaning up...');
  if (socketInstance) {
    socketInstance.close();
    socketInstance = null;
  }
});

// Watch for changes in localStorage and recheck WebSocket connection
chrome.storage.onChanged.addListener((changes, namespace) => {
  let idUser, bearerToken, listBank, listBankNotify;

  if (changes.idUser) {
    idUser = changes.idUser.newValue;
  }

  if (changes.bearerToken) {
    bearerToken = changes.bearerToken.newValue;
  }

  if (changes.listBank) {
    listBank = changes.listBank.newValue;
  }

  if (changes.listBankNotify) {
    listBankNotify = changes.listBankNotify.newValue;
  }

  // console.log('LocalStorage changed:', changes);

  if (listBank || listBankNotify) {
    // console.log('LocalStorage changed:', changes);

    checkStorageAndListenWebSocket();
  }
});

// chrome.storage.onChanged.addListener((changes, namespace) => {
//   if (
//     changes.idUser ||
//     changes.bearerToken ||
//     changes.listBank ||
//     changes.listBankNotify
//   ) {
//     console.log('LocalStorage changed:', changes);
//     checkStorageAndListenWebSocket( changes.idUser,changes.bearerToken,changes.listBank ,changes.listBankNotify);
//   }
// });
