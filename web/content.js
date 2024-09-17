// Listen for messages from background.js
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  switch (request.action) {
    case 'showDialog':
      showTransactionDialog(request?.transaction, request?.type);
      break;
    case 'speak':
      speakTransactionAmount(request?.text);
      break;
    default:
      console.warn('Unknown action:', request?.action);
  }
});

// Utility function to format date (assuming it's a Unix timestamp)
const formatDate = (date) => {
  const options = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  };
  return new Date(date).toLocaleDateString('vi-VN', options);
};

// Function to show the transaction dialog
const showTransactionDialog = (transaction, type) => {
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

// Generate HTML content for the dialog
const createDialogHTML = (transaction, type) => {
  console.log('transaction', transaction);
  return `
    <div class="vietqr-popup">
      <div class="vietqr-popup-content">
        <span class="vietqr-close">&times;</span>
        <h3>${
          type === '2' ? 'Giao dịch thành công' : 'Decrease Transaction'
        }</h3>
        <div class="vietqr-amount">${type === '2' ? '+' : '-'} ${
    transaction.amount
  } VND</div>
        <div class="vietqr-transaction-details">
          <div class="vietqr-detail-row">
            <span class="vietqr-label">To Account</span>
            <span class="vietqr-value">${transaction.bankAccount || ''}</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Bank</span>
            <span class="vietqr-value">${transaction.bankName || ''}</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Time</span>
            <span class="vietqr-value">${
              transaction.timePaid ? formatDate(transaction.timePaid) : ''
            }</span>
          </div>
          <div class="vietqr-detail-row">
            <span class="vietqr-label">Content</span>
            <span class="vietqr-value">${transaction.content || ''}</span>
          </div>
        </div>
        <div class="vietqr-buttons">
          <button class="vietqr-close-btn-bottom">Close</button>
        </div>
      </div>
    </div>`;
};

// Function to handle dialog events like close
const addDialogEventListeners = (dialog) => {
  const closeBtn = dialog.querySelector('.vietqr-close');
  const closeBtnBottom = dialog.querySelector('.vietqr-close-btn-bottom');

  // Close the dialog when close buttons are clicked
  const closeDialog = () => dialog.remove();

  // Add event listeners to close buttons
  closeBtn.addEventListener('click', closeDialog);
  closeBtnBottom.addEventListener('click', closeDialog);

  // Close the dialog when clicking outside the dialog
  dialog.addEventListener('click', (e) => {
    if (e.target === dialog) closeDialog();
  });
  // Close the dialog when pressing the Escape key
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeDialog();
  });
  // Close the dialog after 10 seconds
  // setTimeout(closeDialog, 10000);
};

// Function to speak the transaction amount using Web Speech API
const speakTransactionAmount = (amount) => {
  // 
  const speechText = `Tôi là Kiên mập ${amount} kí.`;
  const utterance = new SpeechSynthesisUtterance(speechText);
  utterance.lang = 'ko-KR'; // Set to Vietnamese

  // Stop any previous speech and speak the new text
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(utterance);
};
