class TransferParams{
  String? roomDestination;
  String? roomTypeDestination;
  bool? isRoomCheckin;
  String? oldRoom;
  String? transferReason;

  TransferParams({
    this.roomDestination,
    this.roomTypeDestination,
    this.isRoomCheckin,
    this.oldRoom,
    this.transferReason
  });
}