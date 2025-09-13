import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://digitalv2.afrilandfirstbank.com';
  static const String apiKey = 'WYhfwpmOOGLdUR0sgjDd1aCNm1HMUikf';
  static const String userAgent = 'Dalvik/2.1.0 (Linux; U; Android 13; Infinix X6528 Build/TP1A.220624.014)';

  static Future<String?> login(String phoneNumber, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user-management/api-public/auth/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
          'User-Agent': userAgent,
          'sara-api-key': apiKey,
        },
        body: {
          'client_id': 'PUBLIC_CLIENT',
          'grant_type': 'password',
          'username': 'c_$phoneNumber',
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      }
      return null;
    } catch (e) {
      print('Erreur de connexion: $e');
      return null;
    }
  }

  static Future<bool> bankToWalletWithdrawal({
    required String token,
    required String bankAccount,
    required String password,
    required String amount,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wallet-management/api/wallets/topUp/afriland'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': userAgent,
          'sara-api-key': apiKey,
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'bankAccount': bankAccount,
          'mfaToken': password,
          'validateWithPin': true,
          'confirm': true,
          'description': 'Top up through bank',
          'walletTopupReq': {
            'countryCode': 'CM',
            'currencyCode': 'XAF',
            'amount': double.parse(amount).toStringAsFixed(0),
          },
          'complementInfoDTO': {
            'paymentMethodCode': 'WALLET_CASH_IN_METHOD',
            'channel': 'SARA_MOBILE',
            'aggregatorCode': '',
            'partnerCode': '',
            'toMemberCode': '',
            'fromMemberCode': '',
            'toMemberShortName': '',
            'fromMemberShortName': '',
            'externalWalletSource': phoneNumber,
            'externalWalletDestination': phoneNumber,
            'externalMobileSource': phoneNumber,
            'externalMobileDestination': phoneNumber,
            'aggregatorTransactionType': '',
            'digitalServiceType': 'CASHIN_SM',
            'messengerName': '',
            'messengerPhone': '',
            'paymentMode': 'BANK_ACCOUNT',
          },
          'commission': {
            'currencyCode': 'XAF',
            'transactionFee': 0.0,
            'feeIds': [148],
            'fixedAmount': 0.0,
            'percentageAmount': 0.0,
            'debitSenderAmount': 0.0,
            'ttaAmount': 0.0,
            'status': false,
            'message': 'FOND suffisants',
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur bank to wallet: $e');
      return false;
    }
  }

  static Future<bool> walletToPhoneWithdrawal({
    required String token,
    required String amount,
    required String beneficiaryPhone,
    required String password,
  }) async {
    try {
      // Déterminer le membre (12001 pour Orange, 12002 pour MTN)
      String toMember = '12002'; // Par défaut MTN
      if (beneficiaryPhone.startsWith('65') || beneficiaryPhone.startsWith('69')) {
        toMember = '12001'; // Orange
      } else if (beneficiaryPhone.startsWith('67') || beneficiaryPhone.startsWith('68')) {
        toMember = '12002'; // MTN
      }

      final response = await http.post(
        Uri.parse('$baseUrl/gimac/customer/v2/doTransferToOtherWallet'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': userAgent,
          'sara-api-key': apiKey,
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'beneficiaryUserType': 'CUSTOMER',
          'beneficiaryWalletName': 'BENEFICIARY',
          'recieverPhoneNumber': beneficiaryPhone,
          'currencyCode': 'XAF',
          'amount': double.parse(amount).toStringAsFixed(0),
          'mfaToken': password,
          'reason': '',
          'toMember': toMember,
          'deviceType': 'Mobile',
          'deviceUid': '',
          'saveAsBeneficiary': false,
          'commission': {
            'currencyCode': 'XAF',
            'transactionFee': 0.0,
            'feeIds': [198],
            'fixedAmount': 0.0,
            'percentageAmount': 0.0,
            'debitSenderAmount': 0.0,
            'ttaAmount': 0.0,
            'status': true,
            'message': 'FOND SUFFISANT',
          },
          'validateWithPin': true,
          'confirm': true,
          'complementInfoDTO': {
            'paymentMethodCode': 'GIMAC_WALLET_TO_OTHER_WALLET_TRANSFER_METHOD',
            'channel': 'SARA_MOBILE',
            'aggregatorCode': '',
            'partnerCode': '',
            'toMemberCode': '',
            'fromMemberCode': '',
            'toMemberShortName': '',
            'fromMemberShortName': '',
            'externalWalletSource': '',
            'externalWalletDestination': '',
            'externalMobileSource': '',
            'externalMobileDestination': '',
            'aggregatorTransactionType': '',
            'digitalServiceType': 'WALLET_TO_OTHER_WALLET_TRANSF',
            'messengerName': '',
            'messengerPhone': '',
            'paymentMode': 'WALLET',
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur wallet to phone: $e');
      return false;
    }
  }
}
