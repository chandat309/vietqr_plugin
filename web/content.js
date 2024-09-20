// content.js
const vietqrExtension = {
  // Initialize the extension
  init() {
    chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
      switch (request.action) {
        case 'showDialog':
          this.showTransactionDialog(request.transaction, request.transType);
          break;
        case 'speak':
          this.speakTransactionAmount(request.transaction, request.isSpeech);
          break;
        default:
          console.warn('Unknown action:', request.action);
      }
    });
  },

  // Function to show the transaction dialog
  showTransactionDialog(transaction, type) {
    this.loadStyles(chrome.runtime.getURL('dialog.css'));

    const existingDialog = document.querySelector('.vietqr-dialog');
    if (existingDialog) existingDialog.remove();

    const dialog = document.createElement('div');
    dialog.className = 'vietqr-dialog';
    dialog.innerHTML = this.createDialogHTML(transaction, type);

    document.body.appendChild(dialog);
    this.addDialogEventListeners(dialog);
  },

  isTransUnclassified(transaction) {
    return !transaction.terminalCode && !transaction.orderId;
  },

  createDialogHTML(transaction, transType) {
    const isUnclassified = this.isTransUnclassified(transaction);

    return `
      <div class="vietqr-popup">
        <div class="vietqr-popup-content">
          <span class="vietqr-close">&times;</span>
          <h3 class="transaction-title ${
            transaction.transType === 'C'
              ? isUnclassified
                ? 'incoming-unclassified'
                : 'incoming-classified'
              : 'outgoing'
          }">
            ${
              transaction.transType === 'C'
                ? isUnclassified
                  ? 'Giao dịch đến (+) không đối soát'
                  : 'Giao dịch đến (+) có đối soát'
                : 'Giao dịch đi (-)'
            }
          </h3>
          <div class="vietqr-amount ${
            transaction.transType === 'C'
              ? isUnclassified
                ? 'incoming-unclassified'
                : 'incoming-classified'
              : 'outgoing'
          }">
          ${transaction.transType === 'C' ? '&#43;' : '&minus;'} ${
      transaction.amount
    } VND</div>
          <div class="vietqr-transaction-details">
            <div class="vietqr-detail-row">
              <span class="vietqr-label">Tới tài khoản</span>
              <span class="vietqr-value">${transaction.bankAccount || ''}</span>
            </div>
            <div class="vietqr-detail-row">
              <span class="vietqr-label">Ngân hàng</span>
              <span class="vietqr-value">${transaction.bankName || ''}</span>
            </div>
            <div class="vietqr-detail-row">
              <span class="vietqr-label">Thời gian thanh toán</span>
              <span class="vietqr-value">${this.formatTransactionTimePaid(
                transaction.timePaid * 1000
              )}</span> 
            </div>
            <div class="vietqr-detail-row">
              <span class="vietqr-label">Mã đơn hàng</span>
              <span class="vietqr-value">${transaction.orderId || '-'}</span>
            </div>
            <div class="vietqr-detail-row">
              <span class="vietqr-label">Mã cửa hàng</span>
              <span class="vietqr-value">${
                transaction.terminalCode || '-'
              }</span>
            </div>
            ${
              transaction.terminalName &&
              `
                <div class="vietqr-detail-row">
                  <span class="vietqr-label">Tên cửa hàng</span>
                  <span class="vietqr-value">${transaction.terminalName}</span>
                </div>
              `
            }
            <div class="vietqr-detail-row">
              <span class="vietqr-label">Nội dung chuyển khoản</span>
              <span class="vietqr-value">${transaction.content || ''}</span>
            </div>
          </div>
          <div class="vietqr-buttons">
            <button class="vietqr-close-btn-bottom">Đóng</button>
          </div>
        </div>
      </div>
      `;
  },

  addDialogEventListeners(dialog) {
    const closeBtn = dialog.querySelector('.vietqr-close');
    const closeBtnBottom = dialog.querySelector('.vietqr-close-btn-bottom');

    const closeDialog = () => {
      dialog.remove();
      window.speechSynthesis.cancel();
    };

    closeBtn.addEventListener('click', closeDialog);
    closeBtnBottom.addEventListener('click', closeDialog);

    dialog.addEventListener('click', (e) => {
      if (e.target === dialog) closeDialog();
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') closeDialog();
    });

    setTimeout(closeDialog, 10000);
  },

  speakTransactionAmount(transaction, isSpeech) {
    if (!isSpeech) return;

    if ('speechSynthesis' in window) {
      const amountInText = this.formatAmount(
        transaction.amount.split(',').join('')
      );
      const speechText = `${
        transaction.transType === 'C'
          ? 'Bạn được nhận số tiền là'
          : 'Bạn vừa chuyển số tiền là'
      } ${amountInText} đồng, xin cảm ơn!`;
      const utterance = new SpeechSynthesisUtterance(speechText);
      utterance.lang = 'vi-VN';
      utterance.rate = 0.98;
      utterance.volume = 0.8;

      window.speechSynthesis.cancel();
      window.speechSynthesis.speak(utterance);
    } else {
      console.warn('Web Speech API is not supported in this browser.');
    }
  },

  formatAmount(amount) {
    const number = parseInt(amount);
    return number.toLocaleString('vi-VN', {
      style: 'currency',
      currency: 'VND'
    });
  },

  loadStyles(href) {
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = href;
    document.head.appendChild(link);
  },

  formatTransactionTimePaid(date) {
    const options = {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    };
    return new Date(date).toLocaleDateString('vi-VN', options);
  }
};

// Initialize the extension
vietqrExtension.init();
