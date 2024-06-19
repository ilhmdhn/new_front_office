class VoucherModel{
  String code;
  int value;
  String timeStart;
  String timeEnd;
  List<String> snk;

  VoucherModel({
    required this.code,
    required this.value,
    required this.timeStart,
    required this.timeEnd,
    required this.snk
  });
}