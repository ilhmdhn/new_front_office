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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pilih Tipe Kamar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

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
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Gagal memuat data',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                ref.read(roomTypeProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
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
    final isAvailable = available > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAvailable
            ? () {
                Navigator.pop(context, roomTypeName);
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: isAvailable ? Colors.white : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAvailable ? Colors.grey.shade300 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Icon(
                      icon,
                      size: 36,
                      color: isAvailable ? color : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),

                    // Room Type Name
                    Text(
                      roomTypeName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isAvailable ? Colors.grey.shade900 : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Availability
                    Text(
                      isAvailable ? '$available tersedia' : 'Penuh',
                      style: TextStyle(
                        fontSize: 12,
                        color: isAvailable ? Colors.grey.shade600 : Colors.grey.shade400,
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
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
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
