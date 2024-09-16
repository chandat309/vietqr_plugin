let getLocalStorageInterval;
let getCurrentTabInterval;

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

const activeTabs = [];
async function getActiveTab() {
  chrome.tabs.onActivated.addListener((activeInfo) => {
    // Handle tab switch
    console.log('Tab switched to:', activeInfo.tabId);
    if (!activeTabs.includes(activeInfo.tabId)) {
      activeTabs.push(activeInfo.tabId);
    }
  });
}

const listenWebSocket = ({ token, userId }) => {
  let socket;

  if (userId) {
    if (getLocalStorageInterval) clearInterval(getLocalStorageInterval); // Clear the interval
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

chrome.runtime.onInstalled.addListener(async () => {
  console.log('Extension installed/reloaded');
  try {
    chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
      const { idUser, bearerToken } = result;
      console.log('Storage retrieved', result);

      // Check if idUser is available in storage
      if (!idUser) {
        getLocalStorageInterval = setInterval(() => {
          chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
            const { idUser, bearerToken } = result;
            if (idUser) {
              listenWebSocket({ token: bearerToken, userId: idUser });
            }
          });
        }, 1000);
      }
    });
  } catch (error) {
    console.error('Error:', error);
  }
});

chrome.runtime.onStartup.addListener(async () => {
  console.log('Extension started');
  try {
    chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
      const { idUser, bearerToken } = result;
      console.log('Storage retrieved', result);

      // Check if idUser is available in storage
      if (!idUser) {
        getLocalStorageInterval = setInterval(() => {
          chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
            const { idUser, bearerToken } = result;
            if (idUser) {
              listenWebSocket({ token: bearerToken, userId: idUser });
            }
          });
        }, 1000);
      }
    });
  } catch (error) {
    console.error('Error:', error);
  }
});

chrome.runtime.onConnect.addListener(async () => {
  console.log('Extension started');
  try {
    chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
      const { idUser, bearerToken } = result;
      console.log('Storage retrieved', result);

      // Check if idUser is available in storage
      if (!idUser) {
        getLocalStorageInterval = setInterval(() => {
          chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
            const { idUser, bearerToken } = result;
            if (idUser) {
              listenWebSocket({ token: bearerToken, userId: idUser });
            }
          });
        }, 1000);
      }
    });
  } catch (error) {
    console.error('Error:', error);
  }
});
