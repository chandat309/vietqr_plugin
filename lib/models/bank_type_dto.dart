class BankTypeDTO {
  final String id;
  final String bankCode;
  final String bankName;
  final String bankShortName;
  final String imageId;
  final int status;
  final String caiValue;
  final int unlinkedType;

  const BankTypeDTO({
    required this.id,
    required this.bankCode,
    required this.bankName,
    required this.bankShortName,
    required this.imageId,
    required this.status,
    required this.caiValue,
    required this.unlinkedType,
  });

  factory BankTypeDTO.fromJson(Map<String, dynamic> json) {
    return BankTypeDTO(
      id: json['id'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      imageId: json['imageId'] ?? '',
      status: json['status'] ?? 0,
      caiValue: json['caiValue'] ?? '',
      unlinkedType: json['unlinkedType'] ?? 0,
    );
  }
}
