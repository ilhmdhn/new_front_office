class TransferParams{
  String? roomDestination;
  String? roomTypeDestination;
  bool? isRoomCheckin;
  int? capacity;
  String? oldRoom;
  String? invoice;
  String? transferReason;

  TransferParams({
    this.roomDestination,
    this.roomTypeDestination,
    this.isRoomCheckin,
    this.oldRoom,
    this.invoice,
    this.capacity,
    this.transferReason
  });
}