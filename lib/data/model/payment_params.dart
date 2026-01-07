import 'package:front_office_2/riverpod/providers.dart';

class PaymentDetail{
  num nominal;
  String paymentType;
  String approvalCodeDebet;
  String cardCodeDebet;
  String cardDebet;
  String edcDebet;
  String namaUserDebet;
  String approvalCodeCredit;
  String cardCodeCredit;
  String cardCredit;
  String edcCredit;
  String namaUserCredit;
  String accountEmoney;
  String namaUserEmoney;
  String refCodeEmoney;
  String typeEmoney;
  String instansiCompliment;
  String instruksiCompliment;
  String namaUserCompliment;
  String idMemberPiutang;
  String namaUserPiutang;
  String typePiutang;

  PaymentDetail({
    this.nominal = 0,
    this.paymentType = '',
    this.approvalCodeDebet = '',
    this.cardCodeDebet = '',
    this.cardDebet = '',
    this.edcDebet = '',
    this.namaUserDebet = '',
    this.approvalCodeCredit = '',
    this.cardCodeCredit = '',
    this.cardCredit = '',
    this.edcCredit = '',
    this.namaUserCredit = '',
    this.accountEmoney = '',
    this.namaUserEmoney = '',
    this.refCodeEmoney = '',
    this.typeEmoney = '',
    this.instansiCompliment = '',
    this.instruksiCompliment = '',
    this.namaUserCompliment = '',
    this.idMemberPiutang = '',
    this.namaUserPiutang = '',
    this.typePiutang = '',
  });
}

class GeneratePaymentParams{
  static Map<String, dynamic> generatePaymentParams(bool isSendEmail, String room, List<PaymentDetail> paymentList){
    final chusr = GlobalProviders.read(userProvider).userId;
    return <String, dynamic>{
      "chusr": chusr,
      "is_send_email_invoice": isSendEmail,
      'room': room,
      'order_room_payment': _generateListPayment(paymentList)
    };
  }

  static List<Map<String, dynamic>> _generateListPayment(List<PaymentDetail> paymentList){
    List<Map<String, dynamic>> listPayment =[];
      for (var element in paymentList) { 
        if(element.paymentType == 'CASH'){
          listPayment.add({
            'nominal': element.nominal,
            'payment_type': element.paymentType
          });
        }else if(element.paymentType == 'CREDIT CARD'){
          listPayment.add({
            "approval_code_credit": element.approvalCodeCredit,      
            "card_code_credit": element.cardCodeCredit,
            "card_credit": element.cardCredit,
            "edc_credit": element.edcCredit,
            "nama_user_credit": element.namaUserCredit,
            "nominal": element.nominal,
            "payment_type": "CREDIT CARD"
          });
        }else if(element.paymentType == 'DEBET CARD'){
          listPayment.add({
            "approval_code_debet": element.approvalCodeDebet,      
            "card_code_debet": element.cardCodeDebet,
            "card_debet": element.cardDebet,
            "edc_debet": element.edcDebet,
            "nama_user_debet": element.namaUserDebet,
            "nominal": element.nominal,
            "payment_type": "DEBET CARD"
          });
        }else if(element.paymentType == 'E-MONEY'){
          listPayment.add({
              "account_emoney": element.accountEmoney,      
              "nama_user_emoney": element.namaUserEmoney,
              "nominal": element.nominal,
              "payment_type": "E-MONEY",
              "ref_code_emoney": element.refCodeEmoney,
              "type_emoney": element.typeEmoney
          });
        }else if(element.paymentType == 'COMPLIMENTARY'){
          listPayment.add({
            "instansi_compliment": element.instansiCompliment,
            "instruksi_compliment": element.instruksiCompliment,
            "nama_user_compliment": element.namaUserCompliment,
            "nominal": element.nominal,
            "payment_type": "COMPLIMENTARY"
          });
        }else if(element.paymentType == 'PIUTANG'){
          listPayment.add({
            "id_member_piutang": element.idMemberPiutang,
            "nama_user_piutang": element.namaUserPiutang,
            "nominal": element.nominal,
            "payment_type": "PIUTANG",
            "type_piutang": element.typePiutang
          });
        }
      }
    return listPayment;
  }
}