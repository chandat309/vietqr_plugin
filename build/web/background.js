let getLocalStorageInterval;
let reconnectAttempts = 0;
let socketInstance = null;
let currentListId = null;

async function setUserId(userId) {
  await chrome.storage.local.set({ idUser: userId });
}

async function setToken(token) {
  await chrome.storage.local.set({ bearerToken: token });
}

async function setListBankVoice(list) {
  await chrome.storage.local.set({ listBank: list });
  console.log('ListVoice:', list);
}

async function setListBankNotify(list) {
  await chrome.storage.local.set({ listBank: list });
  console.log('ListEnable:', list);
}

async function logoutUser() {
  await chrome.storage.local.remove(['idUser', 'bearerToken']);
}

const clearLocalStorageInterval = () => {
  if (getLocalStorageInterval) clearInterval(getLocalStorageInterval);
};

const listenWebSocket = ({ token, userId, listBank }) => {
  if (socketInstance) {
    console.log('WebSocket already initialized');
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
      listBank
    });
    socketInstance?.send(message);
    console.log('WebSocket connection established');
    console.log('WebSocket message sent:', message);
  };

  socketInstance.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log('WebSocket message received:', data);

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

              chrome.tabs.sendMessage(activeTab, {
                action: 'showDialog',
                transaction: data
              });

              console.log('list bank include:', listBank.includes(data.bankId));

              // Check if listBank is not null
              if (listBank && listBank.includes(data.bankId)) {
                chrome.tabs.sendMessage(activeTab, {
                  action: 'speak',
                  transaction: data,
                  text: data.amount
                });
              } else {
                console.warn('Bank not in list:', data.bankId);
              }
            }
          );
        }
      });
    }
  };

  socketInstance.onerror = (error) => {
    console.error('WebSocket error:', error);
  };

  socketInstance.onclose = (event) => {
    console.log('WebSocket closed:', event);
    socketInstance = null;
    if (reconnectAttempts < 5) {
      setTimeout(() => {
        reconnectAttempts++;
        listenWebSocket({ token, userId, listBank });
      }, Math.pow(2, reconnectAttempts) * 1000); // Exponential backoff
    }
  };
};

const checkStorageAndListenWebSocket = async () => {
  try {
    const getStorageData = () => {
      return new Promise((resolve, reject) => {
        chrome.storage.local.get(
          ['idUser', 'bearerToken', 'listBank'],
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

    const retrieveAndProcessData = async () => {
      result = await getStorageData();
      const { idUser, bearerToken, listBank } = result;
      console.log('Storage retrieved', result);

      if (!idUser) {
        getLocalStorageInterval = setInterval(async () => {
          try {
            const result = await getStorageData();
            const { idUser, bearerToken, listBank } = result;
            if (idUser) {
              listenWebSocket({
                token: bearerToken,
                userId: idUser,
                listId: listBank
              });
              clearInterval(getLocalStorageInterval); // Clear the interval if idUser is found
            }
          } catch (error) {
            console.error('Error retrieving storage data:', error);
          }
        }, 1000);
      } else {
        listenWebSocket({
          token: bearerToken,
          userId: idUser,
          listBank: listBank
        });
      }
    };

    await retrieveAndProcessData();
  } catch (error) {
    console.error('Error:', error);
  }
};

// Handle extension installation and startup
chrome.runtime.onInstalled.addListener(() => {
  console.log('Extension installed/reloaded');
  checkStorageAndListenWebSocket();
});

chrome.runtime.onStartup.addListener(() => {
  console.log('Extension started');
  checkStorageAndListenWebSocket();
});

// Clean up WebSocket when the extension is suspended
chrome.runtime.onSuspend.addListener(() => {
  console.log('Extension is being suspended. Cleaning up...');
  if (socketInstance) {
    socketInstance.close();
    socketInstance = null;
  }
});

// Watch for changes in localStorage and recheck WebSocket connection
chrome.storage.onChanged.addListener((changes, namespace) => {
  if (changes.idUser || changes.bearerToken || changes.listBank) {
    console.log('LocalStorage changed:', changes);
    checkStorageAndListenWebSocket();
  }
});
