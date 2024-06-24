class TransferParams{
  String? roomDestination;
  String? roomTypeDestination;
  bool? isRoomCheckin;
  int? capacity;
  String? oldRoom;
  String? transferReason;

  TransferParams({
    this.roomDestination,
    this.roomTypeDestination,
    this.isRoomCheckin,
    this.oldRoom,
    this.capacity,
    this.transferReason
  });
}