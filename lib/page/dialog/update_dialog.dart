import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/app_update_response.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final AppUpdateInfo updateInfo;

  const UpdateDialog({super.key, required this.updateInfo});

  // Fungsi untuk membuka Store
  Future<void> _launchStore() async {
    final Uri url = Uri.parse(updateInfo.storeUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // PopScope mencegah user menutup dialog dengan tombol Back jika Force Update
    return PopScope(
      canPop: !updateInfo.isForceUpdate, 
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Jika force update, kita bisa tampilkan toast atau diam saja
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Dialog menyesuaikan konten
            children: [
              // 1. Ilustrasi / Icon Header
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 50,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Judul
              const Text(
                "Update Tersedia!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                "Versi ${updateInfo.version} sudah siap diunduh.",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // 3. Keterangan Update (Release Notes)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Apa yang baru:",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  updateInfo.releaseNotes,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 25),

              // 4. Tombol Aksi
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tombol Update (Selalu ada)
                  ElevatedButton(
                    onPressed: _launchStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Update Sekarang",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Tombol Lewati (Hanya muncul jika Optional)
                  if (!updateInfo.isForceUpdate) ...[
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Nanti Saja",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}