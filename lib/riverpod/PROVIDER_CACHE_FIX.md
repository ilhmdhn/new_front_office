# Provider Cache Fix - Dokumentasi

## Masalah
Ketika menggunakan `GlobalProviders.read()` di luar widget (seperti di `ApiRequest`), nilai dari `Provider` biasa akan di-cache oleh `ProviderContainer`. Ini menyebabkan nilai tidak update meskipun data sudah berubah.

## Solusi
Menggunakan `GlobalProviders.invalidate()` untuk force refresh provider setelah data berubah.

## Provider yang Sudah Diperbaiki

### ✅ serverUrlProvider (Provider)
**File:** `lib/riverpod/server_config_provider.dart`

**Masalah:** URL tidak update setelah config berubah

**Solusi:**
```dart
Future<void> updateConfig({required String ip, required String port}) async {
  final newConfig = BaseUrlModel(ip: ip, port: port);
  await PreferencesData.setUrl(newConfig);
  state = newConfig;

  // Invalidate serverUrlProvider agar di-refresh dengan nilai baru
  GlobalProviders.invalidate(serverUrlProvider);
}
```

**Cara Pakai:**
```dart
// Update config
ref.read(serverConfigProvider.notifier).updateConfig(
  ip: '192.168.1.100',
  port: '3000'
);

// serverUrl akan otomatis update di ApiRequest
final api = ApiRequest();
print(api.serverUrl); // Output: http://192.168.1.100:3000
```

### ✅ userTokenProvider (Provider)
**File:** `lib/riverpod/user_provider.dart`

**Masalah:** Token tidak update setelah login/refresh

**Solusi:**
```dart
Future<void> setUser(UserDataModel userData) async {
  await PreferencesData.setUser(userData);
  state = userData;

  // Invalidate userTokenProvider agar di-refresh dengan nilai baru
  GlobalProviders.invalidate(userTokenProvider);
}

void refresh() {
  _loadUser();
  GlobalProviders.invalidate(userTokenProvider);
}
```

**Cara Pakai:**
```dart
// Setelah login
ref.read(userProvider.notifier).setUser(userData);

// token akan otomatis update di ApiRequest
final api = ApiRequest();
print(api.token); // Output: token terbaru
```

## Provider yang TIDAK Perlu Diperbaiki

### ✅ userProvider (StateNotifierProvider)
**Tidak perlu invalidate** karena `StateNotifierProvider` sudah reactive.

```dart
// Di ApiRequest.dart
String get userId => GlobalProviders.read(userProvider).userId;
```

Ketika `userProvider` state berubah, `userId` otomatis update karena dibaca langsung dari state (bukan di-cache).

### ✅ fcmTokenProvider (StateNotifierProvider)
**Tidak perlu invalidate** karena `StateNotifierProvider` sudah reactive dan auto-update saat token refresh.

## Kapan Perlu Invalidate?

### ❌ TIDAK Perlu Invalidate:
- `StateNotifierProvider` - sudah reactive
- `FutureProvider` - sudah auto-refresh
- Provider yang di-access di dalam widget dengan `ref.watch()` - otomatis rebuild

### ✅ PERLU Invalidate:
- `Provider` biasa yang di-access dengan `GlobalProviders.read()` dari luar widget
- Provider yang depend on provider lain dan nilainya di-cache

## Pattern yang Benar

### 1. Di dalam widget (TIDAK perlu invalidate):
```dart
// ✅ Otomatis reactive
final serverUrl = ref.watch(serverUrlProvider);
```

### 2. Di luar widget dengan GlobalProviders:
```dart
// ❌ Akan di-cache jika Provider biasa
String serverUrl = GlobalProviders.read(serverUrlProvider);

// ✅ Solusi: invalidate setelah data berubah
GlobalProviders.invalidate(serverUrlProvider);
```

### 3. StateNotifierProvider di luar widget:
```dart
// ✅ Sudah OK, tidak perlu invalidate
String userId = GlobalProviders.read(userProvider).userId;
```

## Testing

Untuk memastikan provider sudah update:

```dart
// 1. Update config/user data
ref.read(serverConfigProvider.notifier).updateConfig(ip: '192.168.1.1', port: '8080');

// 2. Test langsung di ApiRequest
final api = ApiRequest();
print('Server URL: ${api.serverUrl}'); // Harus print URL baru
print('Token: ${api.token}');
print('User ID: ${api.userId}');

// 3. Test dengan API call
final response = await api.loginFO('user', 'password');
// Harus hit ke server URL yang baru
```

## Global Providers Helper Methods

**File:** `lib/riverpod/provider_container.dart`

```dart
class GlobalProviders {
  // Read provider value
  static T read<T>(ProviderListenable<T> provider) {
    return instance.read(provider);
  }

  // Invalidate provider (force refresh)
  static void invalidate(ProviderOrFamily provider) {
    instance.invalidate(provider);
  }
}
```
