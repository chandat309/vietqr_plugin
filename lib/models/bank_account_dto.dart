import 'package:flutter/material.dart';

class BankAccountDTO {
  final String bankId;
  final String bankAccount;
  final String userBankName;
  final String bankShortName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final int type;
  final String bankTypeId;
  final String nationalId;
  final String phoneAuthenticated;
  final String userId;
  final bool isOwner;
  final int bankTypeStatus;
  final String qrCode;
  final String caiValue;
  final String ewalletToken;
  final int unlinkedType;
  final bool isAuthenticated;
  final int pushNotification;

  // Dùng cho detail store
  final String terminalId;

  Color? bankColor;

  // final String branchCode;
  // final String businessCode;

  BankAccountDTO({
    this.bankId = '',
    this.bankAccount = '',
    this.userBankName = '',
    this.bankShortName = '',
    this.bankCode = '',
    this.bankName = '',
    this.imgId = '',
    this.type = 0,
    this.bankTypeId = '',
    this.nationalId = '',
    this.phoneAuthenticated = '',
    this.userId = '',
    this.isOwner = false,
    this.bankTypeStatus = -1,
    this.qrCode = '',
    this.caiValue = "",
    this.ewalletToken = '',
    this.unlinkedType = -1,
    this.isAuthenticated = false,
    this.terminalId = '',
    this.pushNotification = 0,
  });

  setColor(value) {
    bankColor = value;
  }

  factory BankAccountDTO.fromJson(Map<String, dynamic> json, {Color? color}) {
    return BankAccountDTO(
      bankId: json["id"] ?? '',
      bankAccount: json["bankAccount"] ?? '',
      userBankName: json["userBankName"] ?? '',
      bankShortName: json["bankShortName"] ?? '',
      bankCode: json["bankCode"] ?? '',
      bankName: json["bankName"] ?? '',
      imgId: json["imgId"] ?? '',
      type: json["type"] ?? 0,
      bankTypeId: json["bankTypeId"] ?? '',
      nationalId: json["nationalId"] ?? '',
      phoneAuthenticated: json["phoneAuthenticated"] ?? '',
      userId: json["userId"] ?? ' ',
      isOwner: json["isOwner"] ?? false,
      bankTypeStatus: json["bankTypeStatus"] ?? 0,
      qrCode: json["qrCode"] ?? '',
      caiValue: json["caiValue"] ?? '',
      ewalletToken: json["ewalletToken"] ?? '',
      unlinkedType: json["unlinkedType"] ?? 0,
      isAuthenticated: json["authenticated"] ?? false,
      pushNotification: json["pushNotification"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": bankId,
        "bankAccount": bankAccount,
        "userBankName": userBankName,
        "bankShortName": bankShortName,
        "bankCode": bankCode,
        "bankName": bankName,
        "imgId": imgId,
        "type": type,
        "bankTypeId": bankTypeId,
        "nationalId": nationalId,
        "phoneAuthenticated": phoneAuthenticated,
        "userId": userId,
        "isOwner": isOwner,
        "bankTypeStatus": bankTypeStatus,
        "qrCode": qrCode,
        "caiValue": caiValue,
        "ewalletToken": ewalletToken,
        "unlinkedType": unlinkedType,
        "authenticated": isAuthenticated,
        "pushNotification": pushNotification,
      };
}
