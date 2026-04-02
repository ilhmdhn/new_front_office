class Filter{
  static bool isLobby(String typeRoom){
    if(typeRoom.contains('LOBBY') || typeRoom.contains('BAR') || typeRoom.contains('LOUNGE') || typeRoom.contains('RESTO') || typeRoom.contains('SOFA') || typeRoom.contains('OUTDOOR')){
        return true;
    }else {
      return false;
    }
  }
}