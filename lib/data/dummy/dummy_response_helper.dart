import 'package:front_office_2/data/dummy/json_loader.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/call_service_history.dart';
import 'package:front_office_2/data/model/cek_member_response.dart';
import 'package:front_office_2/data/model/checkin_slip_response.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/model/invoice_response.dart';
import 'package:front_office_2/data/model/list_approval_request.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/model/post_so_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/data/model/sol_response.dart';
import 'package:front_office_2/data/model/status_room_checkin.dart';
import 'package:front_office_2/data/model/string_response.dart';
import 'package:front_office_2/data/model/voucher_member_response.dart';

/// Helper class untuk mengkonversi dummy JSON data ke response objects
/// Digunakan saat offline mode atau untuk testing App Store/Play Store
///
/// Data dummy di-load dari assets/dummy_responses/*.json
class DummyResponseHelper {

  // ========== AUTH & USER ==========

  /// Login Response
  static Future<LoginResponse> getLoginResponse() async {
    final json = await DummyJsonLoader.load('auth/login.json');
    return LoginResponse.fromJson(json, '');
  }

  // ========== ROOM MANAGEMENT ==========

  /// List Room Type Ready
  static Future<ListRoomTypeReadyResponse> getListRoomTypeReady() async {
    final json = await DummyJsonLoader.load('room/room_types.json');
    return ListRoomTypeReadyResponse.fromJson(json);
  }

  /// List Room by Type
  static Future<RoomListResponse> getRoomListByType(String roomType) async {
    final json = await DummyJsonLoader.loadRoomList(roomType);
    return RoomListResponse.fromJson(json);
  }

  /// List Room Checkin
  static Future<RoomCheckinResponse> getListRoomCheckin() async {
    final json = await DummyJsonLoader.load('room/room_checkin.json');
    return RoomCheckinResponse.fromJson(json);
  }

  /// List Room Paid
  static Future<RoomCheckinResponse> getListRoomPaid() async {
    final json = await DummyJsonLoader.load('room/room_paid.json');
    return RoomCheckinResponse.fromJson(json);
  }

  /// List Room Checkout
  static Future<RoomCheckinResponse> getListRoomCheckout() async {
    final json = await DummyJsonLoader.load('room/room_checkout.json');
    return RoomCheckinResponse.fromJson(json);
  }

  /// Detail Room Checkin
  static Future<DetailCheckinResponse> getDetailRoomCheckin(String roomCode) async {
    final json = await DummyJsonLoader.loadTemplate(
      'room/room_detail_template.json',
      {'ROOM_CODE': roomCode}
    );
    return DetailCheckinResponse.fromJson(json);
  }

  /// Room Checkin State
  static Future<RoomCheckinState> getRoomCheckinState() async {
    final json = await DummyJsonLoader.load('room/room_state.json');
    return RoomCheckinState.fromJson(json);
  }

  // ========== ORDERS & FNB ==========

  /// FnB List
  static Future<FnBResultModel> getFnbList() async {
    final json = await DummyJsonLoader.load('fnb/menu_list.json');
    return FnBResultModel.fromJson(json);
  }

  /// Order List per Room
  static Future<OrderResponse> getOrderList(String roomCode) async {
    final json = await DummyJsonLoader.load('fnb/order_list_template.json');
    return OrderResponse.fromJson(json);
  }

  /// SOL Response
  static Future<SolResponse> getSolResponse(String sol) async {
    final json = await DummyJsonLoader.loadTemplate(
      'other/sol_template.json',
      {'SOL': sol}
    );
    return SolResponse.fromJson(json);
  }

  /// Latest SO
  static Future<StringResponse> getLatestSo(String rcp) async {
    final json = await DummyJsonLoader.loadWithTimestamp('other/latest_so_template.json');
    return StringResponse.fromJson(json);
  }

  // ========== BILLING & PAYMENT ==========

  /// Preview Bill
  static Future<PreviewBillResponse> getPreviewBill(String roomCode) async {
    final json = await DummyJsonLoader.loadTemplate(
      'billing/preview_bill_template.json',
      {'ROOM_CODE': roomCode}
    );
    return PreviewBillResponse.fromJson(json);
  }

  /// Invoice
  static Future<InvoiceResponse> getInvoice(String rcp) async {
    final timestamp = DummyJsonLoader.getTimestamp();
    final json = await DummyJsonLoader.loadTemplate(
      'billing/invoice_template.json',
      {'RCP': rcp, 'TIMESTAMP': timestamp}
    );
    return InvoiceResponse.fromJson(json);
  }

  /// EDC List
  static Future<EdcResponse> getEdcList() async {
    final json = await DummyJsonLoader.load('payment/edc_list.json');
    return EdcResponse.fromJson(json);
  }

  // ========== MEMBER & VOUCHER ==========

  /// Cek Member
  static Future<CekMemberResponse> getCekMember(String memberCode) async {
    final json = await DummyJsonLoader.loadTemplate(
      'member/member_info_template.json',
      {'MEMBER_CODE': memberCode}
    );
    return CekMemberResponse.fromJson(json);
  }

  /// Voucher Member
  static Future<VoucherMemberResponse> getVoucherMember() async {
    final json = await DummyJsonLoader.load('member/voucher.json');
    return VoucherMemberResponse.fromJson(json);
  }

  // ========== PROMO ==========

  /// Promo Room
  static Future<PromoRoomResponse> getPromoRoom() async {
    final json = await DummyJsonLoader.load('promo/promo_room.json');
    return PromoRoomResponse.fromJson(json);
  }

  /// Promo FnB
  static Future<PromoFnbResponse> getPromoFnb() async {
    final json = await DummyJsonLoader.load('promo/promo_fnb.json');
    return PromoFnbResponse.fromJson(json);
  }

  // ========== APPROVAL ==========

  /// Approval List
  static Future<RequestApprovalResponse> getApprovalList() async {
    final json = await DummyJsonLoader.load('approval/approval_list.json');
    return RequestApprovalResponse.fromJson(json);
  }

  /// Total Approval
  static Future<BaseResponse> getTotalApproval() async {
    final json = await DummyJsonLoader.load('approval/total_approval.json');
    return BaseResponse.fromJson(json);
  }

  // ========== OPERATIONS ==========

  /// Checkin Success
  static Future<BaseResponse> getCheckinSuccess() async {
    final json = await DummyJsonLoader.loadWithTimestamp('other/checkin_success.json');
    return BaseResponse.fromJson(json);
  }

  /// Checkin Slip
  static Future<CheckinSlipResponse> getCheckinSlip(String rcp) async {
    final json = await DummyJsonLoader.loadTemplate(
      'other/checkin_slip_template.json',
      {'RCP': rcp}
    );
    return CheckinSlipResponse.fromJson(json);
  }

  /// Call Service History
  static Future<CallServiceHistoryResponse> getCallServiceHistory() async {
    final json = await DummyJsonLoader.load('other/call_history.json');
    return CallServiceHistoryResponse.fromJson(json);
  }

  /// Sign Check (Server Connection Check)
  static Future<BaseResponse> getSignCheck() async {
    final json = await DummyJsonLoader.load('other/sign_check.json');
    return BaseResponse.fromJson(json);
  }

  static Future<PostSoResponse> postSoResponse() async {
    final json = await DummyJsonLoader.load('other/pos_so.json');
    return PostSoResponse.fromJson(json);
  }

  // ========== GENERIC RESPONSES ==========

  /// Base Response Success
  static Future<BaseResponse> getBaseResponseSuccess(String message) async {
    final json = await DummyJsonLoader.load('other/base_success.json');
    json['message'] = message;
    return BaseResponse.fromJson(json);
  }

  /// Base Response Error
  static Future<BaseResponse> getBaseResponseError(String message) async {
    final json = await DummyJsonLoader.load('other/base_error.json');
    json['message'] = message;
    return BaseResponse.fromJson(json);
  }
}
