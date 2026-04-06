class VerificationResultModel {
  bool state;
  String message;
  String approver;

  VerificationResultModel({
    required this.state,
    required this.message,
    required this.approver,
  });
}