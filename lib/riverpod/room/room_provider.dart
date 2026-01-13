import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/data/request/api_request.dart';

final roomTypeProvider = StateNotifierProvider<RoomTypeNotifier, ListRoomTypeReadyResponse>((ref) {
  return RoomTypeNotifier();
});

class RoomTypeNotifier extends StateNotifier<ListRoomTypeReadyResponse> {
  RoomTypeNotifier() : super(_initialState()) {
    _fetchRoomTypes();
  }

  void refresh() {
    _fetchRoomTypes();
  }

  static ListRoomTypeReadyResponse _initialState(){
    return ListRoomTypeReadyResponse(isLoading: true, data: []);
  }

  Future<void> _fetchRoomTypes() async {
    try {
      debugPrint('🔵 RoomTypeProvider: Fetching room types...');
      final response = await ApiRequest().getListRoomTypeReady();

      debugPrint('🟢 RoomTypeProvider: Got ${response.data.length} room types');
      debugPrint('🟢 RoomTypeProvider: Response state: ${response.state}');
      if (response.state == false) {
        debugPrint('🔴 RoomTypeProvider: Error: ${response.message}');
      }

      state = response;
    } catch (e) {
      debugPrint('🔴 RoomTypeProvider: Exception: $e');
      state = ListRoomTypeReadyResponse(
        isLoading: false,
        state: false,
        message: e.toString(),
        data: [],
      );
    }
  }
}

final roomReadyProvider = StateNotifierProvider<RoomReadyNotifier, RoomListResponse>((ref) {
  return RoomReadyNotifier();
});

class RoomReadyNotifier extends StateNotifier<RoomListResponse> {
  RoomReadyNotifier() : super(_initialState()) {
    // no actions
    // _fetchRooms('READY');
  }

  void getRoom(String roomType) {
    _fetchRooms(roomType);
  }

  static RoomListResponse _initialState(){
    return RoomListResponse(isLoading: false, state: true, data: []);
  }

  Future<void> _fetchRooms(String roomType) async {
    try {
      debugPrint('🔵 RoomReadyProvider: Fetching rooms for type: $roomType');
      state = RoomListResponse(isLoading: true, state: true, data: []);

      final response = await ApiRequest().getRoomList(roomType);

      debugPrint('🟢 RoomReadyProvider: Got ${response.data.length} rooms');
      debugPrint('🟢 RoomReadyProvider: Response state: ${response.state}');
      if (response.state == false) {
        debugPrint('🔴 RoomReadyProvider: Error: ${response.message}');
      }

      state = response;
    } catch (e) {
      debugPrint('🔴 RoomReadyProvider: Exception: $e');
      state = RoomListResponse(
        isLoading: false,
        state: false,
        message: e.toString(),
        data: [],
      );
    }
  }
}

// Provider untuk selected room type
final selectedRoomTypeProvider = StateNotifierProvider<SelectedRoomTypeNotifier, String?>((ref) {
  return SelectedRoomTypeNotifier();
});

class SelectedRoomTypeNotifier extends StateNotifier<String?> {
  SelectedRoomTypeNotifier() : super(null);

  void selectRoomType(String? roomType) {
    state = roomType;
  }

  void clear() {
    state = null;
  }
}

// Provider untuk selected room
final selectedRoomProvider = StateNotifierProvider<SelectedRoomNotifier, String?>((ref) {
  return SelectedRoomNotifier();
});

class SelectedRoomNotifier extends StateNotifier<String?> {
  SelectedRoomNotifier() : super(null);

  void selectRoom(String? room) {
    state = room;
  }

  void clear() {
    state = null;
  }
}