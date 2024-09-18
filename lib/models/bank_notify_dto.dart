class BankNotifyDTO {
  final String userId;
  final String bankId;
  final List<String> notificationTypes;

  // Constructor
  BankNotifyDTO({
    required this.userId,
    required this.bankId,
    required this.notificationTypes,
  });

  // Factory method to create an instance from JSON
  factory BankNotifyDTO.fromJson(Map<String, dynamic> json) {
    return BankNotifyDTO(
      userId: json['userId'] as String,
      bankId: json['bankId'] as String,
      notificationTypes: List<String>.from(json['notificationTypes']),
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bankId': bankId,
      'notificationTypes': notificationTypes,
    };
  }
}
