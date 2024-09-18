class BankEnableType {
  final String bankId;
  final String notificationTypes;

  // Constructor
  BankEnableType({
    required this.bankId,
    this.notificationTypes = '',
  });

  // Factory method to create an instance from JSON
  factory BankEnableType.fromJson(Map<String, dynamic> json) {
    return BankEnableType(
      bankId: json['bankId'],
      notificationTypes: json['notificationTypes'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'notificationTypes': notificationTypes,
    };
  }
}
