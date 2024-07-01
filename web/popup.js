document.addEventListener('DOMContentLoaded', function () {
  // Lấy danh sách giao dịch gần đây (giả sử)
  const recentTransactions = [
    { amount: '100,000', time: '2024-06-24 10:30' },
    { amount: '200,000', time: '2024-06-24 11:45' }
  ];

  // const transactionList = document.getElementById('transactionList');
  // recentTransactions.forEach(transaction => {
  //   const li = document.createElement('li');
  //   li.textContent = `${transaction.amount} VND - ${transaction.time}`;
  //   transactionList.appendChild(li);
  // });

  // Xử lý cài đặt
  // Lưu cài đặt
  chrome.storage.sync.set({
    notificationSound: true,
    desktopNotification: true
  }, function () {
    console.log('Cài đặt đã được lưu');
  });
  // const settingsBtn = document.getElementById('settingsBtn');
  // settingsBtn.addEventListener('click', function () {
  //   const notificationSound = document.getElementById('notificationSound').checked;
  //   const desktopNotification = document.getElementById('desktopNotification').checked;


  // });

  // Tải cài đặt khi mở popup
  // chrome.storage.sync.get(['notificationSound', 'desktopNotification'], function (result) {
  //   document.getElementById('notificationSound').checked = result.notificationSound || false;
  //   document.getElementById('desktopNotification').checked = result.desktopNotification || false;
  // });
});