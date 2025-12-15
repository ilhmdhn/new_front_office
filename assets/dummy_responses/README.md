# Dummy Response JSON Files

Folder ini berisi file-file JSON untuk **offline mode / demo mode** aplikasi.

## 📁 Struktur Folder

```
assets/dummy_responses/
├── auth/              # Authentication & User
│   └── login.json
│
├── room/              # Room Management
│   ├── room_types.json
│   ├── room_list_template.json
│   ├── room_checkin.json
│   ├── room_paid.json
│   ├── room_checkout.json
│   ├── room_detail_template.json
│   └── room_state.json
│
├── fnb/               # Food & Beverage
│   ├── menu_list.json
│   └── order_list_template.json
│
├── billing/           # Billing & Payment
│   ├── preview_bill_template.json
│   └── invoice_template.json
│
├── member/            # Member & Voucher
│   ├── member_info_template.json
│   └── voucher.json
│
├── approval/          # Approval Management
│   ├── approval_list.json
│   └── total_approval.json
│
├── payment/           # Payment Methods
│   └── edc_list.json
│
├── promo/             # Promotions
│   ├── promo_room.json
│   └── promo_fnb.json
│
└── other/             # Miscellaneous
    ├── base_success.json
    ├── base_error.json
    ├── checkin_success.json
    ├── checkin_slip_template.json
    ├── call_history.json
    ├── sign_check.json
    ├── sol_template.json
    └── latest_so_template.json
```

## 📝 File Types

### Static Files
File yang langsung digunakan tanpa modifikasi:
- `login.json`
- `room_types.json`
- `room_checkin.json`
- `room_paid.json`
- `room_checkout.json`
- `room_state.json`
- `menu_list.json`
- `approval_list.json`
- `total_approval.json`
- `edc_list.json`
- `promo_room.json`
- `promo_fnb.json`
- `voucher.json`
- `base_success.json`
- `base_error.json`
- `checkin_success.json`
- `call_history.json`
- `sign_check.json`

### Template Files
File yang perlu di-replace placeholder-nya:
- `room_list_template.json` → Replace `{ROOM_TYPE}`
- `room_detail_template.json` → Replace `{ROOM_CODE}`
- `order_list_template.json` → Replace dynamic data
- `preview_bill_template.json` → Replace `{ROOM_CODE}`
- `invoice_template.json` → Replace `{RCP}`, `{TIMESTAMP}`
- `member_info_template.json` → Replace `{MEMBER_CODE}`
- `checkin_slip_template.json` → Replace `{RCP}`
- `sol_template.json` → Replace `{SOL}`
- `latest_so_template.json` → Replace `{TIMESTAMP}`

## 🔧 Placeholders

### Placeholder yang digunakan:
- `{ROOM_TYPE}` - Tipe kamar (VIP, REGULAR, STANDARD)
- `{ROOM_CODE}` - Kode kamar (VIP001, REGULAR002, dll)
- `{RCP}` - Reception code (RCP001, RCP002, dll)
- `{MEMBER_CODE}` - Kode member
- `{SOL}` - Slip order line code
- `{TIMESTAMP}` - Unix timestamp atau datetime
- `{CURRENT_TIME}` - Waktu sekarang

### Cara Replace:
```dart
// Load JSON
String jsonString = await loadAsset('assets/dummy_responses/room/room_list_template.json');

// Replace placeholder
jsonString = jsonString.replaceAll('{ROOM_TYPE}', 'VIP');

// Parse JSON
Map<String, dynamic> json = jsonDecode(jsonString);
```

## 📊 Data Summary

### Auth
- **login.json**: Demo user credentials (DEMO001 / ADMIN)

### Room
- **3 room types**: VIP (150k), REGULAR (100k), STANDARD (75k)
- **3 checkin rooms**: VIP001, REGULAR002, STANDARD003
- **1 paid room**: VIP002
- **1 checkout room**: REGULAR003
- **Room state**: Total count, checkin, ready, dirty per type

### F&B
- **8 menu items**: Makanan (5), Minuman (3)
- **Price range**: 5k - 35k
- **2 sample orders**: Nasi Goreng, Es Teh

### Billing
- **Sample bill**: 515k total (room + fnb)
- **Invoice**: Complete with items breakdown

### Member
- **Member level**: GOLD
- **Member point**: 1000
- **Voucher**: 20% discount (max 50k)

### Approval
- **2 pending approvals**: Diskon request, AC complaint

### Payment
- **7 payment methods**: BCA, Mandiri, BNI, BRI, GoPay, OVO, DANA

### Promo
- **2 room promos**: 10% discount, 50k cashback
- **2 F&B promos**: Buy 1 get 1, 15% discount

### Other
- **Call history**: 3 service calls
- **Sign check**: Server status OK

## 🎨 Image Placeholders

Semua gambar menggunakan **placeholder.com**:
- Room photos: 300x200
- F&B photos: 150x150
- Color coded by category

Format: `https://via.placeholder.com/{size}/{color}/{text_color}?text={label}`

## 🔄 Update Data

### Menambah Data Baru:
1. Buat file JSON baru di folder yang sesuai
2. Gunakan struktur yang sama dengan file existing
3. Update dokumentasi ini

### Memodifikasi Data:
1. Edit file JSON langsung
2. Pastikan struktur tetap sesuai dengan model Dart
3. Test loading di aplikasi

### Validasi JSON:
```bash
# Validate JSON syntax
jq . assets/dummy_responses/auth/login.json

# Pretty print
jq . assets/dummy_responses/room/room_types.json
```

## 📱 Usage in App

### 1. Load Static File:
```dart
String jsonString = await rootBundle.loadString(
  'assets/dummy_responses/auth/login.json'
);
Map<String, dynamic> json = jsonDecode(jsonString);
LoginResponse response = LoginResponse.fromJson(json);
```

### 2. Load Template File:
```dart
String jsonString = await rootBundle.loadString(
  'assets/dummy_responses/room/room_list_template.json'
);
jsonString = jsonString.replaceAll('{ROOM_TYPE}', roomType);
Map<String, dynamic> json = jsonDecode(jsonString);
RoomListResponse response = RoomListResponse.fromJson(json);
```

### 3. Dynamic Timestamp:
```dart
String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
jsonString = jsonString.replaceAll('{TIMESTAMP}', timestamp);
```

## 🧪 Testing

### Test Individual File:
```dart
test('Load login dummy data', () async {
  final data = await DummyJsonLoader.load('auth/login.json');
  expect(data['state'], true);
  expect(data['data']['user_id'], 'DEMO001');
});
```

### Test Template:
```dart
test('Load room list with template', () async {
  final data = await DummyJsonLoader.loadTemplate(
    'room/room_list_template.json',
    {'ROOM_TYPE': 'VIP'}
  );
  expect(data['data'][0]['room_code'], 'VIP001');
});
```

## 📋 Checklist Kualitas Data

- ✅ Semua required fields ada
- ✅ Tipe data sesuai dengan model Dart
- ✅ Data realistis dan konsisten
- ✅ Placeholder images accessible
- ✅ JSON syntax valid
- ✅ Dokumentasi lengkap

## 🚀 Deployment

### Include di pubspec.yaml:
```yaml
flutter:
  assets:
    - assets/dummy_responses/
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

### Build Command:
```bash
flutter build apk --release
flutter build ios --release
```

## 📞 Support

Jika ada pertanyaan atau issue:
1. Check struktur JSON sesuai dengan model
2. Validate JSON syntax
3. Check placeholder replacement
4. Review error logs

## 🔐 Security Notes

- ✅ Tidak ada data sensitif real
- ✅ Semua credentials adalah dummy
- ✅ Token tidak valid untuk production
- ✅ Safe untuk public repository
