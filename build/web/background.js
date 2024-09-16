// let ws;

// async function setUserId(userId) {
//   // idUser = userId;
//   await chrome.storage.local.set({ idUser: userId });
//   // console.log("UserId:", userId);
// }

// async function setToken(token) {
//   // bearerToken = token;
//   await chrome.storage.local.set({ bearerToken: token });
//   // console.log("Bearer:", bearerToken);
// }

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

// async function logoutUser() {
//   await chrome.storage.local.remove(['idUser', 'bearerToken']);
// }

// async function listenWss() {
//   const storage = await chrome.storage.local.get(['idUser', 'bearerToken']);
//   const idUser = storage.idUser;
//   const bearerToken = storage.bearerToken;
//   if (!idUser) {
//     if (ws) {
//       if (
//         ws.readyState === WebSocket.OPEN ||
//         ws.readyState === WebSocket.CONNECTING
//       ) {
//         ws.close();
//         console.log('WebSocket is closed');
//       }
//     }
//   } else {
//     if (!ws || ws.readyState === WebSocket.CLOSED) {
//       console.log('WebSocket is closed, reconnecting...');
//       connectWebSocket(idUser, bearerToken);
//     } else {
//       // console.log("WebSocket is open, no need to reconnect.");
//     }
//   }
//   setTimeout(listenWss, 1000);
// }

// chrome.runtime.onInstalled.addListener(async () => {
//   listenWss();
// });

const listenWebSocket = ({ token, userId }) => {
  let socket;
  if (userId) {
    socket = new WebSocket(`wss://api.vietqr.org/vqr/socket?userId=${userId}`);
    socket.onopen = () => {
      // console.log('WebSocket connection established');
      const message = JSON.stringify({
        type: 'auth',
        token
      });
      socket.send(message);
    };

    socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      console.log('WebSocket message received:', data);
      if (data.notificationType == 'N05') {
        // TODO: show dialog
        chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
          if (tabs.length > 0) {
            chrome.tabs.sendMessage(tabs[0].id, {
              action: 'showDialog',
              transaction: data
            });
          }
        });
      }
    };
    socket.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    socket.onclose = (event) => {
      console.log('WebSocket connection closed:', event);
    };
  }
  if (!userId) {
    if (socket) {
      socket.close();
    }
  }

  return { closeSocket: () => socket.close() };
};

chrome.runtime.onInstalled.addListener(async () => {
  chrome.storage.local.get(['userId', 'token'], (result) => {
    const { userId, token } = result;

    if (userId && token) {
      listenWebSocket({ token, userId });
    } else {
      console.log('No userId or token available in storage.');
    }
  });
});
