const onInit = () => {
    // Mảng lưu trữ các giao dịch đã xử lý trước đó
    let lastTransactions = [];

    const setToken = (token) => {
        alert(token);
    }

    const alertTransaction = (data) => {
        console.log('new data: ',typeof data);
        console.log('old data: ',lastTransactions);
        // const newTransactions = data.filter(transaction =>
        //     !lastTransactions.some(lastTransaction =>
        //         lastTransaction.transactionId === transaction.transactionId
        //     )
        // );
        //
        // if (newTransactions.length > 0) {
        //     // Tìm tất cả các tab đang mở trang kiotviet.vn
        //     chrome.tabs.query({url: "https://*.kiotviet.vn/*"}, function (tabs) {
        //         // Gửi thông báo đến từng tab
        //         tabs.forEach(tab => {
        //             chrome.tabs.sendMessage(tab.id, {action: "showDialog", transactions: newTransactions});
        //         });
        //     });
        //     // Cập nhật lastTransactions với dữ liệu mới nhất
            lastTransactions = data;
        // }
    }

    window._setToken = setToken;
    window._alertTransaction = alertTransaction;
}

window.onload = () => {
    onInit();
}