# Offline Mode / Demo Data

File-file di folder ini berisi data dummy untuk **offline mode** atau **testing App Store/Play Store**.

## Tujuan

Aplikasi ini menggunakan server lokal (LAN) yang tidak bisa diakses saat:
1. Testing di App Store/Play Store oleh reviewer
2. Demo aplikasi tanpa koneksi ke server
3. Development/testing tanpa server

## File-file

### 1. `dummy_data.dart`
Berisi semua data JSON dummy yang mensimulasikan response dari server:

- **Login** - User demo dengan credentials
- **Room Management** - Tipe kamar, daftar kamar ready/checkin/paid/checkout
- **Orders/FnB** - Menu makanan & minuman, order list
- **Billing** - Preview bill, invoice
- **Member** - Data member, voucher
- **Approval** - Request approval list
- **EDC** - Daftar payment gateway
- **Promo** - Promo room & FnB
- **Call Service** - History panggilan service

### 2. `dummy_response_helper.dart`
Helper class untuk mengkonversi dummy JSON data ke response objects yang sesuai.

## Cara Implementasi ke Source Code Existing

Untuk mengintegrasikan offline mode ini, modifikasi file request dengan pattern berikut:

### Example: Modifikasi `api_request.dart`

```dart
import 'package:front_office_2/data/dummy/dummy_response_helper.dart';

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
    // TAMBAHKAN INI: Jika error network, return dummy data
    if (_isNetworkError(e)) {
      return DummyResponseHelper.getLoginResponse();
    }

    return LoginResponse(
      state: false,
      message: e.toString()
    );
  }
}

// Helper method untuk detect network error
bool _isNetworkError(dynamic error) {
  if (error is SocketException) return true;
  if (error is HttpException) return true;
  if (error.toString().contains('Failed host lookup')) return true;
  if (error.toString().contains('Connection refused')) return true;
  return false;
}
```

### Pattern untuk semua request:

```dart
try {
  // Normal API call
  final response = await http.get/post(...);
  return SomeResponse.fromJson(response);
} catch (e) {
  // Jika network error, return dummy data
  if (_isNetworkError(e)) {
    return DummyResponseHelper.getSomeResponse();
  }

  // Jika error lain, return error response
  return SomeResponse(state: false, message: e.toString());
}
```

## Daftar Method Helper yang Tersedia

### Auth & User
- `getLoginResponse()` - Login response dengan user demo

### Room Management
- `getListRoomTypeReady()` - Daftar tipe kamar & harga
- `getRoomListByType(String roomType)` - Daftar kamar per tipe
- `getListRoomCheckin()` - Daftar kamar yang sedang checkin
- `getListRoomPaid()` - Daftar kamar yang sudah bayar
- `getListRoomCheckout()` - Daftar kamar checkout
- `getDetailRoomCheckin(String roomCode)` - Detail kamar checkin
- `getRoomCheckinState()` - Status semua kamar

### Orders & FnB
- `getFnbList()` - Daftar menu F&B
- `getOrderList(String roomCode)` - Order list per kamar
- `getSolResponse(String sol)` - Detail slip order
- `getLatestSo(String rcp)` - Latest slip order number

### Billing & Payment
- `getPreviewBill(String roomCode)` - Preview bill sebelum bayar
- `getInvoice(String rcp)` - Invoice setelah bayar
- `getEdcList()` - Daftar payment method

### Member & Promo
- `getCekMember(String memberCode)` - Info member
- `getVoucherMember()` - Info voucher
- `getPromoRoom()` - Promo kamar
- `getPromoFnb()` - Promo F&B

### Approval
- `getApprovalList()` - Daftar approval request
- `getTotalApproval()` - Total pending approval

### Operations
- `getCheckinSuccess()` - Response success checkin
- `getCheckinSlip(String rcp)` - Slip checkin
- `getCallServiceHistory()` - History call service
- `getSignCheck()` - Server connection check

### Generic
- `getBaseResponseSuccess(String message)` - Generic success response
- `getBaseResponseError(String message)` - Generic error response

## Testing

### 1. Test dengan Flight Mode
Aktifkan airplane mode di device dan test semua fitur aplikasi.

### 2. Test dengan Server Mati
Matikan server lokal dan pastikan aplikasi tetap berjalan dengan dummy data.

### 3. Test di Simulator
Test di iOS Simulator atau Android Emulator tanpa koneksi ke server lokal.

## Catatan Penting

1. **DEMO MODE Indicator**: Semua dummy data memiliki indikator "DEMO MODE" atau "(DEMO MODE)" di message
2. **Data Realistis**: Data dummy dibuat realistis agar reviewer bisa test semua fitur
3. **Placeholder Images**: Menggunakan placeholder.com untuk gambar demo
4. **No Real Transaction**: Tidak ada transaksi real yang terjadi di offline mode

## Maintenance

Jika menambah fitur baru:
1. Tambahkan dummy data di `dummy_data.dart`
2. Tambahkan helper method di `dummy_response_helper.dart`
3. Implementasikan offline fallback di request file
4. Update dokumentasi ini

## Keamanan

- Dummy data tidak berisi informasi sensitif real
- Token & credentials adalah dummy/fake
- Tidak ada koneksi ke server real di offline mode
