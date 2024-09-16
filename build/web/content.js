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
    <div class="popup">
      <div class="popup-content">
        <span class="close">&times;</span>
        <h3>Giao dịch thành công</h3>
        <div class="amount">+ ${transaction.amount} VND</div>
        <div class="transaction-details">
          <div class="detail-row">
            <span class="label">Đến TK</span>
            <span class="value">${transaction.bankAccount || ''}</span>
          </div>
          <div class="detail-row">
            <span class="label">Ngân hàng</span>
            <span class="value">${transaction.bankName || ''}</span>
          </div>
          <div class="detail-row">
            <span class="label">Thời gian</span>
            <span class="value">${
              transaction.time ? formatDate(transaction.timePaid) : ''
            }</span>
          </div>
          <div class="detail-row">
            <span class="label">Nội dung</span>
            <span class="value">${transaction.content || ''}</span>
          </div>
        </div>
        <div class="buttons">
          <button class="close-btn-bottom">Đóng</button>
        </div>
      </div>
    </div>`;
}

// Function to handle dialog events like close
function addDialogEventListeners(dialog) {
  const closeBtn = dialog.querySelector('.close');
  const closeBtnBottom = dialog.querySelector('.close-btn-bottom');

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
