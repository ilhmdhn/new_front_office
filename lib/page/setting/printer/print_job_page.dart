import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/riverpod/printer/printer_job_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class PrintJobPage extends ConsumerWidget {
  const PrintJobPage({super.key});
  static const routeName = '/print-jobs';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(printJobProvider);
    final notifier = ref.read(printJobProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Background biru sangat muda yang kalem
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF0F4F8), // Menyesuaikan dengan background
        iconTheme: IconThemeData(color: Colors.blue.shade900),
        title: Text(
          'Print Queue',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.blue.shade900, // Teks judul biru gelap
          ),
        ),
        actions: [
          if (jobs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: ()async{
                  final confirmed = await ConfirmationDialog.confirmation(context, 'Hapus gagal print?');
                  if(confirmed){
                    notifier.clear();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50, // Latar tombol clear biru super muda
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade800, width: 1.7), // Border biru muda
                  ),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.eraser, size: 14, color: Colors.blue.shade800),
                      const SizedBox(width: 4),
                      Text(
                        'Clear',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.blue.shade800, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: jobs.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: jobs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final job = jobs[index];
                final isLan = job.printerType == PrinterConnectionType.lan;

                return InkWell(
                  onTap: () => _showErrorDetailDialog(context, job),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue.shade100, width: 1.5), // Border biru muda
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50, // Latar ikon biru super muda
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isLan ? Icons.lan_rounded : Icons.bluetooth_connected_rounded,
                            color: Colors.blue.shade600, // Ikon utama biru cerah
                          ),
                        ),
                        title: Text(
                          job.target,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue.shade900, // Teks printer biru gelap
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.error_outline, size: 16, color: Colors.red.shade300),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  job.description,
                                  style: TextStyle(
                                    color: Colors.red.shade400, // Merah kalem untuk error
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            ref.read(printJobProvider.notifier).removeJob(job);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.refresh_rounded, color: Colors.blue.shade700, size: 21),
                                Text(
                                  'Retry',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50, // Lingkaran biru muda
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.print_disabled_rounded,
              size: 64,
              color: Colors.blue.shade200,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Antrean Bersih',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800, // Judul empty state biru gelap
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada print yang gagal',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade400, // Subteks biru sedang
            ),
          ),
        ],
      ),
    );
  }
  void _showErrorDetailDialog(BuildContext context, dynamic job) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon Error
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                // Judul
                Text(
                  'Detail Gagal Print',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                // Target Printer
                Text(
                  job.target,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                // Keterangan Lengkap
                Flexible(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        job.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol Tutup
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}