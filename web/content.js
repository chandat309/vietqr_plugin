// Định nghĩa đường dẫn cho các file âm thanh
const audioFiles = {
  0: "audio/0.mp3",
  1: "audio/1.mp3",
  2: "audio/2.mp3",
  3: "audio/3.mp3",
  4: "audio/4.mp3",
  5: "audio/5.mp3",
  6: "audio/6.mp3",
  7: "audio/7.mp3",
  8: "audio/8.mp3",
  9: "audio/9.mp3",
  10: "audio/10.mp3",
  muoi: "audio/muoi.mp3",
  tram: "audio/tram.mp3",
  nghin: "audio/nghin.mp3",
  trieu: "audio/trieu.mp3",
  ty: "audio/ty.mp3",
  le: "audio/le.mp3",
  linh: "audio/linh.mp3",
  mot: "audio/mot.mp3",
  dong: "audio/dong.mp3",
};

// Tạo URL cho các file âm thanh
const audioURLs = {};
for (const [word, path] of Object.entries(audioFiles)) {
  audioURLs[word] = chrome.runtime.getURL(path);
}

// Hàm phát âm thanh cho một từ
function playAudio(word) {
  return new Promise((resolve) => {
    if (!audioURLs[word]) {
      console.error(`Không tìm thấy file âm thanh cho "${word}"`);
      resolve();
      return;
    }
    const audio = new Audio(audioURLs[word]);
    audio.onended = resolve;
    audio.play().catch((error) => {
      console.error(`Không thể phát âm thanh cho "${word}":`, error);
      resolve();
    });
  });
}

// Hàm đọc số tiền của các giao dịch
async function speakTransactions(transactions) {
  //   for (const transaction of transactions) {
  //     const amount = parseInt(transaction.amount.replace(/,/g, ""), 10);
  //     const amountWords = readVietnameseNumber(amount);
  //     //await playAudio('giao_dich_moi');
  //     for (const word of amountWords) {
  //       await playAudio(word);
  //     }
  //     await playAudio("dong");
  //   }
}

// Hàm chuyển đổi số thành các từ tiếng Việt
function readVietnameseNumber(number) {
  const units = ["", "nghin", "trieu", "ty"];
  const digits = ["khong", "mot", "2", "3", "4", "5", "6", "7", "8", "9"];

  if (number === 0) return ["0"];
  const result = [];
  let unitIndex = 0;
  while (number > 0) {
    const threeDigits = number % 1000;
    if (threeDigits > 0) {
      const words = readThreeDigits(threeDigits);
      if (unitIndex > 0) {
        words.push(units[unitIndex]);
      }
      result.unshift(...words);
    }
    number = Math.floor(number / 1000);
    unitIndex++;
  }
  return result;
}

// Hàm đọc ba chữ số
function readThreeDigits(number) {
  const digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  const result = [];
  const hundreds = Math.floor(number / 100);
  const tens = Math.floor((number % 100) / 10);
  const ones = number % 10;
  if (hundreds > 0) {
    if (hundreds === 1) {
      result.push("mot");
    } else {
      result.push(digits[hundreds]);
    }
    result.push("tram");
  }
  if (tens > 0 || ones > 0) {
    if (hundreds > 0 && tens === 0) {
      result.push("le");
    }
    if (tens === 1) {
      result.push("10");
    } else if (tens > 1) {
      result.push(digits[tens]);
      result.push("muoi");
    }
    if (ones > 0) {
      if (tens >= 2 && ones === 1) {
        result.push("mot");
      } else if (tens === 0 && ones === 1 && hundreds > 0) {
        result.push("mot");
      } else {
        result.push(digits[ones]);
      }
    }
  }
  return result;
}

// Hàm định dạng thời gian
function formatDate(timestamp) {
  const date = new Date(timestamp * 1000);

  const day = String(date.getDate()).padStart(2, "0");
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const year = date.getFullYear();
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");

  return `${day}/${month}/${year} ${hours}:${minutes}`;
}

// Hàm hiển thị dialog giao dịch
function showTransactionDialog(transaction) {
  // Xóa dialog cũ nếu có
  const existingDialog = document.querySelector(".vietqr-dialog");
  if (existingDialog) {
    existingDialog.remove();
  }

  // Tạo dialog mới
  const dialog = document.createElement("div");
  dialog.className = "vietqr-dialog";

  // Lấy giao dịch mới nhất (giả sử là giao dịch đầu tiên trong mảng)
  // const transaction = transactions[0];

  // Tạo nội dung HTML cho dialog
  const popupHTML = `
      <div class="popup">
        <div class="popup-content">
          <span class="close">&times;</span>
          <h3>Giao dịch thành công</h3>
          <div class="amount">+ ${transaction.amount} VND</div>
          <div class="transaction-details">
            <div class="detail-row">
              <span class="label">Đến TK</span>
              <span class="value">${transaction.bankAccount || ""}</span>
            </div>
            <div class="detail-row">
              <span class="label">Ngân hàng</span>
              <span class="value">${transaction.bankShortName || ""}</span>
            </div>
            <div class="detail-row">
              <span class="label">Thời gian</span>
              <span class="value">${
                transaction.time ? formatDate(transaction.timePaid) : ""
              }</span>
            </div>
            <div class="detail-row">
              <span class="label">Nội dung</span>
              <span class="value">${transaction.content || ""}</span>
            </div>
          </div>
          <div class="buttons">
            <button class="close-btn-bottom">Đóng</button>
          </div>
        </div>
      </div>
    `;

  dialog.innerHTML = popupHTML;
  document.body.appendChild(dialog);

  // Xử lý sự kiện đóng popup
  const closeBtn = dialog.querySelector(".close");
  closeBtn.addEventListener("click", function () {
    dialog.remove();
  });

  // Xử lý sự kiện cho nút đóng ở dưới
  const homeBtnBot = dialog.querySelector(".close-btn-bottom");

  homeBtnBot.addEventListener("click", function () {
    dialog.remove();
  });

  // Gọi hàm đọc số tiền
  //   speakTransactions([transaction]);
  // onSpeak(transaction.amount);
}

// Lắng nghe tin nhắn từ background script
chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
  if (request.action === "showDialog") {
    console.log("open dialog", request.transactions);
    showTransactionDialog(request.transactions);
  }

  if (request.action === "speak") {

    // const speechText = request.text;
    const currencyAmount = request.text.replace(/,/g, "");
    window.speechSynthesis.cancel();
    // Convert the currency amount to a spoken text
    const speechText =
      "Cảm ơn quý khách đã thanh toán số tiền " +
      currencyAmount.toString() +
      " đồng.";
    let utterance = new SpeechSynthesisUtterance(speechText);
    utterance.lang = "vi-VN";

    window.speechSynthesis.speak(utterance);
    sendResponse({ status: "spoken" });
  }
});
