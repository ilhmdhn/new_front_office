import 'package:flutter/material.dart';

class SoldOutDialog {

void _showSoldOutSelector(BuildContext context, List<FnBModel> items) async {
  final List<FnBModel>? result = await showDialog<List<FnBModel>>(
    context: context,
    builder: (BuildContext context) {
      // Kita buat salinan list agar tidak langsung mengubah data asli sebelum "Save"
      List<FnBModel> tempItems = items.map((item) => 
        FnBModel(
          invCode: item.invCode,
          name: item.name,
          price: item.price,
          location: item.location,
          globalId: item.globalId,
          soldOut: item.soldOut
        )
      ).toList();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set Stok Habis',
                    style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih menu yang sudah tidak tersedia',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey[600], fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400, // Atur tinggi maksimal
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: tempItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F1F1)),
                itemBuilder: (context, index) {
                  final item = tempItems[index];
                  return CheckboxListTile(
                    activeColor: const Color(0xFF1976D2),
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    title: Text(
                      item.name ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    subtitle: Text(item.invCode ?? '', style: const TextStyle(fontSize: 12)),
                    value: item.soldOut,
                    onChanged: (bool? value) {
                      setState(() {
                        tempItems[index].soldOut = value;
                      });
                    },
                  );
                },
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context, tempItems),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );

    if (result != null) {
      // Proses data result di sini (update ke API atau database)
      print("Data berhasil diperbarui!");
    }
  }
}