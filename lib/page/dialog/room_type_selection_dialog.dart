import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/riverpod/room/room_provider.dart';

class RoomTypeSelectionDialog extends ConsumerWidget {
  const RoomTypeSelectionDialog({super.key});

  // Icon mapping for room types
  IconData _getRoomTypeIcon(String roomType) {
    final type = roomType.toLowerCase();
    if (type.contains('regular')) return Icons.meeting_room;
    if (type.contains('vip')) return Icons.star;
    if (type.contains('lobby')) return Icons.chair;
    if (type.contains('table')) return Icons.table_restaurant;
    if (type.contains('bar')) return Icons.local_bar;
    if (type.contains('meeting')) return Icons.groups;
    return Icons.room;
  }

  // Color mapping for room types
  Color _getRoomTypeColor(String roomType) {
    final type = roomType.toLowerCase();
    if (type.contains('vip')) return const Color(0xFFFFD700); // Gold
    if (type.contains('regular')) return const Color(0xFF2196F3); // Blue
    if (type.contains('lobby')) return const Color(0xFF4CAF50); // Green
    if (type.contains('table')) return const Color(0xFFFF9800); // Orange
    if (type.contains('bar')) return const Color(0xFF9C27B0); // Purple
    if (type.contains('meeting')) return const Color(0xFF607D8B); // Blue Grey
    return const Color(0xFF757575); // Grey
  }

  // Get badge color based on availability
  Color _getAvailabilityColor(int available) {
    if (available == 0) return Colors.red;
    if (available <= 2) return Colors.orange;
    if (available <= 5) return Colors.amber;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomTypeState = ref.watch(roomTypeProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
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
                    child: const Icon(
                      Icons.meeting_room_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Tipe Kamar',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pilih salah satu tipe kamar',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: roomTypeState.isLoading
                  ? _buildLoadingState()
                  : roomTypeState.state == false
                      ? _buildErrorState(context, ref, roomTypeState.message)
                      : roomTypeState.data.isEmpty
                          ? _buildEmptyState()
                          : _buildGridView(context, roomTypeState.data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Memuat tipe kamar...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(roomTypeProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak Ada Kamar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada tipe kamar tersedia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<RoomTypeReadyData> roomTypes) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: roomTypes.length,
      itemBuilder: (context, index) {
        final roomType = roomTypes[index];
        return _buildRoomTypeCard(context, roomType);
      },
    );
  }

  Widget _buildRoomTypeCard(BuildContext context, RoomTypeReadyData roomType) {
    final roomTypeName = roomType.roomType ?? '';
    final available = roomType.roomAvailable ?? 0;
    final icon = _getRoomTypeIcon(roomTypeName);
    final color = _getRoomTypeColor(roomTypeName);
    final availabilityColor = _getAvailabilityColor(available);
    final isAvailable = available > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAvailable
            ? () {
                Navigator.pop(context, roomTypeName);
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isAvailable
                  ? [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)]
                  : [Colors.grey.shade200, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isAvailable ? color.withValues(alpha: 0.3) : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isAvailable
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Main Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? color.withValues(alpha: 0.2)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: isAvailable ? color : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Room Type Name
                    Text(
                      roomTypeName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? Colors.grey.shade900 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Availability
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? availabilityColor.withValues(alpha: 0.15)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isAvailable
                              ? availabilityColor.withValues(alpha: 0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAvailable ? Icons.check_circle : Icons.cancel,
                            size: 14,
                            color: isAvailable ? availabilityColor : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isAvailable ? '$available tersedia' : 'Penuh',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isAvailable ? availabilityColor : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Disabled overlay
              if (!isAvailable)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show Room Type Selection Dialog
Future<String?> showRoomTypeSelectionDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const RoomTypeSelectionDialog();
    },
  );
}
