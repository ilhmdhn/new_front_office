# Contoh Implementasi Offline Mode

## Step-by-Step Guide untuk Integrasi

### Step 1: Buat Offline Mode Manager

Buat file `lib/tools/offline_mode.dart`:

```dart
import 'dart:io';

class OfflineMode {
  static bool _forceOfflineMode = false;

  // Enable manual offline mode untuk testing
  static void forceEnable() => _forceOfflineMode = true;
  static void forceDisable() => _forceOfflineMode = false;

  static bool get isForced => _forceOfflineMode;

  // Cek apakah error adalah network error
  static bool isNetworkError(dynamic error) {
    if (_forceOfflineMode) return true;

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

### Step 2: Modifikasi API Request

Edit file `lib/data/request/api_request.dart`:

#### 2.1. Import Dependencies

```dart
import 'dart:io'; // Tambahkan ini
import 'package:front_office_2/data/dummy/dummy_response_helper.dart'; // Tambahkan ini
import 'package:front_office_2/tools/offline_mode.dart'; // Tambahkan ini
```

#### 2.2. Contoh: Login Function

**SEBELUM:**
```dart
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
    return LoginResponse(state: false, message: e.toString());
  }
}
```

**SESUDAH:**
```dart
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
    // 🆕 TAMBAHAN: Jika network error, gunakan dummy data
    if (OfflineMode.isNetworkError(e)) {
      debugPrint('🔴 Offline Mode: Using dummy login data');
      return DummyResponseHelper.getLoginResponse();
    }
    return LoginResponse(state: false, message: e.toString());
  }
}
```

#### 2.3. Contoh: Get List Room Type

**SEBELUM:**
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
    return ListRoomTypeReadyResponse(
      isLoading: false,
      state: false,
      message: err.toString()
    );
  }
}
```

**SESUDAH:**
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
    // 🆕 TAMBAHAN: Jika network error, gunakan dummy data
    if (OfflineMode.isNetworkError(err)) {
      debugPrint('🔴 Offline Mode: Using dummy room types');
      return DummyResponseHelper.getListRoomTypeReady();
    }
    return ListRoomTypeReadyResponse(
      isLoading: false,
      state: false,
      message: err.toString()
    );
  }
}
```

#### 2.4. Contoh: Get Room List by Type (dengan parameter)

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
    // 🆕 TAMBAHAN: Pass parameter ke dummy data
    if (OfflineMode.isNetworkError(err)) {
      debugPrint('🔴 Offline Mode: Using dummy room list for $roomType');
      return DummyResponseHelper.getRoomListByType(roomType);
    }
    return RoomListResponse(
      isLoading: false,
      state: false,
      message: err.toString()
    );
  }
}
```

### Step 3: Modifikasi Cloud Request

Edit file `lib/data/request/cloud_request.dart`:

```dart
import 'dart:io'; // Tambahkan
import 'package:front_office_2/data/dummy/dummy_response_helper.dart'; // Tambahkan
import 'package:front_office_2/tools/offline_mode.dart'; // Tambahkan
```

#### Contoh: Approval List

**SESUDAH:**
```dart
static Future<RequestApprovalResponse> approvalList() async {
  try {
    String outlet = PreferencesData.getOutlet();
    final url = Uri.parse('$baseUrl/approval/list?outlet=$outlet');
    final apiResponse = await http.get(url,
      headers: {'Content-Type': 'application/json', 'authorization': token}
    );
    final convertedResult = json.decode(apiResponse.body);
    return RequestApprovalResponse.fromJson(convertedResult);
  } catch(e) {
    // 🆕 TAMBAHAN: Offline mode support
    if (OfflineMode.isNetworkError(e)) {
      debugPrint('🔴 Offline Mode: Using dummy approval list');
      return DummyResponseHelper.getApprovalList();
    }
    return RequestApprovalResponse(
      state: false,
      message: e.toString()
    );
  }
}
```

### Step 4: Daftar Lengkap Mapping Request → Dummy Helper

| Request Method | Dummy Helper Method |
|----------------|---------------------|
| `loginFO()` | `getLoginResponse()` |
| `getListRoomTypeReady()` | `getListRoomTypeReady()` |
| `getRoomList(roomType)` | `getRoomListByType(roomType)` |
| `getListRoomCheckin(search)` | `getListRoomCheckin()` |
| `getListRoomPaid(search)` | `getListRoomPaid()` |
| `getListRoomCheckout(search)` | `getListRoomCheckout()` |
| `getDetailRoomCheckin(roomCode)` | `getDetailRoomCheckin(roomCode)` |
| `getEdc()` | `getEdcList()` |
| `getPromoRoom(roomType)` | `getPromoRoom()` |
| `getPromoFnB(roomType, roomCode)` | `getPromoFnb()` |
| `fnbPage(page, category, search)` | `getFnbList()` |
| `getOrder(roomCode)` | `getOrderList(roomCode)` |
| `previewBill(roomCode)` | `getPreviewBill(roomCode)` |
| `getBill(roomCode)` | `getPreviewBill(roomCode)` |
| `getInvoice(rcp)` | `getInvoice(rcp)` |
| `cekMember(memberCode)` | `getCekMember(memberCode)` |
| `doCheckin(...)` | `getCheckinSuccess()` |
| `editCheckin(...)` | `getBaseResponseSuccess("Edit checkin berhasil (DEMO)")` |
| `extendRoom(...)` | `getBaseResponseSuccess("Extend room berhasil (DEMO)")` |
| `pay(...)` | `getBaseResponseSuccess("Pembayaran berhasil (DEMO)")` |
| `checkout(room)` | `getBaseResponseSuccess("Checkout berhasil (DEMO)")` |
| `clean(room)` | `getBaseResponseSuccess("Clean room berhasil (DEMO)")` |
| `cekSign()` | `getSignCheck()` |
| `checkinSlip(rcp)` | `getCheckinSlip(rcp)` |
| `checkinState()` | `getRoomCheckinState()` |
| `getSol(sol)` | `getSolResponse(sol)` |
| `latestSo(rcp)` | `getLatestSo(rcp)` |
| `getServiceHistory()` | `getCallServiceHistory()` |
| `approvalList()` | `getApprovalList()` |
| `totalApprovalRequest()` | `getTotalApproval()` |
| `memberVoucher(...)` | `getVoucherMember()` |

### Step 5: Testing Offline Mode

#### 5.1. Manual Testing

Di login page atau main page, tambahkan tombol untuk toggle offline mode:

```dart
// Untuk development/testing
ElevatedButton(
  onPressed: () {
    if (OfflineMode.isForced) {
      OfflineMode.forceDisable();
      showToast('Online Mode');
    } else {
      OfflineMode.forceEnable();
      showToast('Offline Mode (Demo Data)');
    }
  },
  child: Text(OfflineMode.isForced ? 'Switch to Online' : 'Switch to Offline')
)
```

#### 5.2. Testing Scenarios

1. **Airplane Mode**: Enable airplane mode → test semua fitur
2. **Server Off**: Matikan server lokal → test semua fitur
3. **Wrong IP**: Ganti IP di settings ke IP yang salah
4. **Force Offline**: Gunakan toggle button untuk test

### Step 6: UI Indicator (Optional)

Tampilkan indicator di UI bahwa app sedang dalam offline mode:

```dart
// Di AppBar atau header
if (OfflineMode.isForced)
  Container(
    padding: EdgeInsets.all(8),
    color: Colors.orange,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_off, size: 16, color: Colors.white),
        SizedBox(width: 4),
        Text('DEMO MODE', style: TextStyle(color: Colors.white, fontSize: 12))
      ],
    ),
  )
```

## Summary Perubahan

### Files to Create:
1. ✅ `lib/data/dummy/dummy_data.dart` - Dummy JSON data
2. ✅ `lib/data/dummy/dummy_response_helper.dart` - Helper converters
3. 🆕 `lib/tools/offline_mode.dart` - Offline mode manager

### Files to Modify:
1. 🆕 `lib/data/request/api_request.dart` - Tambah offline fallback
2. 🆕 `lib/data/request/cloud_request.dart` - Tambah offline fallback

### Total Lines to Add: ~150-200 lines
- Import statements: ~3 lines per file
- Offline fallback: ~4-5 lines per method
- Total methods: ~30-40 methods

## Tips

1. **Start Small**: Mulai dari fitur critical (login, room list) dulu
2. **Test Incrementally**: Test setiap method setelah dimodifikasi
3. **Keep Dummy Data Updated**: Update dummy data kalau ada perubahan model
4. **Version Control**: Commit setiap step agar mudah rollback
5. **Document**: Tambahkan comment `// Offline mode support` di setiap modifikasi

## Troubleshooting

### Error: Type mismatch
- Pastikan struktur JSON di `dummy_data.dart` sesuai dengan model

### Dummy data tidak muncul
- Check apakah `OfflineMode.isNetworkError()` return true
- Add debug print untuk trace flow

### App crash saat parse dummy data
- Check semua required field ada di dummy JSON
- Test dengan try-catch saat parse
