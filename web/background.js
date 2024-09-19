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
  // const result = await chrome.storage.local.get("listBank");

  // if (result.listBank) {
  //   console.log("Check", result);
  //   await chrome.storage.local.remove("listBank");
  // }

  // Set the new listBank
  await chrome.storage.local.set({ listBank: list });
  // const newResult = await chrome.storage.local.get("listBank");
  // console.log("Check", newResult);
}
async function setListBankNotify(list) {
  // const result = await chrome.storage.local.get("listBankNotify");

  // if (result.listBank) {
  //   await chrome.storage.local.remove("listBankNotify");
  // }

  await chrome.storage.local.set({ listBankNotify: list });
  console.log("ListEnable:", list);
}

async function logoutUser() {
  await chrome.storage.local.remove([
    "idUser",
    "bearerToken",
    "listBank",
    "listBankNotify",
  ]);
}

const clearLocalStorageInterval = () => {
  if (getLocalStorageInterval) clearInterval(getLocalStorageInterval);
};

// Boolean to check if the popup is open
const isPopupOpen = (listBankNotify, transaction) => {
  const arrayBankNotify =
    typeof listBankNotify === "string"
      ? JSON.parse(listBankNotify)
      : listBankNotify;

  return arrayBankNotify?.some((bankNotify) => {
    const listNotificationTypes = bankNotify.notificationTypes
      .replace(/[\[\]]/g, "")
      .split(",");
    const isMatchingBank = bankNotify.bankId === transaction.bankId;

    return (
      isMatchingBank &&
      listNotificationTypes.some((notificationType) => {
        switch (notificationType.trim()) {
          case "CREDIT":
            return transaction.transType === "C";
          case "DEBIT":
            return transaction.transType === "D";
          case "RECON":
            return (
              transaction.transType === "C" &&
              (transaction.type === 1 || transaction.type === 0)
            );
          default:
            return false;
        }
      })
    );
  });
};

const speakTransactionAmount = (transaction, isSpeech) => {
  console.log("isSpeech", isSpeech);
  if (!isSpeech) return;
  if (isSpeech) {
    if ("speechSynthesis" in window) {
      const amountInText = formatAmount(transaction.amount.split(",").join(""));
      const speechText = `${
        transaction?.transType === "C"
          ? "Bạn được nhận số tiền là" // LinhNPN _ KienNH
          : "Bạn vừa chuyển số tiền là" // KienNH
      } ${amountInText} đồng, xin cảm ơn!`;
      const utterance = new SpeechSynthesisUtterance(speechText);
      utterance.lang = "vi-VN"; // Set to Vietnamese
      utterance.rate = 0.98; // Set speech rate
      utterance.volume = 0.8; // Set speech volume

      // Stop any previous speech and speak the new text
      window.speechSynthesis.cancel();
      window.speechSynthesis.speak(utterance);
    } else {
      console.warn("Web Speech API is not supported in this browser.");
    }
  }
};

const formatAmount = (amount) => {
  const number = parseInt(amount);
  // console.log('number', number);
  return number.toLocaleString("vi-VN", {
    style: "currency",
    currency: "VND",
  });
};

const listenWebSocket = ({ token, userId, listBank, listBankNotify }) => {
  if (socketInstance) {
    console.log("WebSocket already initialized");
    socketInstance.close();
    socketInstance = null;
  }

  socketInstance = new WebSocket(
    `wss://api.vietqr.org/vqr/socket?userId=${userId}`
  );

  socketInstance.onopen = () => {
    const message = JSON.stringify({
      type: "auth",
      token,
    });
    socketInstance?.send(message);
    console.log("WebSocket connection established");
    console.log("WebSocket message sent:", message);
  };

  socketInstance.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log("WebSocket message received:", data);

    if (data.notificationType === "N05") {
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        if (tabs.length > 0) {
          const activeTab = tabs[0].id;
          chrome.scripting.executeScript(
            {
              target: { tabId: activeTab },
              files: ["content.js"],
            },
            () => {
              // chrome.tabs.sendMessage(activeTab, {
              //   action: 'showDialog',
              //   transaction: data
              // });

              chrome.tabs.sendMessage(activeTab, {
                action: "showDialog",
                transaction: data,
              });
              const bankList = listBank
                .replace(/[\[\]]/g, "")
                .split(",")
                .map((item) => item.replace(/['"]/g, "").trim());
              console.log("bankList", bankList);

              const bankFound = bankList.includes(data.bankId);
              console.log("bankFound", bankFound);
              if (bankFound && bankFound === true) {
                // speakTransactionAmount(data, bankFound && bankFound === true);
                chrome.tabs.sendMessage(activeTab, {
                  action: "speak",
                  transaction: data,
                  text: data.amount,
                  isSpeech: bankFound && bankFound === true,
                });
              }

              //   chrome.tabs.sendMessage(activeTab, {
              //   action: "speak",
              //   transaction: data,
              //   text: data.amount,
              //   isSpeech: bankFound,
              // });
              // console.log("lítBank", listBank);
              // console.log("bankId", data.bankId);

              // if (isPopupOpen(listBankNotify, data)) {
              //   chrome.tabs.sendMessage(activeTab, {
              //     action: "showDialog",
              //     transaction: data,
              //   });
              //   chrome.tabs.sendMessage(activeTab, {
              //     action: "speak",
              //     transaction: data,
              //     text: data.amount,
              //     isSpeech: listBank?.includes(data.bankId),
              //   });
              // }

              // // Check if listBank is not null
              // if (listBank && listBank.includes(data.bankId)) {
              // } else {
              //   console.warn('Bank not in list:', data.bankId);
              // }
            }
          );
        }
      });
    }
  };

  socketInstance.onerror = (error) => {
    console.error("WebSocket error:", error);
  };

  socketInstance.onclose = (event) => {
    console.log("WebSocket closed:", event);
    socketInstance = null;
    if (reconnectAttempts < 5) {
      setTimeout(() => {
        reconnectAttempts++;
        listenWebSocket({ token, userId, listBank, listBankNotify });
      }, Math.pow(2, reconnectAttempts) * 1000); // Exponential backoff
    }
  };
};

const checkStorageAndListenWebSocket = async () => {
  const getStorageData = () => {
    return new Promise((resolve, reject) => {
      chrome.storage.local.get(
        ["idUser", "bearerToken", "listBank", "listBankNotify"],
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
  try {
    const retrieveAndProcessData = async () => {
      const result = await getStorageData();
      const { idUser, bearerToken, listBank, listBankNotify } = result;
      // console.log('Storage retrieved', result);

      if (!idUser) {
        getLocalStorageInterval = setInterval(async () => {
          try {
            const getStorage = await getStorageData();
            const { idUser, bearerToken, listBank, listBankNotify } = getStorage;
            // const result = await getStorageData();
            // const { idUser, bearerToken, listBank, listBankNotify } = result;
            if (idUser) {
              listenWebSocket({
                token: bearerToken,
                userId: idUser,
                listId: listBank,
                listBankNotify: listBankNotify,
              });
              clearInterval(getLocalStorageInterval); // Clear the interval if idUser is found
            }
          } catch (error) {
            console.error("Error retrieving storage data:", error);
          }
        }, 3000);
      } else {
        listenWebSocket({
          token: bearerToken,
          userId: idUser,
          listBank: listBank,
          listBankNotify: listBankNotify,
        });
      }
    };

    await retrieveAndProcessData();
  } catch (error) {
    console.error("Error:", error);
  }
};

// Handle extension installation and startup
chrome.runtime.onInstalled.addListener(() => {
  console.log("Extension installed/reloaded");
  checkStorageAndListenWebSocket();
});

chrome.runtime.onStartup.addListener(() => {
  console.log("Extension started");
  checkStorageAndListenWebSocket();
});

// Clean up WebSocket when the extension is suspended
chrome.runtime.onSuspend.addListener(() => {
  console.log("Extension is being suspended. Cleaning up...");
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

  console.log("LocalStorage changed:", changes);

  if (listBank || listBankNotify) {
    console.log("LocalStorage changed:", changes);

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
