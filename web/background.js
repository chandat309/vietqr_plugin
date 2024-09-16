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

// async function connectWebSocket(userId, token) {
//   if (!userId) {
//     console.error('UserId is not set');
//     return;
//   }
//   const url = `wss://api.vietqr.org/vqr/socket?userId=${userId}`;
//   ws = new WebSocket(url);

//   ws.onopen = () => {
//     console.log('WebSocket connection opened');
//     if (token) {
//       ws.send(JSON.stringify({ type: 'auth', token: token }));
//     }
//   };

//   ws.onmessage = async (event) => {
//     const message = JSON.parse(event.data);
//     console.log('WebSocket message received:', message);
//     if (message.notificationType == 'N05' && message.transType == 'C') {
//       chrome.tabs.query({ active: true, currentWindow: true }, async (tabs) => {
//         if (tabs.length === 0) return;

//         const activeTab = tabs[0];
//         const currentUrl = activeTab.url;

//         // console.log("Current URL:", currentUrl);

//         // Perform your URL checks here

//         chrome.tabs.query(
//           { active: true, currentWindow: true },
//           async (tabs) => {
//             try {
//               const activeTab = tabs[0];
//               // console.log("URL: " + activeTab.url);

//               chrome.scripting.executeScript(
//                 {
//                   target: { tabId: activeTab.id },
//                   files: ['content.js'] // Replace with your content script file name
//                 },
//                 async () => {
//                   await chrome.scripting.insertCSS({
//                     target: { tabId: activeTab.id },
//                     files: ['dialog.css']
//                   });
//                   chrome.tabs.sendMessage(activeTab.id, {
//                     action: 'showDialog',
//                     transactions: message
//                   });
//                   chrome.tabs.sendMessage(activeTab.id, {
//                     action: 'speak',
//                     text: message.amount
//                   });
//                 }
//               );
//             } catch (error) {
//               console.error('Error injecting script:', error);
//             }
//           }
//         );
//       });

//       // Cập nhật lastTransactions với dữ liệu mới nhất
//     }
//   };

//   ws.onclose = () => {
//     console.log('WebSocket connection closed');
//   };

//   ws.onerror = (error) => {
//     console.error('WebSocket error:', error);
//   };
// }

async function logoutUser() {
  await chrome.storage.local.remove(['idUser', 'bearerToken']);
}

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

chrome.runtime.onInstalled.addListener(async () => {
  console.log('Extension installed/reloaded');
  chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
    const { idUser, bearerToken } = result;
    console.log('Storage retrieved', result);

    if (idUser && bearerToken) {
      listenWebSocket({ token: bearerToken, userId: idUser });
    } else {
      console.log('No userId or token available in storage.');
    }
  });
});

// chrome.runtime.onStartup.addListener(() => {
//   chrome.storage.local.get(['idUser', 'bearerToken'], (result) => {
//     const { idUser, bearerToken } = result;
//     if (idUser && bearerToken) {
//       listenWebSocket({ token: bearerToken, userId: idUser });
//     }
//   });
// });
