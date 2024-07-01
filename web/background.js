// Mảng lưu trữ các giao dịch đã xử lý trước đó
let lastTransactions = [];

// Hàm chính để kiểm tra các giao dịch mới
function checkForNewTransactions() {
  // Lấy ngày hôm nay
  const today = new Date();
  const year = today.getFullYear();
  const month = String(today.getMonth() + 1).padStart(2, '0');
  const day = String(today.getDate()).padStart(2, '0');

  // Định dạng ngày cho URL (YYYY-MM-DD)
  const dateString = `${year}-${month}-${day}`;

  // Tạo URL API với ngày hôm nay
  const url = `https://api.vietqr.org/vqr/api/transactions/list?bankId=95364bee-3bc5-4070-96b1-1dbc3c9b8c19&type=9&offset=0&value=&from=${dateString}%2000:00:00&to=${dateString}%2023:59:59`;

  // Token xác thực Bearer
  const Bearer = 'eyJhbGciOiJIUzUxMiJ9.eyJ1c2VySWQiOiIyNDg4OWIwZS00YWRjLTQ0NTMtYjIwYy05ZDVlOTk0NmE4MjAiLCJwaG9uZU5vIjoiMDM3MzU2ODk0NCIsImZpcnN0TmFtZSI6IkxpbmgiLCJtaWRkbGVOYW1lIjoiTmjDosyjdCIsImxhc3ROYW1lIjoiTmd1eeG7hW4iLCJiaXJ0aERhdGUiOiIxOC8xMS8yMDAxIiwiZ2VuZGVyIjowLCJhZGRyZXNzIjoiIiwiZW1haWwiOiIiLCJpbWdJZCI6IjA3NWFiZTM3LTY0NDQtNDNlNS05ZDEzLWQ1NGViZmM3MmNlMiIsImNhcnJpZXJUeXBlSWQiOiIxIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTcxOTgyMjY4NCwiZXhwIjoxNzIwNzIyNjg0fQ.B0oAUFP5zrGSwXaBd6CYMvy_Py_TCe3P7pKGi1ZzdyWc1BQ8jG8PMcll5VMe3O8P2UexF9uuinPD00ZZ3SToQg';

  // Gọi API để lấy danh sách giao dịch
  fetch(url, {
    headers: {
      'Authorization': 'Bearer ' + Bearer,
      'Content-Type': 'application/json'
    }
  })
    .then(response => response.json())
    .then(data => {
      // Lọc ra các giao dịch mới bằng cách so sánh với lastTransactions
      const newTransactions = data.filter(transaction =>
        !lastTransactions.some(lastTransaction =>
          lastTransaction.transactionId === transaction.transactionId
        )
      );

      // Nếu có giao dịch mới
      if (newTransactions.length > 0) {
        // Tìm tất cả các tab đang mở trang kiotviet.vn
        chrome.tabs.query({ url: "https://*.kiotviet.vn/*" }, function (tabs) {
          // Gửi thông báo đến từng tab
          tabs.forEach(tab => {
            chrome.tabs.sendMessage(tab.id, { action: "showDialog", transactions: newTransactions });
          });
        });
        // Cập nhật lastTransactions với dữ liệu mới nhất
        lastTransactions = data;
      }
    })
    .catch(error => console.error('Error:', error));
}

// Tạo một alarm để chạy hàm kiểm tra mỗi 5 giây (1/12 phút)
chrome.alarms.create('checkTransactions', { periodInMinutes: 1 / 12 });

// Lắng nghe sự kiện alarm
chrome.alarms.onAlarm.addListener((alarm) => {
  // Nếu là alarm 'checkTransactions', gọi hàm kiểm tra
  if (alarm.name === 'checkTransactions') {
    checkForNewTransactions();
  }
});

// Chạy hàm kiểm tra lần đầu khi script được tải
checkForNewTransactions();