class BankAccountInsertDTO {
  final String bankTypeId;
  final String bankAccount;
  final String userBankName;
  final String userId;
  final String nationalId;
  final String phoneAuthenticated;

  BankAccountInsertDTO(
      {required this.bankTypeId,
      required this.bankAccount,
      required this.userBankName,
      required this.userId,
      required this.nationalId,
      required this.phoneAuthenticated});

  factory BankAccountInsertDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountInsertDTO(
        bankTypeId: json['bankTypeId'],
        bankAccount: json['bankAccount'],
        userBankName: json['userBankName'],
        userId: json['userId'],
        nationalId: json['nationalId'],
        phoneAuthenticated: json['phoneAuthenticated']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankTypeId'] = bankTypeId;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['userId'] = userId;
    data['nationalId'] = nationalId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    return data;
  }
}
