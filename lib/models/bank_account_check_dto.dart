class BankAccountCheckDTO {
  final String bankAccount;
  final String bankTypeId;
  final String userId;
  final String type;

  const BankAccountCheckDTO({
    required this.bankAccount,
    required this.bankTypeId,
    required this.userId,
    required this.type,
  });
}
