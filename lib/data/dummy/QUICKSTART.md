# Quick Start - Offline Mode Implementation

Panduan singkat untuk implementasi offline mode dengan JSON dummy data.

## 🚀 Quick Setup (5 Menit)

### Step 1: Update pubspec.yaml

Buka `pubspec.yaml` dan tambahkan di bagian `flutter:`:

```yaml
flutter:
  assets:
    # Existing assets...

    # Dummy Response JSON Files
    - assets/dummy_responses/auth/
    - assets/dummy_responses/room/
    - assets/dummy_responses/fnb/
    - assets/dummy_responses/billing/
    - assets/dummy_responses/member/
    - assets/dummy_responses/approval/
    - assets/dummy_responses/payment/
    - assets/dummy_responses/promo/
    - assets/dummy_responses/other/
```

### Step 2: Run Flutter Pub Get

```bash
flutter pub get
```

## ✅ Implementasi ke Existing Code

### Pattern Dasar

Untuk setiap API request, tambahkan offline fallback:

```dart
try {
  // Normal API call
  final response = await http.get/post(...);
  return SomeResponse.fromJson(response);
} catch (e) {
  // 🆕 Jika network error, return dummy data
  if (_isNetworkError(e)) {
    return await DummyResponseHelper.getSomeResponse();
  }

  // Jika error lain, return error response
  return SomeResponse(state: false, message: e.toString());
}

// Helper untuk detect network error
bool _isNetworkError(dynamic error) {
  if (error is SocketException) return true;
  if (error is HttpException) return true;
  if (error.toString().contains('Failed host lookup')) return true;
  if (error.toString().contains('Connection refused')) return true;
  if (error.toString().contains('Tidak terhubung ke server')) return true;
  return false;
}
```

## 📖 Contoh Implementasi

### 1. Login Function

**File: `lib/data/request/api_request.dart`**

```dart
import 'dart:io'; // Tambahkan
import 'package:front_office_2/data/dummy/dummy_response_helper.dart'; // Tambahkan

Future<LoginResponse> loginFO(String userId, String password) async {
  try {
    final url = Uri.parse('$serverUrl/user/login-fo-droid');
    final apiResponse = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'user_password': password
      })
    );
    final convertedResult = json.decode(apiResponse.body);
    return LoginResponse.fromJson(convertedResult);
  } catch (e) {
    // 🆕 Offline mode fallback
    if (_isNetworkError(e)) {
      debugPrint('🔴 Offline Mode: Using dummy login data');
      return await DummyResponseHelper.getLoginResponse();
    }
    return LoginResponse(state: false, message: e.toString());
  }
}
```

### 2. Get Room Types

```dart
Future<ListRoomTypeReadyResponse> getListRoomTypeReady() async {
  try {
    final url = Uri.parse('$serverUrl/room/all-room-type-ready-grouping');
    final apiResponse = await http.get(url,
      headers: {'Content-Type': 'application/json', 'authorization': token}
    );
    if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
      loginPage();
    }
    final convertedResult = json.decode(apiResponse.body);
    return ListRoomTypeReadyResponse.fromJson(convertedResult);
  } catch(err) {
    // 🆕 Offline mode fallback
    if (_isNetworkError(err)) {
      debugPrint('🔴 Offline Mode: Using dummy room types');
      return await DummyResponseHelper.getListRoomTypeReady();
    }
    return ListRoomTypeReadyResponse(
      isLoading: false,
      state: false,
      message: err.toString()
    );
  }
}
```

### 3. Get Room List by Type (dengan parameter)

```dart
Future<RoomListResponse> getRoomList(String roomType) async {
  try {
    final url = Uri.parse('$serverUrl/room/all-room-ready-by-type-grouping/$roomType');
    final apiResponse = await http.get(url,
      headers: {'Content-Type': 'application/json', 'authorization': token}
    );
    if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
      loginPage();
    }
    final convertedResult = json.decode(apiResponse.body);
    return RoomListResponse.fromJson(convertedResult);
  } catch(err) {
    // 🆕 Offline mode with parameter
    if (_isNetworkError(err)) {
      debugPrint('🔴 Offline Mode: Using dummy room list for $roomType');
      return await DummyResponseHelper.getRoomListByType(roomType);
    }
    return RoomListResponse(
      isLoading: false,
      state: false,
      message: err.toString()
    );
  }
}
```

### 4. Helper Method _isNetworkError

Tambahkan di class `ApiRequest`:

```dart
class ApiRequest {
  // ... existing code ...

  // Helper untuk detect network error
  bool _isNetworkError(dynamic error) {
    if (error is SocketException) return true;
    if (error is HttpException) return true;

    String errorStr = error.toString().toLowerCase();
    return errorStr.contains('failed host lookup') ||
           errorStr.contains('connection refused') ||
           errorStr.contains('connection timed out') ||
           errorStr.contains('network is unreachable') ||
           errorStr.contains('tidak terhubung ke server');
  }
}
```

## 📋 Mapping Lengkap

| API Request Method | Dummy Helper Method |
|-------------------|---------------------|
| `loginFO()` | `DummyResponseHelper.getLoginResponse()` |
| `getListRoomTypeReady()` | `DummyResponseHelper.getListRoomTypeReady()` |
| `getRoomList(roomType)` | `DummyResponseHelper.getRoomListByType(roomType)` |
| `getListRoomCheckin(search)` | `DummyResponseHelper.getListRoomCheckin()` |
| `getListRoomPaid(search)` | `DummyResponseHelper.getListRoomPaid()` |
| `getListRoomCheckout(search)` | `DummyResponseHelper.getListRoomCheckout()` |
| `getDetailRoomCheckin(roomCode)` | `DummyResponseHelper.getDetailRoomCheckin(roomCode)` |
| `getEdc()` | `DummyResponseHelper.getEdcList()` |
| `getPromoRoom(roomType)` | `DummyResponseHelper.getPromoRoom()` |
| `getPromoFnB(roomType, roomCode)` | `DummyResponseHelper.getPromoFnb()` |
| `fnbPage(page, category, search)` | `DummyResponseHelper.getFnbList()` |
| `getOrder(roomCode)` | `DummyResponseHelper.getOrderList(roomCode)` |
| `previewBill(roomCode)` | `DummyResponseHelper.getPreviewBill(roomCode)` |
| `getBill(roomCode)` | `DummyResponseHelper.getPreviewBill(roomCode)` |
| `getInvoice(rcp)` | `DummyResponseHelper.getInvoice(rcp)` |
| `cekMember(memberCode)` | `DummyResponseHelper.getCekMember(memberCode)` |
| `doCheckin(...)` | `DummyResponseHelper.getCheckinSuccess()` |
| `editCheckin(...)` | `DummyResponseHelper.getBaseResponseSuccess("Edit checkin berhasil (DEMO)")` |
| `extendRoom(...)` | `DummyResponseHelper.getBaseResponseSuccess("Extend room berhasil (DEMO)")` |
| `pay(...)` | `DummyResponseHelper.getBaseResponseSuccess("Pembayaran berhasil (DEMO)")` |
| `checkout(room)` | `DummyResponseHelper.getBaseResponseSuccess("Checkout berhasil (DEMO)")` |
| `clean(room)` | `DummyResponseHelper.getBaseResponseSuccess("Clean room berhasil (DEMO)")` |
| `cekSign()` | `DummyResponseHelper.getSignCheck()` |
| `checkinSlip(rcp)` | `DummyResponseHelper.getCheckinSlip(rcp)` |
| `checkinState()` | `DummyResponseHelper.getRoomCheckinState()` |
| `getSol(sol)` | `DummyResponseHelper.getSolResponse(sol)` |
| `latestSo(rcp)` | `DummyResponseHelper.getLatestSo(rcp)` |
| `getServiceHistory()` | `DummyResponseHelper.getCallServiceHistory()` |
| `approvalList()` | `DummyResponseHelper.getApprovalList()` |
| `totalApprovalRequest()` | `DummyResponseHelper.getTotalApproval()` |
| `memberVoucher(...)` | `DummyResponseHelper.getVoucherMember()` |

## 🧪 Testing

### 1. Test dengan Airplane Mode
1. Build aplikasi ke device
2. Enable airplane mode
3. Test semua fitur - harus work dengan dummy data

### 2. Test dengan Server Off
1. Matikan server lokal
2. Run aplikasi
3. Semua fitur harus fallback ke dummy data

### 3. Test dengan Wrong IP
1. Ganti IP server di settings ke IP random
2. Test aplikasi
3. Harus auto fallback ke dummy data

## 💡 Tips

### 1. Start Small
Mulai dari fitur critical:
- Login ✅
- Room types ✅
- Room list ✅

### 2. Test Incrementally
Test setiap method setelah dimodifikasi

### 3. Add Debug Logs
```dart
if (_isNetworkError(err)) {
  debugPrint('🔴 Offline Mode: Using dummy data for ${api_name}');
  return await DummyResponseHelper.getSomeResponse();
}
```

### 4. UI Indicator (Optional)
Tampilkan "DEMO MODE" di UI:
```dart
if (/* offline mode detected */) {
  Container(
    color: Colors.orange,
    child: Text('DEMO MODE', style: TextStyle(color: Colors.white))
  )
}
```

## 🎯 Expected Result

Setelah implementasi:
- ✅ App bisa login tanpa server (pakai dummy user)
- ✅ Bisa browse room types & rooms
- ✅ Bisa lihat orders, bills, invoices
- ✅ Semua fitur readonly berfungsi
- ✅ Write operations return success message (tapi tidak save ke database)
- ✅ App Store/Play Store reviewers bisa test semua fitur

## 📱 Demo Credentials

```
User ID: DEMO001
Level: ADMIN
(Password: apapun, akan auto login di offline mode)
```

## 🔧 Troubleshooting

### Error: Unable to load asset
**Solusi:** Pastikan sudah run `flutter pub get` dan path di pubspec.yaml benar

### Error: Type mismatch
**Solusi:** Check struktur JSON sesuai dengan model Dart

### Dummy data tidak muncul
**Solusi:**
1. Check `_isNetworkError()` return true
2. Add debug print untuk trace
3. Pastikan `await` dipanggil

### JSON parse error
**Solusi:** Validate JSON syntax dengan `jq` atau online JSON validator

## 📞 Need Help?

Lihat dokumentasi lengkap di:
- `/lib/data/dummy/README.md` - Overall documentation
- `/lib/data/dummy/IMPLEMENTATION_EXAMPLE.md` - Detailed examples
- `/assets/dummy_responses/README.md` - JSON files documentation
