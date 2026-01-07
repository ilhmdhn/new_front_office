# Panduan Akses Riverpod Provider

Ada beberapa cara untuk mengakses Riverpod provider, tergantung dari konteks penggunaannya.

## 📱 1. Di Widget (Metode Terbaik & Reaktif)

### ConsumerWidget (Stateless)
```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Reaktif - UI rebuild otomatis saat data berubah
    final user = ref.watch(userProvider);
    final serverConfig = ref.watch(serverConfigProvider);

    return Text('User: ${user.userId}, Server: ${serverConfig.ip}');
  }
}
```

### ConsumerStatefulWidget
```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Text(user.userId ?? '');
  }
}
```

**✅ Kelebihan:**
- Reaktif: UI auto-rebuild saat data berubah
- Type-safe
- Best practice Riverpod

**❌ Kekurangan:**
- Hanya bisa digunakan di widget

---

## 🔧 2. Di Class/Model/Service (Non-Widget)

### A. GlobalProviders (Sudah diimplementasikan)

```dart
import 'package:front_office_2/riverpod/providers.dart';

class GenerateOrderParams {
  static Future<Map<String, dynamic>> orderParams() async {
    // ✅ Tidak perlu parameter tambahan
    final user = GlobalProviders.read(userProvider);
    final serverConfig = GlobalProviders.read(serverConfigProvider);

    // Untuk FutureProvider
    final deviceModel = await GlobalProviders.read(deviceModelProvider).future;

    return {
      'user_id': user.userId,
      'server': serverConfig.ip,
      'device': deviceModel,
    };
  }
}
```

**✅ Kelebihan:**
- Tidak perlu parameter tambahan
- Bisa diakses dari mana saja
- Clean dan simple

**❌ Kekurangan:**
- Tidak reaktif (tidak auto-rebuild)
- Global state (testing lebih sulit)
- Hanya untuk read data

**⚠️ Kapan Digunakan:**
- Di model class (seperti `order_body.dart`)
- Di service class (API request, dll)
- Di helper/utility functions
- Ketika tidak butuh reactive updates

---

### B. Pass WidgetRef sebagai Parameter (Alternative)

```dart
class GenerateOrderParams {
  static Future<Map<String, dynamic>> orderParams(WidgetRef ref) async {
    // ✅ Bisa reactive jika diperlukan
    final user = ref.read(userProvider);
    final serverConfig = ref.read(serverConfigProvider);

    return {
      'user_id': user.userId,
      'server': serverConfig.ip,
    };
  }
}

// Cara pakai dari widget:
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final params = await GenerateOrderParams.orderParams(ref);
        // ...
      },
      child: Text('Submit'),
    );
  }
}
```

**✅ Kelebihan:**
- Lebih explicit
- Better for testing
- Bisa watch untuk reactive updates

**❌ Kekurangan:**
- Perlu pass parameter `ref` ke banyak tempat
- Tidak bisa digunakan di luar widget tree

---

### C. Dependency Injection dengan GetIt (Existing)

```dart
// Setup di di.dart
void setupLocator() {
  getIt.registerSingleton<UserService>(UserService());
}

class UserService {
  String getUserId() {
    // Bisa akses GlobalProviders di sini
    return GlobalProviders.read(userProvider).userId ?? '';
  }
}

// Cara pakai:
final userId = getIt<UserService>().getUserId();
```

**✅ Kelebihan:**
- Sudah ada di project
- Good for testing
- Decoupled

**❌ Kekurangan:**
- Perlu setup service untuk setiap provider
- Lebih banyak boilerplate

---

## 🎯 Rekomendasi Metode Terbaik

### 1. **Di Widget → Gunakan `ref.watch` atau `ref.read`**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider); // ✅ Reaktif
    return Text(user.userId ?? '');
  }
}
```

### 2. **Di Model/Service → Gunakan `GlobalProviders`**
```dart
class OrderService {
  static Future<void> submitOrder() async {
    final user = GlobalProviders.read(userProvider); // ✅ Simple
    final device = await GlobalProviders.read(deviceModelProvider).future;

    // Process order...
  }
}
```

### 3. **Di Event Handler → Gunakan `ref.read`**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        final userId = ref.read(userProvider).userId; // ✅ One-time read
        print(userId);
      },
      child: Text('Print User'),
    );
  }
}
```

---

## 📊 Perbandingan Metode

| Metode | Di Widget | Di Model/Service | Reaktif | Parameter | Testing |
|--------|-----------|------------------|---------|-----------|---------|
| `ref.watch` | ✅ | ❌ | ✅ | - | ⭐⭐⭐ |
| `ref.read` | ✅ | ❌ | ❌ | - | ⭐⭐⭐ |
| `GlobalProviders` | ✅ | ✅ | ❌ | Tidak perlu | ⭐⭐ |
| Pass `WidgetRef` | ✅ | ✅ | ✅ | Perlu | ⭐⭐⭐ |

---

## 🚀 Contoh Lengkap: Order Process

```dart
// ============================================
// 1. Model Class (menggunakan GlobalProviders)
// ============================================
class GenerateOrderParams {
  static Future<Map<String, dynamic>> orderParams(
    String roomCode,
    List<SendOrderModel> orderData,
  ) async {
    // Akses provider tanpa parameter tambahan
    final user = GlobalProviders.read(userProvider);
    final outlet = GlobalProviders.read(outletProvider);
    final deviceModel = await GlobalProviders.read(deviceModelProvider).future;

    return {
      'user_id': user.userId,
      'outlet': outlet,
      'device': deviceModel,
      'room_code': roomCode,
      'items': orderData.map((e) => e.toJson()).toList(),
    };
  }
}

// ============================================
// 2. Service Class (menggunakan GlobalProviders)
// ============================================
class OrderService {
  static Future<ApiResponse> submitOrder(Map<String, dynamic> params) async {
    final serverUrl = GlobalProviders.read(serverUrlProvider);
    final token = GlobalProviders.read(userTokenProvider);

    // API call...
    final response = await http.post(
      Uri.parse('$serverUrl/order'),
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode(params),
    );

    return ApiResponse.fromJson(jsonDecode(response.body));
  }
}

// ============================================
// 3. Widget (menggunakan ref.watch dan ref.read)
// ============================================
class OrderPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  @override
  Widget build(BuildContext context) {
    // Watch untuk reactive updates
    final user = ref.watch(userProvider);
    final serverConfig = ref.watch(serverConfigProvider);

    return Scaffold(
      body: Column(
        children: [
          // UI akan auto-rebuild jika user atau server config berubah
          Text('User: ${user.userId}'),
          Text('Server: ${serverConfig.ip}:${serverConfig.port}'),

          ElevatedButton(
            onPressed: () async {
              // Read untuk one-time access
              final roomCode = ref.read(selectedRoomProvider);

              // Gunakan GlobalProviders di model
              final params = await GenerateOrderParams.orderParams(
                roomCode,
                orderItems,
              );

              // Gunakan GlobalProviders di service
              final response = await OrderService.submitOrder(params);

              if (response.success) {
                showToastSuccess('Order berhasil');
              }
            },
            child: Text('Submit Order'),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Kesimpulan

**Metode GlobalProviders ADALAH metode yang baik untuk:**
- ✅ Model class (seperti `order_body.dart`)
- ✅ Service class (API requests)
- ✅ Helper/utility functions
- ✅ Mengurangi parameter passing

**TAPI jangan gunakan untuk:**
- ❌ Widget (gunakan `ref.watch` instead)
- ❌ Jika butuh reactive updates
- ❌ Jika butuh testability tinggi

**Rekomendasi:**
Kombinasi keduanya! Gunakan `GlobalProviders` untuk model/service, dan `ref.watch/read` untuk widget.
