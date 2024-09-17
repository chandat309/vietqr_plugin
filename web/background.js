let getLocalStorageInterval;

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

async function logoutUser() {
  await chrome.storage.local.remove(['idUser', 'bearerToken']);
}

const clearLocalStorageInterval = () => {
  if (getLocalStorageInterval) clearInterval(getLocalStorageInterval);
};

const listenWebSocket = ({ token, userId }) => {
  let socket;
  if (userId) {
    socket = new WebSocket(`wss://api.vietqr.org/vqr/socket?userId=${userId}`);
    socket.onopen = () => {
      const message = JSON.stringify({
        type: 'auth',
        token
      });
      socket.send(message);
      console.log('WebSocket connection established');
    };

    socket.onmessage = (event) => {
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
                // Send message to content script to show dialog
                chrome.tabs.sendMessage(activeTab, {
                  action: 'showDialog',
                  transaction: data
                });

                // Send message to content script to speak the amount
                chrome.tabs.sendMessage(activeTab, {
                  action: 'speak',
                  text: data.amount // Assuming amount is in the data
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

    socket.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    socket.onclose = (event) => {
      console.log('WebSocket connection closed:', event);
    };
  }
  return {
    closeSocket: () => {
      if (socket) socket.close();
    }
  };
};

const checkStorageAndListenWebSocket = async () => {
  try {
    await chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
      const { idUser, bearerToken } = result;
      console.log('Storage retrieved', result);

      // Check if idUser is available in storage
      if (!idUser) {
        getLocalStorageInterval = setInterval(async () => {
          await chrome.storage.local.get(
            ['idUser', 'bearerToken'],
            (result) => {
              const { idUser, bearerToken } = result;
              if (idUser) {
                listenWebSocket({ token: bearerToken, userId: idUser });
                clearLocalStorageInterval(); // Clear the interval if it's running
              }
            }
          );
        }, 2000);
      }
    });
  } catch (error) {
    console.error('Error:', error);
  }
};

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

// // Listen for changes in storage
// ! Duplicated interval check for idUser
// chrome.storage.onChanged.addListener((changes, namespace) => {
//   console.log('Storage changed:', changes, namespace);
//   checkStorageAndListenWebSocket();
// });

// // Runs every time the background script starts
// ! Duplicate of the interval check for idUser
// checkStorageAndListenWebSocket();
