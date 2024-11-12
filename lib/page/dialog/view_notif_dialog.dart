import 'package:flutter/material.dart';

class NotificationDialog {
  OverlayEntry? _overlayEntry;

  void showNotificationOverlay(BuildContext context) {
    // Jika overlay sudah ada, hapus untuk menghindari duplikasi
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      "Notifikasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                      },
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(),
                _buildNotificationItem("Panggilan Service", "R05 - ROOM 15", "12:10"),
                _buildNotificationItem("Permintaan DO", "R06 - Ayam Goreng Mentega", "12:11"),
              ],
            ),
          ),
        ),
      ),
    );

    // Masukkan overlay ke dalam layar
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildNotificationItem(String title, String room, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  room,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menutup overlay secara manual
  void closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
