let ws;

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

async function connectWebSocket(userId, token) {
  if (!userId) {
    console.error("UserId is not set");
    return;
  }
  const url = `wss://api.vietqr.org/vqr/socket?userId=${userId}`;
  ws = new WebSocket(url);

  ws.onopen = () => {
    console.log("WebSocket connection opened");
    if (token) {
      ws.send(JSON.stringify({ type: "auth", token: token }));
    }
  };

  ws.onmessage = async (event) => {
    const message = JSON.parse(event.data);
    console.log("WebSocket message received:", message);
    if (message.notificationType == "N05" && message.transType == "C") {
      chrome.tabs.query({ active: true, currentWindow: true }, async (tabs) => {
        if (tabs.length === 0) return;

        const activeTab = tabs[0];
        const currentUrl = activeTab.url;

        // console.log("Current URL:", currentUrl);

        // Perform your URL checks here

        chrome.tabs.query({ active: true, currentWindow: true }, async (tabs) => {
          try {
            const activeTab = tabs[0];
            // console.log("URL: " + activeTab.url);

            chrome.scripting.executeScript(
              {
                target: { tabId: activeTab.id },
                files: ["content.js"], // Replace with your content script file name
              },
              async () => {
                await chrome.scripting.insertCSS({
                  target: { tabId: activeTab.id },
                  files: ["dialog.css"],
                });
                chrome.tabs.sendMessage(activeTab.id, {
                  action: "showDialog",
                  transactions: message,
                });
                chrome.tabs.sendMessage(activeTab.id, {
                  action: "speak",
                  text: message.amount,
                });
              }
            );
          } catch (error) {
            console.error("Error injecting script:", error);
          }
        });



      });

      // Cập nhật lastTransactions với dữ liệu mới nhất
    }
  };

  ws.onclose = () => {
    console.log("WebSocket connection closed");
  };

  ws.onerror = (error) => {
    console.error("WebSocket error:", error);
  };
}

async function logoutUser() {
  await chrome.storage.local.remove(["idUser", "bearerToken"]);
  // await chrome.storage.local.set({ idUser: null });
  // await chrome.storage.local.set({ bearerToken: null });
  // listenWss();
}

async function listenWss() {
  const storage = await chrome.storage.local.get(["idUser", "bearerToken"]);
  const idUser = storage.idUser;
  const bearerToken = storage.bearerToken;
  if (!idUser) {
    if (ws) {
      if (
        ws.readyState === WebSocket.OPEN ||
        ws.readyState === WebSocket.CONNECTING
      ) {
        ws.close();
        console.log("WebSocket is closed");
      }
    }
  } else {
    if (!ws || ws.readyState === WebSocket.CLOSED) {
      console.log("WebSocket is closed, reconnecting...");
      connectWebSocket(idUser, bearerToken);
    } else {
      // console.log("WebSocket is open, no need to reconnect.");
    }
  }
  setTimeout(listenWss, 1000);
}

chrome.runtime.onInstalled.addListener(async () => {
  listenWss();
});

// chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
//   if (request.action === "speak") {
//     const speechText = request.text;
//     let utterance = new SpeechSynthesisUtterance(speechText);
//     utterance.lang = "vi-VN";
//     window.speechSynthesis.speak(utterance);
//     sendResponse({ status: "spoken" });
//   }
// });

// chrome.runtime.onStartup.addListener(() => {
//   console.log("Browser startup detected");
//   listenWss();
// });

// chrome.runtime.onMessage.addListener(async (request, sender, sendResponse) => {
//   console.log("Message received:", request);
//   if (request.action === 'logout') {
//     if (ws) {
//       ws.close();
//       console.log("WebSocket connection closed due to logout");
//     }

//     await chrome.storage.local.remove(['idUser', 'bearerToken']);
//     sendResponse({ status: 'WebSocket closed and tokens reset' });
//   }
// });

// connectWebSocket();

// Hàm chính để kiểm tra các giao dịch mới
async function checkForNewTransactions() {
  // Lấy ngày hôm nay
  const today = new Date();
  const year = today.getFullYear();
  const month = String(today.getMonth() + 1).padStart(2, "0");
  const day = String(today.getDate()).padStart(2, "0");

  // Định dạng ngày cho URL (YYYY-MM-DD)
  const dateString = `${year}-${month}-${day}`;
  // Tạo URL API với ngày hôm nay
  const url = `https://api.vietqr.org/vqr/api/transactions/list?bankId=b93246bb-3b94-492e-a774-5ef50c4b619d&type=5&offset=0&value=1&from=${dateString}%2000:00:00&to=${dateString}%2023:59:59`;

  // Token xác thực Bearer
  const Bearer =
    "eyJhbGciOiJIUzUxMiJ9.eyJ1c2VySWQiOiI2NDhkY2EwNi00ZjcyLTRkZjgtYjk4Zi00MjlmNDc3N2ZiZGEiLCJwaG9uZU5vIjoiMDM3MzU2ODk0NCIsImZpcnN0TmFtZSI6IkxpbmgiLCJtaWRkbGVOYW1lIjoiTmjhuq10IiwibGFzdE5hbWUiOiJOZ3V54buFbiIsImJpcnRoRGF0ZSI6IjI2LzAyLzIwMDEiLCJnZW5kZXIiOjEsImFkZHJlc3MiOiJTYWkgZ29uIiwiZW1haWwiOiJ2YW5wcXNlMTUwNTA1QGZwdC5lZHUudm4iLCJpbWdJZCI6IiIsImNhcnJpZXJUeXBlSWQiOiIxIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTcyMDM2NzEyNn0.dzUs9zImK2Gu0-zmaIZVKBcOMJfM97LngRPDZ5nQunK5d8XJpdchWDHyLM-7jxbVNVs7zh5PgsmydkfqrCFR2g";

  // Gọi API để lấy danh sách giao dịch
  fetch(url, {
    headers: {
      Authorization: "Bearer " + Bearer,
      "Content-Type": "application/json",
    },
  })
    .then((response) => response.json())
    .then(async (data) => {
      // Lọc ra các giao dịch mới bằng cách so sánh với lastTransactions
      const newTransactions = data.filter(
        (transaction) =>
          !lastTransactions.some(
            (lastTransaction) =>
              lastTransaction.transactionId === transaction.transactionId
          )
      );

      // Nếu có giao dịch mới
      // if (newTransactions.length > 0) {
      //   // Tìm tất cả các tab đang mở trang kiotviet.vn
      //   try {
      //     let tabs = await chrome.tabs.query({
      //       url: "https://*.kiotviet.vn/*",
      //     });
      //     // Cập nhật lastTransactions với dữ liệu mới nhất
      //     lastTransactions = data;
      //     tabs.forEach((tab) => {
      //       try {
      //         chrome.scripting.executeScript(
      //           {
      //             target: { tabId: tab.id },
      //             files: ["content.js"], // Replace with your content script file name
      //           },
      //           () => {
      //             chrome.tabs.sendMessage(tab.id, {
      //               action: "showDialog",
      //               transactions: newTransactions,
      //             });
      //           }
      //         );
      //       } catch (error) {
      //         console.error("Error injecting script:", error);
      //       }
      //     });
      //   } catch (error) {
      //     console.error("Lỗi khi truy vấn tabs:", error);
      //   }
      // }
      if (newTransactions.length > 0) {
        try {
          let tabs = await chrome.tabs.query({});
          lastTransactions = data;
          tabs.forEach((tab) => {
            try {
              chrome.scripting.executeScript(
                {
                  target: { tabId: tab.id },
                  files: ["content.js"], // Replace with your content script file name
                },
                () => {
                  chrome.tabs.sendMessage(tab.id, {
                    action: "showDialog",
                    transactions: newTransactions,
                  });
                }
              );
            } catch (error) {
              console.error("Error injecting script:", error);
            }
          });
        } catch (error) {
          console.error("Error querying tabs:", error);
        }
      }
    })
    .catch((error) => console.error("Error:", error));
}
