# Riverpod Providers Documentation

Dokumentasi lengkap untuk state management menggunakan Riverpod di Front Office 2 App.

## 📦 Import

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/riverpod/providers.dart';
```

## 🎯 Cara Penggunaan

### 1. Widget harus menggunakan ConsumerWidget atau ConsumerStatefulWidget

**Stateless Widget:**
```dart
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gunakan ref untuk mengakses provider
    final serverConfig = ref.watch(serverConfigProvider);

    return Text('Server: ${serverConfig.ip}:${serverConfig.port}');
  }
}
```

**Stateful Widget:**
```dart
class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Text('User: ${user.userId}');
  }
}
```

---

## 📡 Server Configuration Providers

### `serverConfigProvider`
Provider untuk konfigurasi server (IP dan Port)

**Membaca data:**
```dart
final config = ref.watch(serverConfigProvider);
print('IP: ${config.ip}');
print('Port: ${config.port}');
```

**Update data:**
```dart
await ref.read(serverConfigProvider.notifier).updateConfig(
  ip: '192.168.1.100',
  port: '3000',
);
```

**Refresh dari SharedPreferences:**
```dart
ref.read(serverConfigProvider.notifier).refresh();
```

### `serverUrlProvider`
Provider untuk mendapatkan full URL string

```dart
final url = ref.watch(serverUrlProvider);
// Output: http://192.168.1.100:3000
```

### `outletProvider`
Provider untuk outlet code

**Membaca:**
```dart
final outlet = ref.watch(outletProvider);
```

**Update:**
```dart
ref.read(outletProvider.notifier).updateOutlet('HP001');
```

---

## 👤 User & Authentication Providers

### `userProvider`
Provider untuk data user

**Membaca:**
```dart
final user = ref.watch(userProvider);
print('User ID: ${user.userId}');
print('Level: ${user.level}');
print('Token: ${user.token}');
```

**Set user (saat login):**
```dart
await ref.read(userProvider.notifier).setUser(
  UserDataModel(
    userId: 'USER001',
    level: 'ADMIN',
    token: 'abc123',
  ),
  'password123',
);
```

**Get token:**
```dart
final token = ref.read(userProvider.notifier).getToken();
```

### `loginStateProvider`
Provider untuk status login

**Membaca:**
```dart
final isLoggedIn = ref.watch(loginStateProvider);
```

**Set status:**
```dart
ref.read(loginStateProvider.notifier).setLoginState(true);
```

### `biometricLoginProvider`
Provider untuk status biometric login

**Membaca:**
```dart
final isBiometricEnabled = ref.watch(biometricLoginProvider);
```

**Toggle:**
```dart
ref.read(biometricLoginProvider.notifier).setBiometricLogin(true);
```

### `userTokenProvider`
Provider khusus untuk mendapatkan token saja

```dart
final token = ref.watch(userTokenProvider);
```

---

## 🖨️ Printer Provider

### `printerProvider`
Provider untuk printer settings

**Membaca:**
```dart
final printer = ref.watch(printerProvider);
print('Name: ${printer.name}');
print('Connection: ${printer.connection}');
print('Type: ${printer.type}');
print('Address: ${printer.address}');
```

**Set printer:**
```dart
ref.read(printerProvider.notifier).setPrinter(
  PrinterModel(
    name: 'Thermal Printer',
    connection: 'bluetooth',
    type: 'thermal',
    address: '00:11:22:33:44:55',
  ),
);
```

---

## ⚙️ App Settings Providers

### `showReturProvider`
Provider untuk show retur state

**Membaca:**
```dart
final showRetur = ref.watch(showReturProvider);
```

**Update:**
```dart
ref.read(showReturProvider.notifier).setShowRetur(true);
```

### `showTotalItemPromoProvider`
Provider untuk show total item promo

**Membaca:**
```dart
final showTotalPromo = ref.watch(showTotalItemPromoProvider);
```

**Update:**
```dart
ref.read(showTotalItemPromoProvider.notifier).setShowTotalItemPromo(true);
```

### `showPromoBelowItemProvider`
Provider untuk show promo below item

**Membaca:**
```dart
final showPromoBelow = ref.watch(showPromoBelowItemProvider);
```

**Update:**
```dart
ref.read(showPromoBelowItemProvider.notifier).setShowPromoBelowItem(true);
```

---

## 📱 Device Info Providers

### `fcmTokenProvider`
Provider untuk FCM token

**Membaca:**
```dart
final fcmToken = ref.watch(fcmTokenProvider);
```

**Set token:**
```dart
await ref.read(fcmTokenProvider.notifier).setFcmToken('new_fcm_token');
```

### `imeiProvider`
FutureProvider untuk mendapatkan IMEI

```dart
final imeiAsync = ref.watch(imeiProvider);

imeiAsync.when(
  data: (imei) => Text('IMEI: $imei'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### `deviceModelProvider`
FutureProvider untuk mendapatkan model device

```dart
final deviceModelAsync = ref.watch(deviceModelProvider);

deviceModelAsync.when(
  data: (model) => Text('Device: $model'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

---

## 🔄 ref.watch vs ref.read vs ref.listen

### `ref.watch`
Digunakan di dalam build method, akan rebuild widget ketika data berubah

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(userProvider); // ✅ Rebuild saat user berubah
  return Text(user.userId ?? '');
}
```

### `ref.read`
Digunakan di event handler (onPressed, onChanged, dll), tidak rebuild widget

```dart
ElevatedButton(
  onPressed: () {
    final userId = ref.read(userProvider).userId; // ✅ Baca sekali saja
    print(userId);
  },
  child: Text('Print User ID'),
)
```

### `ref.listen`
Digunakan untuk mendengarkan perubahan dan melakukan side effect

```dart
@override
void initState() {
  super.initState();

  ref.listen(loginStateProvider, (previous, next) {
    if (next == false) {
      // Logout, redirect ke login page
      Navigator.pushReplacementNamed(context, LoginPage.nameRoute);
    }
  });
}
```

---

## 💡 Contoh Penggunaan di Dialog

Untuk dialog yang bukan ConsumerWidget, gunakan parameter `WidgetRef`:

```dart
class MyDialog {
  void show(BuildContext context, WidgetRef ref) {
    final config = ref.read(serverConfigProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Server Config'),
        content: Text('${config.ip}:${config.port}'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(serverConfigProvider.notifier).updateConfig(
                ip: '192.168.1.1',
                port: '8080',
              );
              Navigator.pop(ctx);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}

// Cara pakai:
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        MyDialog().show(context, ref); // ✅ Pass ref ke dialog
      },
      child: Text('Show Dialog'),
    );
  }
}
```

---

## 🚀 Best Practices

1. **Gunakan `ref.watch` di build method** untuk reactive updates
2. **Gunakan `ref.read` di event handlers** untuk one-time reads
3. **Gunakan `ref.listen` untuk side effects** seperti navigation, snackbar, dll
4. **Panggil `.refresh()` jika perlu** reload dari SharedPreferences
5. **Pass `ref` sebagai parameter** jika dialog bukan ConsumerWidget

---

## 📝 Migration dari PreferencesData

**Sebelum (Shared Preferences):**
```dart
final url = PreferencesData.getUrl();
await PreferencesData.setUrl(BaseUrlModel(ip: '...', port: '...'));
```

**Sesudah (Riverpod):**
```dart
final url = ref.watch(serverUrlProvider);
await ref.read(serverConfigProvider.notifier).updateConfig(ip: '...', port: '...');
```

---

## 🎨 Keuntungan Menggunakan Riverpod

✅ **Reactive**: UI otomatis update saat data berubah
✅ **Type-safe**: Compile-time safety
✅ **Testable**: Mudah di-test dan di-mock
✅ **Global state**: Bisa diakses dari mana saja
✅ **No BuildContext**: Tidak perlu pass BuildContext
✅ **Provider override**: Bisa di-override untuk testing

---

## 📞 Support

Jika ada pertanyaan, hubungi team developer.
