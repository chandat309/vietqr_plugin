chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'showDialog') {
    showTransactionDialog(request.transaction); // Call the function to show dialog
  }
});

// Hàm hiển thị dialog giao dịch
function showTransactionDialog(transaction) {
  // Xóa dialog cũ nếu có
  const existingDialog = document.querySelector('.vietqr-dialog');
  if (existingDialog) {
    existingDialog.remove();
  }

  // Tạo dialog mới
  const dialog = document.createElement('div');
  dialog.className = 'vietqr-dialog';

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
      </div>
    `;

  dialog.innerHTML = popupHTML;
  document.body.appendChild(dialog);

  // Xử lý sự kiện đóng popup
  const closeBtn = dialog.querySelector('.close');
  closeBtn.addEventListener('click', function () {
    dialog.remove();
  });

  // Xử lý sự kiện cho nút đóng ở dưới
  const homeBtnBot = dialog.querySelector('.close-btn-bottom');

  homeBtnBot.addEventListener('click', function () {
    dialog.remove();
  });

  // Gọi hàm đọc số tiền
  //   speakTransactions([transaction]);
  // onSpeak(transaction.amount);
}
