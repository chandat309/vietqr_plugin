// Listen for messages from background.js
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  switch (request.action) {
    case 'showDialog':
      showTransactionDialog(request?.transaction);
      break;
    case 'speak':
      speakTransactionAmount(request?.text);
      break;
    default:
      console.warn('Unknown action:', request?.action);
  }
});

// Function to show the transaction dialog
function showTransactionDialog(transaction) {
  // Remove any existing dialog to prevent duplication
  const existingDialog = document.querySelector('.vietqr-dialog');
  if (existingDialog) existingDialog.remove();

  // Create the dialog element
  const dialog = document.createElement('div');
  dialog.className = 'vietqr-dialog';
  dialog.innerHTML = createDialogHTML(transaction);

  document.body.appendChild(dialog);

  // Add event listeners to close the dialog
  addDialogEventListeners(dialog);
}

// Generate HTML content for the dialog
function createDialogHTML(transaction) {
  return `
    <div class="vietqr-popup">
      <div class="vietqr-popup-content">
        <span class="close">&times;</span>
        <h3>Giao dịch thành công</h3>
        <div class="vietqr-amount">+ ${transaction.amount} VND</div>
        <div class="vietqr-transaction-details">
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Đến TK</span>
            <span class="vietqr-value">${transaction.bankAccount || ''}</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Ngân hàng</span>
            <span class="vietqr-value">${transaction.bankName || ''}</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Thời gian</span>
            <span class="vietqr-value">${
              transaction.time ? formatDate(transaction.timePaid) : ''
            }</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Nội dung</span>
            <span class="vietqr-value">${transaction.content || ''}</span>
          </div>
        </div>
        <div class="vietqr-buttons">
          <button class="vietqr-close-btn-bottom">Đóng</button>
        </div>
      </div>
    </div>`;
}

// Function to handle dialog events like close
function addDialogEventListeners(dialog) {
  const closeBtn = dialog.querySelector('.vietqr-close');
  const closeBtnBottom = dialog.querySelector('.vietqr-close-btn-bottom');

  // Close the dialog when close buttons are clicked
  const closeDialog = () => dialog.remove();

  closeBtn.addEventListener('click', closeDialog);
  closeBtnBottom.addEventListener('click', closeDialog);
}

// Function to speak the transaction amount using Web Speech API
function speakTransactionAmount(amount) {
  const speechText = `Số tiền giao dịch của bạn là ${amount} đồng.`;
  const utterance = new SpeechSynthesisUtterance(speechText);
  utterance.lang = 'vi-VN'; // Set to Vietnamese

  // Stop any previous speech and speak the new text
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(utterance);
}

// Utility function to format date (assuming it's a Unix timestamp)
function formatDate(timestamp) {
  const date = new Date(timestamp * 1000); // Multiply by 1000 to convert seconds to milliseconds
  const day = String(date.getDate()).padStart(2, '0');
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const year = date.getFullYear();
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');

  return `${day}/${month}/${year} ${hours}:${minutes}`;
}
