class CancelModel {
  int qty;
  String reason;
  String approver;

  CancelModel({
    required this.qty,
    this.reason = '',
    this.approver = ''
  });
}