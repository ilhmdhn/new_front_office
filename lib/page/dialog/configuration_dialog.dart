import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/core/extention/extention.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/network.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';

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
        final isDesktopLandscape = context.isDesktop && context.isLandscape;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(isDesktopLandscape ? 40 : 24),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktopLandscape ? 800 : 500,
                  maxHeight: isDesktopLandscape ? context.height * 0.85 : double.infinity,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    _buildHeader(context, isDesktopLandscape),
                    // Content
                    Flexible(
                      child: isDesktopLandscape
                          ? _buildDesktopContent(context, setState, tfIp, tfPort, tempSelectedPosType, ref, (type) {
                              setState(() => tempSelectedPosType = type);
                            })
                          : _buildDefaultContent(context, setState, tfIp, tfPort, tempSelectedPosType, ref, (type) {
                              setState(() => tempSelectedPosType = type);
                            }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktopLandscape) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isDesktopLandscape ? 20 : 24,
        horizontal: isDesktopLandscape ? 24 : 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konfigurasi Server',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktopLandscape ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (isDesktopLandscape)
                  Text(
                    'Atur koneksi server dan tipe POS',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopContent(
    BuildContext context,
    StateSetter setState,
    TextEditingController tfIp,
    TextEditingController tfPort,
    PosType tempSelectedPosType,
    WidgetRef ref,
    Function(PosType) onPosTypeChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left - Server Configuration
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.dns_outlined, color: Colors.blue.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Server Connection',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          icon: Icons.language,
                          label: 'IP Server',
                          controller: tfIp,
                          hint: 'contoh: 192.168.1.100',
                          iconColor: Colors.blue.shade700,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          icon: Icons.router_outlined,
                          label: 'Port',
                          controller: tfPort,
                          hint: 'contoh: 8080',
                          iconColor: Colors.green.shade700,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Pastikan perangkat terhubung ke jaringan yang sama dengan server',
                                  style: TextStyle(fontSize: 11, color: Colors.blue.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Right - POS Type Selection
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.point_of_sale, color: Colors.orange.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Tipe Point of Sale',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pilih tipe POS sesuai kebutuhan outlet',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            children: PosType.values.map((type) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildCustomRadio(
                                  type: type,
                                  selectedType: tempSelectedPosType,
                                  onTap: () => onPosTypeChanged(type),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Buttons
          _buildActionButtons(context, tfIp, tfPort, tempSelectedPosType, ref),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(
    BuildContext context,
    StateSetter setState,
    TextEditingController tfIp,
    TextEditingController tfPort,
    PosType tempSelectedPosType,
    WidgetRef ref,
    Function(PosType) onPosTypeChanged,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            icon: Icons.dns_outlined,
            label: 'IP Server',
            controller: tfIp,
            hint: 'Masukkan IP Server',
            iconColor: Colors.blue.shade700,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            icon: Icons.router_outlined,
            label: 'Port',
            controller: tfPort,
            hint: 'Masukkan Port',
            iconColor: Colors.green.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            'Tipe POS:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: context.isLandscape ? 10 / 2 : 2.8,
            padding: EdgeInsets.zero,
            children: PosType.values.map((type) {
              return _buildCustomRadio(
                type: type,
                selectedType: tempSelectedPosType,
                onTap: () => onPosTypeChanged(type),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          _buildActionButtons(context, tfIp, tfPort, tempSelectedPosType, ref),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    TextEditingController tfIp,
    TextEditingController tfPort,
    PosType tempSelectedPosType,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 18),
            label: const Text('BATAL'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade600,
              side: BorderSide(color: Colors.red.shade300, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              if (isNotNullOrEmpty(tfIp.text) && isNotNullOrEmpty(tfPort.text)) {
                await ref.read(serverConfigProvider.notifier).updateConfig(
                  ip: tfIp.text,
                  port: tfPort.text,
                );
                ref.read(posTypeProvider.notifier).updatePosType(tempSelectedPosType);
                if (context.mounted) Navigator.pop(context);
              } else {
                showToastWarning('Isi semua field');
              }
            },
            icon: const Icon(Icons.check, size: 18),
            label: const Text('SIMPAN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
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