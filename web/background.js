// Mảng lưu trữ các giao dịch đã xử lý trước đó
let lastTransactions = [];

// Hàm chính để kiểm tra các giao dịch mới
async function checkForNewTransactions() {
    // Lấy ngày hôm nay
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');

    // Định dạng ngày cho URL (YYYY-MM-DD)
    const dateString = `${year}-${month}-${day}`;
    // Tạo URL API với ngày hôm nay
    const url = `https://api.vietqr.org/vqr/api/transactions/list?bankId=6a261989-ff95-4497-b5b8-a51135593e91&type=9&offset=0&value=&from=${dateString}%2000:00:00&to=${dateString}%2023:59:59`;

    // Token xác thực Bearer
    const Bearer = 'eyJhbGciOiJIUzUxMiJ9.eyJhZG1pbklkIjoic3lzdGVtLWFkbWluLTAxIiwibmFtZSI6IlN1cGVyIEFkbWluIiwicm9sZSI6MSwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTcyMDI1MjIxNCwiZXhwIjoxNzIxMTUyMjE0fQ.DsAIv7JTuSI84NqH4pjr4PjBbM-7Tz61UslW6oUjJezMp8MUH3QAm3ui4QnHnHIsjAXz21-Bug6D0uWeAUt0WA';

    // Gọi API để lấy danh sách giao dịch
    fetch(url, {
        headers: {
            'Authorization': 'Bearer ' + Bearer,
            'Content-Type': 'application/json'
        }
    })
        .then(response => response.json())
        .then(async data => {
            // Lọc ra các giao dịch mới bằng cách so sánh với lastTransactions
            const newTransactions = data.filter(transaction =>
                !lastTransactions.some(lastTransaction =>
                    lastTransaction.transactionId === transaction.transactionId
                )
            );

            // Nếu có giao dịch mới
            if (newTransactions.length > 0) {
                // Tìm tất cả các tab đang mở trang kiotviet.vn
                try {
                    let tabs = await chrome.tabs.query({url: "https://*.kiotviet.vn/*"});
                    // Cập nhật lastTransactions với dữ liệu mới nhất
                    lastTransactions = data;
                    tabs.forEach((tab) => {
                        try {
                            chrome.scripting.executeScript({
                                target: {tabId: tab.id},
                                files: ["content.js"]  // Replace with your content script file name
                            }, () => {
                                chrome.tabs.sendMessage(tab.id, {action: "showDialog", transactions: newTransactions});
                            });
                        } catch (error) {
                            console.error('Error injecting script:', error);
                        }
                    });
                } catch (error) {
                    console.error('Lỗi khi truy vấn tabs:', error);
                }
            }
        })
        .catch(error => console.error('Error:', error));
}

// Tạo một alarm để chạy hàm kiểm tra mỗi 5 giây (1/12 phút)
chrome.alarms.create('checkTransactions', {periodInMinutes: 1 / 12});

// Lắng nghe sự kiện alarm
chrome.alarms.onAlarm.addListener((alarm) => {
    // Nếu là alarm 'checkTransactions', gọi hàm kiểm tra
    if (alarm.name === 'checkTransactions') {
        checkForNewTransactions();
    }
});

// Chạy hàm kiểm tra lần đầu khi script được tải
checkForNewTransactions();