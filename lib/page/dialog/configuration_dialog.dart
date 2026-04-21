import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/network.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:front_office_2/core/extention/extention.dart';

class ConfigurationDialog {
  void setUrl(BuildContext ctx, WidgetRef ref) async {
    TextEditingController tfIp = TextEditingController();
    TextEditingController tfPort = TextEditingController();
    
    // 1. Ambil state saat ini dari provider
    BaseUrlModel serverUrl = ref.read(serverConfigProvider);
    PosType tempSelectedPosType = ref.read(posTypeProvider); // Variabel draft untuk radio button

    if (isNotNullOrEmpty(serverUrl.ip)) {
      tfIp.text = serverUrl.ip!;
    }

    if (isNotNullOrEmpty(serverUrl.port)) {
      tfPort.text = serverUrl.port!;
    }

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade700,
                            Colors.blue.shade500,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: AutoSizeText(
                              'Konfigurasi Server',
                              minFontSize: 9,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Pastikan konten rata kiri
                        children: [
                          // IP Server Field
                          _buildInputField(
                            icon: Icons.dns_outlined,
                            label: 'IP Server',
                            controller: tfIp,
                            hint: 'Masukkan IP Server',
                            iconColor: Colors.blue.shade700,
                          ),
                          const SizedBox(height: 20),

                          // Port Field
                          _buildInputField(
                            icon: Icons.router_outlined,
                            label: 'Port',
                            controller: tfPort,
                            hint: 'Masukkan Port',
                            iconColor: Colors.green.shade700,
                          ),
                          const SizedBox(height: 24),
                          
                          // Label Tipe POS
                          Text(
                            'Tipe POS:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 2. GridView 2 Kolom untuk Radio Group Enum
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.8, // Sesuaikan jika kotak kerendahan/ketinggian
                            padding: EdgeInsets.zero,
                            children: PosType.values.map((type) {
                              return _buildCustomRadio(
                                type: type,
                                selectedType: tempSelectedPosType,
                                onTap: () {
                                  setState(() {
                                    tempSelectedPosType = type; // Update nilai draft
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 28),

                          // Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close, size: 20, color: Colors.red),
                                  label: const Text('BATAL', style: TextStyle(color: Colors.red)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey.shade700,
                                    side: BorderSide(color: Colors.red.shade300, width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (isNotNullOrEmpty(tfIp.text) &&
                                        isNotNullOrEmpty(tfPort.text)) {
                                      
                                      // 3. Simpan IP & Port
                                      await ref.read(serverConfigProvider.notifier).updateConfig(
                                        ip: tfIp.text,
                                        port: tfPort.text,
                                      );
                                      
                                      // 4. Update Tipe POS secara persisten menggunakan provider Anda
                                      ref.read(posTypeProvider.notifier).updatePosType(tempSelectedPosType);

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      showToastWarning('Isi semua field');
                                    }
                                  },
                                  icon: const Icon(Icons.check, size: 20),
                                  label: const Text('SIMPAN'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  // Method input field tetap sama...
  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Method _buildCustomRadio dimodifikasi untuk menerima parameter Enum dan fungsi OnTap
  Widget _buildCustomRadio({
    required PosType type,
    required PosType selectedType,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 21,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue.shade600 : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AutoSizeText(
                type.label,
                minFontSize: 11,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.blue.shade900 : Colors.black87,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}