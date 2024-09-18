// Utility function to format date
const formatTransactionDate = (date) => {
  const options = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  };
  return new Date(date).toLocaleDateString('vi-VN', options);
};

// Function to dynamically load the CSS file
const loadStyles = (href) => {
  const link = document.createElement('link');
  link.rel = 'stylesheet';
  link.href = href;
  document.head.appendChild(link);
};

// Listen for messages from background.js
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  switch (request.action) {
    case 'showDialog':
      showTransactionDialog(request?.transaction, request?.transType);
      break;
    case 'speak':
      speakTransactionAmount(request?.transaction, request?.isSpeech);
      break;
    default:
      console.warn('Unknown action:', request?.action);
  }
});

// Function to show the transaction dialog
const showTransactionDialog = (transaction, type) => {
  // Load the CSS file
  loadStyles(chrome.runtime.getURL('dialog.css'));

  // Remove any existing dialog to prevent duplication
  const existingDialog = document.querySelector('.vietqr-dialog');
  if (existingDialog) existingDialog.remove();

  // Create the dialog element
  const dialog = document.createElement('div');
  dialog.className = 'vietqr-dialog';

  // Define dialog content based on type
  const dialogContent = createDialogHTML(transaction, type);
  dialog.innerHTML = dialogContent;

  // Append dialog to body
  document.body.appendChild(dialog);

  // Add event listeners to close the dialog
  addDialogEventListeners(dialog);
};

// Function to check if a transaction is unclassified
const isTransUnclassified = (transaction) => {
  return !transaction.terminalCode && !transaction.orderId;
};

// Generate HTML content for the dialog
const createDialogHTML = (transaction, transType) => {
  // console.log('transaction', transaction);
  const isUnclassified = isTransUnclassified(transaction);

  return `
    <div class="vietqr-popup">
      <div class="vietqr-popup-content">
        <span class="vietqr-close">&times;</span>
      <h3 class="transaction-title ${
        transaction?.transType === 'C'
          ? isUnclassified
            ? 'incoming-unclassified'
            : 'incoming-classified'
          : 'outgoing'
      }">
          ${
            transaction?.transType === 'C'
              ? isUnclassified
                ? 'Giao dịch đến (+) không đối soát'
                : 'Giao dịch đến (+) có đối soát'
              : 'Giao dịch đi (-)'
          }
        </h3>
        <div class="vietqr-amount ${
          transaction?.transType === 'C'
            ? isUnclassified
              ? 'incoming-unclassified'
              : 'incoming-classified'
            : 'outgoing'
        }">
        ${transaction?.transType === 'C' ? '&#43;' : '&minus;'} ${
    transaction?.amount
  } VND</div>
        <div class="vietqr-transaction-details">
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Tới tài khoản</span>
            <span class="vietqr-value">${transaction?.bankAccount || ''}</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Ngân hàng</span>
            <span class="vietqr-value">${transaction?.bankName || ''}</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Thời gian thanh toán</span>
            <span class="vietqr-value">${formatTransactionDate(
              transaction?.timePaid * 1000
            )}</span> 
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Mã đơn hàng</span>
            <span class="vietqr-value">${transaction?.orderId || '-'}</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Mã cửa hàng</span>
            <span class="vietqr-value">${
              transaction?.terminalCode || '-'
            }</span>
          </div>
          ${
            transaction?.terminalName &&
            `
              <div class="vietqr-detail-row">
                <span class="vietqr-label">Mã đơn hàng</span>
                <span class="vietqr-value">${transaction?.terminalName}</span>
              </div>
            `
          }
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Nội dung chuyển khoản</span>
            <span class="vietqr-value">${transaction?.content || ''}</span>
          </div>
        </div>
        <div class="vietqr-buttons">
          <button class="vietqr-close-btn-bottom">Đóng</button>
        </div>
      </div>
    </div>
    `;
};

// Function to handle dialog events like close
const addDialogEventListeners = (dialog) => {
  const closeBtn = dialog.querySelector('.vietqr-close');
  const closeBtnBottom = dialog.querySelector('.vietqr-close-btn-bottom');

  // Close the dialog when close buttons are clicked
  const closeDialog = () => {
    dialog.remove();
    window.speechSynthesis.cancel();
  };

  // Add event listeners to close buttons
  closeBtn.addEventListener('click', closeDialog);
  closeBtnBottom.addEventListener('click', closeDialog);

  // Close the dialog when clicking outside the dialog
  dialog.addEventListener('click', (e) => {
    if (e.target === dialog) {
      closeDialog();
    }
  });
  // Close the dialog when pressing the Escape key
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeDialog();
    }
  });
  // Close the dialog after 10 seconds
  setTimeout(closeDialog, 10000);
};

// Function to speak the transaction amount using Web Speech API
const speakTransactionAmount = (transaction, isSpeech) => {
  // if (!isSpeech) return;
  // if (isSpeech) {
  if ('speechSynthesis' in window) {
    const amountInText = formatAmount(transaction.amount.split(',').join(''));
    const speechText = `${
      transaction?.transType === 'C'
        ? 'Bạn được nhận số tiền là' // LinhNPN _ KienNH
        : 'Bạn vừa chuyển số tiền là' // KienNH
    } ${amountInText} đồng, xin cảm ơn!`;
    const utterance = new SpeechSynthesisUtterance(speechText);
    utterance.lang = 'vi-VN'; // Set to Vietnamese
    utterance.rate = 0.98; // Set speech rate
    utterance.volume = 0.8; // Set speech volume

    // Stop any previous speech and speak the new text
    window.speechSynthesis.cancel();
    window.speechSynthesis.speak(utterance);
  } else {
    console.warn('Web Speech API is not supported in this browser.');
  }
  // }
};

const formatAmount = (amount) => {
  const number = parseInt(amount);
  // console.log('number', number);
  return number.toLocaleString('vi-VN', {
    style: 'currency',
    currency: 'VND'
  });
};
