let getLocalStorageInterval;
let reconnectAttempts = 0;
let socketInstance = null;
let currentListId = null;
let getListBankNotificationTypes;

async function setUserId(userId) {
  // idUser = userId;
  await chrome.storage.local.set({ idUser: userId });
  // console.log("UserId:", userId);
}

async function setToken(token) {
  // bearerToken = token;
  await chrome.storage.local.set({ bearerToken: token });
  // console.log("Bearer:", bearerToken);
}

async function setListBankNotify(list) {
  // bearerToken = token;
  await chrome.storage.local.set({ listBank: list });
  console.log('List:', list);
}

async function logoutUser() {
  await chrome.storage.local.remove(['idUser', 'bearerToken']);
}

const clearLocalStorageInterval = () => {
  if (getLocalStorageInterval) clearInterval(getLocalStorageInterval);
};

const listenWebSocket = ({ token, userId, listId }) => {
  // Check if WebSocket is already initialized
  if (socketInstance) {
    console.log('WebSocket already initialized');
    if (currentListId !== listId) {
      console.log('listId has changed. Updating WebSocket...');
      currentListId = listId;
      // Close the current WebSocket and reinitialize
      socketInstance.close();
      socketInstance = null;
    } else {
      console.log('No changes in listId');
      return;
    }
  }

  currentListId = listId;

  socketInstance = new WebSocket(
    `wss://api.vietqr.org/vqr/socket?userId=${userId}`
  );

  socketInstance.onopen = () => {
    const message = JSON.stringify({
      type: 'auth',
      token,
      listId
    });
    socketInstance.send(message);
    console.log('WebSocket connection established');
    console.log('WebSocket message sent:', message);
  };

  socketInstance.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log('WebSocket message received:', data);

    if (data.notificationType === 'N05') {
      // TODO: Show dialog
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        if (tabs.length > 0) {
          const activeTab = tabs[0].id;
          // Inject content.js into the active tab (if needed)
          chrome.scripting.executeScript(
            {
              target: { tabId: activeTab },
              files: ['content.js']
            },
            () => {
              // Check if listId has changed
              if (data.listId !== currentListId) {
                console.log('listId has changed. Updating...');
                currentListId = data.listId;
              }

              // Send message to content script to show dialog
              chrome.tabs.sendMessage(activeTab, {
                action: 'showDialog',
                transaction: data
              });

              // Send message to content script to speak the amount
              chrome.tabs.sendMessage(activeTab, {
                action: 'speak',
                transaction: data,
                text: data.amount
              });
              console.log(
                'Content script injected and messages sent successfully'
              );
            }
          );
        } else {
          console.log('No active tab found.');
        }
      });
    } else {
      console.log('No userId provided. WebSocket not initialized.');
    }
  };

  socketInstance.onerror = (error) => {
    console.error('WebSocket error:', error);
  };

  socketInstance.onclose = (event) => {
    console.log('WebSocket closed:', event);
    socketInstance = null;
    // Try reconnecting using exponential backoff
    if (reconnectAttempts < 5) {
      setTimeout(() => {
        reconnectAttempts++;
        listenWebSocket({ token, userId, listId });
      }, Math.pow(2, reconnectAttempts) * 1000); // Retry with exponential backoff
    }
  };
};

const checkStorageAndListenWebSocket = async () => {
  try {
    await chrome.storage.local.get(
      ['idUser', 'bearerToken', 'listId'],
      (result) => {
        const { idUser, bearerToken, listId } = result;
        console.log('Storage retrieved', result);

        // Check if idUser is available in storage
        if (!idUser) {
          getLocalStorageInterval = setInterval(async () => {
            await chrome.storage.local.get(
              ['idUser', 'bearerToken', 'listId'],
              (result) => {
                const { idUser, bearerToken, listId } = result;
                if (idUser) {
                  listenWebSocket({
                    token: bearerToken,
                    userId: idUser,
                    listId: listId
                  });
                  clearLocalStorageInterval(); // Clear the interval if it's running
                }
              }
            );
          }, 2000);
        } else {
          listenWebSocket({
            token: bearerToken,
            userId: idUser,
            listId: listId
          });
        }
      }
    );
  } catch (error) {
    console.error('Error:', error);
  }
};

// Call

// Run the function on extension install/reload
chrome.runtime.onInstalled.addListener(() => {
  console.log('Extension installed/reloaded');
  checkStorageAndListenWebSocket();
});

// Run the function on extension startup
chrome.runtime.onStartup.addListener(() => {
  console.log('Extension started');
  checkStorageAndListenWebSocket();
});

chrome.runtime.onSuspend.addListener(() => {
  console.log('Extension is being suspended. Cleaning up...');
  if (socketInstance) {
    socketInstance.close();
    socketInstance = null;
  }
});

// // Listen for changes in storage
// ! Duplicated interval check for idUser
// chrome.storage.onChanged.addListener((changes, namespace) => {
//   console.log('Storage changed:', changes, namespace);
//   checkStorageAndListenWebSocket();
// });

// // Runs every time the background script starts
// ! Duplicate of the interval check for idUser
// checkStorageAndListenWebSocket();
