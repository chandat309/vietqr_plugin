// Mảng lưu trữ các giao dịch đã xử lý trước đó

let bearerToken = null;
let idUser = null;

async function setUserId(userId) {
  idUser = userId;
  // console.log("UserId:", userId);
}

async function setToken(token) {
  bearerToken = token;
  // console.log("Bearer:", bearerToken);
}

function convertCurrencyToText(amount) {
  // Convert the number to a string and add " đồng" (Vietnamese currency unit)
  return "Cảm ơn quý khách đã thanh toán " + amount.toString() + " đồng";
}

function onSpeak(amount) {
  // Remove commas from the input for proper conversion
  const currencyAmount = amount.replace(/,/g, "");

  // Convert the currency amount to a spoken text
  const speechText = convertCurrencyToText(currencyAmount);
  console.log("Amount:", speechText);

  // Create a new SpeechSynthesisUtterance object
  const utterance = new SpeechSynthesisUtterance(speechText);

  // Set the language to Vietnamese
  utterance.lang = "vi-VN";

  // Speak the text
  window.speechSynthesis.speak(utterance);
  console.log("TTS");
}

async function connectWebSocket() {
  if (!idUser) {
    console.error("UserId is not set");
    return;
  }
  const url = `wss://api.vietqr.org/vqr/socket?userId=${idUser}`;
  const ws = new WebSocket(url);

  ws.onopen = () => {
    console.log("WebSocket connection opened");
    if (bearerToken) {
      ws.send(JSON.stringify({ type: "auth", token: bearerToken }));
    }
  };

  ws.onmessage = async (event) => {
    const message = JSON.parse(event.data);
    console.log("WebSocket message received:", message);
    if (message.notificationType == "N05" && message.transType == "C") {
      let tabs = await chrome.tabs.query({
        url: "https://*.kiotviet.vn/*",
      });
      // Cập nhật lastTransactions với dữ liệu mới nhất
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
                transactions: message,
              });
            }
          );
        } catch (error) {
          console.error("Error injecting script:", error);
        }
      });
      onSpeak(message.amount)
    }
  };

  ws.onclose = () => {
    console.log("WebSocket connection closed");
  };

  ws.onerror = (error) => {
    console.error("WebSocket error:", error);
  };
}

chrome.runtime.onInstalled.addListener(() => {
  connectWebSocket();
});

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
      if (newTransactions.length > 0) {
        // Tìm tất cả các tab đang mở trang kiotviet.vn
        try {
          let tabs = await chrome.tabs.query({
            url: "https://*.kiotviet.vn/*",
          });
          // Cập nhật lastTransactions với dữ liệu mới nhất
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
          console.error("Lỗi khi truy vấn tabs:", error);
        }
      }
    })
    .catch((error) => console.error("Error:", error));
}

// // Tạo một alarm để chạy hàm kiểm tra mỗi 5 giây (1/12 phút)
// // chrome.alarms.create('checkTransactions', { periodInMinutes: 1 / 12 });

// // // Lắng nghe sự kiện alarm
// // chrome.alarms.onAlarm.addListener((alarm) => {
// //     // Nếu là alarm 'checkTransactions', gọi hàm kiểm tra
// //     if (alarm.name === 'checkTransactions') {
// //         checkForNewTransactions();
// //     }
// // });

// // Chạy hàm kiểm tra lần đầu khi script được tải
// checkForNewTransactions();

// background.js
// background.js
// const triggerSetToken = (token) => {
//     if (window._setToken) {
//         window._setToken(token);
//     } else {
//         console.error('Function _setToken is not defined');
//     }
// }

// const logUserId = () => {
//     if (window._setUserId) {
//         window._setUserId();
//     } else {
//         console.error('Function _setUseId is not defined');
//     }
// }

// const triggerConnectWebSocket = () => {
//     if (window._connectWebSocket) {
//         window._connectWebSocket();
//     } else {
//         console.error('Function _connectWebSocket is not defined');
//     }
// }

// logUserId();
// triggerConnectWebSocket();
