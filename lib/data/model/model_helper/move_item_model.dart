class MoveItemModel {
  String slipOrderCode;
  String inventoryCode;
  String itemName;
  int qty;
  String roomSource;
  String rcpSource;

  MoveItemModel({
    required this.slipOrderCode,
    required this.inventoryCode,
    required this.itemName,
    required this.qty,
    required this.roomSource,
    required this.rcpSource
  });
}