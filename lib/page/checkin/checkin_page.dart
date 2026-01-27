import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/member_qr_scanner_dialog.dart';
import 'package:front_office_2/page/dialog/room_type_selection_dialog.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/riverpod/room/room_provider.dart';

class CheckinPage extends ConsumerStatefulWidget {
  static const nameRoute = '/checkin-page';
  const CheckinPage({super.key});

  @override
  ConsumerState<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends ConsumerState<CheckinPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController(text: '1');
  final _paxController = TextEditingController(text: '1');

  bool _isMember = false;
  bool _noDuration = false;
  String _qrCode = '';
  String _memberName = '';
  String _memberGrade = '';
  num? _memberPoint;

  @override
  void initState() {
    super.initState();

    // Reset semua provider ketika masuk ke halaman checkin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset selected room type dan room
      ref.read(selectedRoomTypeProvider.notifier).clear();
      ref.read(selectedRoomProvider.notifier).clear();

      // Reset list rooms
      ref.read(roomReadyProvider.notifier).clear();

      // Refresh room type list untuk fetch data fresh
      ref.read(roomTypeProvider.notifier).refresh();

      
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _paxController.dispose();
    super.dispose();
  }

  int get _duration => int.tryParse(_durationController.text) ?? 1;
  int get _pax => int.tryParse(_paxController.text) ?? 1;

  Map<String, dynamic> _getGradeStyle(String grade) {
    switch (grade) {
      case 'Platinum':
        return {
          'color': const Color(0xFFE5E4E2),
          'gradient': LinearGradient(
            colors: [Color(0xFFE5E4E2), Color(0xFFBFC1C2)],
          ),
          'icon': Icons.diamond,
          'textColor': Color(0xFF1A1A1A),
        };
      case 'Black':
        return {
          'color': const Color(0xFF1A1A1A),
          'gradient': LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF2C2C2C)],
          ),
          'icon': Icons.workspace_premium,
          'textColor': Colors.white,
        };
      case 'Gold':
        return {
          'color': const Color(0xFFFFD700),
          'gradient': LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
          ),
          'icon': Icons.stars,
          'textColor': Color(0xFF1A1A1A),
        };
      case 'Silver':
        return {
          'color': const Color(0xFFC0C0C0),
          'gradient': LinearGradient(
            colors: [Color(0xFFC0C0C0), Color(0xFFA8A8A8)],
          ),
          'icon': Icons.star,
          'textColor': Color(0xFF1A1A1A),
        };
      default: // Blue
        return {
          'color': Colors.blue.shade600,
          'gradient': LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade800],
          ),
          'icon': Icons.card_membership,
          'textColor': Colors.white,
        };
    }
  }

  void _scanQRCode() async {
    final scannedCode = await showMemberQRScannerDialog(context);

    if (scannedCode != null && scannedCode.isNotEmpty && mounted) {
      

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                  ),
                  const SizedBox(height: 16),
                  const Text('Memuat data member...'),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        // Call API to get member data
        final response = await ApiRequest().cekMember(scannedCode);

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        if (response.state == true && response.data != null) {
          // Success - set member data
          setState(() {
            _qrCode = response.data!.memberCode ?? scannedCode;
            _memberName = response.data!.fullName ?? '';
            _memberGrade = response.data!.memberType ?? 'Blue';
            _memberPoint = response.data!.point;
          });

          

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Member ditemukan: $_memberName'),
                    ),
                  ],
                ),
                backgroundColor: Colors.green.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          // Error from API
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(response.message ?? 'Member tidak ditemukan'),
                    ),
                  ],
                ),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } catch (e) {
        // Close loading dialog
        if (mounted) Navigator.pop(context);

        

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Gagal memuat data member: $e'),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  void _submitCheckIn() async{

    final confirmState = await ConfirmationDialog.confirmation(context, 'Checkin?');

    if(!confirmState){
      return;
    }

    final selectedRoomType = ref.read(selectedRoomTypeProvider);
    final selectedRoom = ref.read(selectedRoomProvider);

    if (_formKey.currentState!.validate()) {
      if (_isMember && _qrCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please scan member QR code first'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (selectedRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a room'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Prepare checkin data
      final roomState = ref.read(roomReadyProvider);
      final selectedRoomData = roomState.data.firstWhere(
        (room) => (room.roomCode ?? '') == selectedRoom,
        orElse: () => RoomModel(),
      );

      final userId = ref.read(userProvider).userId;
      final name = _nameController.text;
      final cleaned = name.replaceAll(' ', ''); // hapus spasi
      final firstFive = cleaned.length > 5 ? cleaned.substring(0, 5) : cleaned; // ambil max 5 char
      final generatedCode = '$firstFive-1';
      
      final CheckinBody checkinParams = CheckinBody(
        chusr: userId,
        hour: _noDuration ? 0 : _duration,
        minute: 0,
        pax: _pax,
        checkinRoom: CheckinRoom(
          room: selectedRoom,
        ),
        checkinRoomType: CheckinRoomType(
          roomCapacity: selectedRoomData.roomCapacity ?? 0,
          roomType: selectedRoomType ?? '',
          isRoomCheckin: selectedRoomData.isRoomCheckin ?? false,
        ),
        visitor: Visitor(
          memberCode: _isMember ? _qrCode : generatedCode,
          memberName: _isMember ? _memberName : _nameController.text,
        ),
      );

      
      
      
      
      
      
      
      

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                  ),
                  const SizedBox(height: 16),
                  const Text('Processing check-in...'),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        BaseResponse response;

        if(selectedRoomData.isRoomCheckin == true){
          // Regular room check-in
          
          response = await ApiRequest().doCheckin(checkinParams);
        } else {
          // Lobby check-in
          
          final params = {
            'checkin_room_type': {
              'kamar_untuk_checkin': selectedRoomData.isRoomCheckin ?? false
            },
            'checkin_room':{
              'jenis_kamar': selectedRoomType ?? '',
              'kamar': selectedRoom,
            },
            'visitor':{
              'member': _isMember ? _qrCode : generatedCode,
              'nama_lengkap': _isMember ? _memberName : _nameController.text,
            },
            'chusr': userId,
            'durasi_jam': _noDuration ? 0 : _duration,
            'durasi_menit': 0,
            'pax': _pax,
          };
          response = await ApiRequest().doCheckinLobby(params);
        }

        if (!mounted) return;

        // Close loading
        Navigator.pop(context);

        if(response.state == true){
          

          if(userId == 'TEST'){
            // Show success dialog for TEST user
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    const Text('Check-In Success'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow('Type', _isMember ? 'Member' : 'Non-Member'),
                    if (_isMember)
                      _buildSummaryRow('QR Code', _qrCode)
                    else
                      _buildSummaryRow('Name', _nameController.text),
                    if (_isMember) ...[
                      _buildSummaryRow('Name', _memberName),
                      _buildSummaryRow('Grade', _memberGrade),
                    ],
                    _buildSummaryRow('Room Type', selectedRoomType ?? '-'),
                    _buildSummaryRow('Room Number', selectedRoom),
                    _buildSummaryRow(
                      'Duration',
                      _noDuration ? 'No Duration' : '$_duration ${_duration == 1 ? 'hour' : 'hours'}',
                    ),
                    _buildSummaryRow('Pax', '$_pax'),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            // Navigate to edit checkin page for production
            Navigator.pushNamedAndRemoveUntil(
              context,
              EditCheckinPage.nameRoute,
              arguments: selectedRoom,
              (route) => false
            );
          }
        } else {
          // API returned error
          

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(response.message ?? 'Check-in gagal'),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (e, stackTrace) {
        
        

        if (!mounted) return;

        // Close loading if still open
        Navigator.pop(context);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Terjadi kesalahan: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _durationController.text = '1';
      _paxController.text = '1';
      _qrCode = '';
      _memberName = '';
      _memberGrade = '';
      _memberPoint = null;
      _noDuration = false;
    });
    ref.read(selectedRoomTypeProvider.notifier).clear();
    ref.read(selectedRoomProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade500,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Expanded(
                child: Text(
                  'Check-In',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Welcome! Please fill in the details below',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMemberToggle(),
              const SizedBox(height: 24),
              if (_isMember) _buildQRSection() else _buildNameField(),
              const SizedBox(height: 20),
              _buildRoomTypeDropdown(),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) {
                  final selectedRoomType = ref.watch(selectedRoomTypeProvider);
                  if (selectedRoomType != null) {
                    return Column(
                      children: [
                        _buildRoomSelector(),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              _buildDurationSection(),
              const SizedBox(height: 20),
              _buildPaxField(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _isMember = false;
                _qrCode = '';
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: !_isMember ? Colors.blue.shade700 : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: !_isMember ? Colors.white : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Non-Member',
                      style: TextStyle(
                        color: !_isMember ? Colors.white : Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMember = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isMember ? Colors.blue.shade700 : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_membership,
                      color: _isMember ? Colors.white : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Member',
                      style: TextStyle(
                        color: _isMember ? Colors.white : Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    if (_qrCode.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200, width: 2),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 64,
              color: Colors.blue.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Scan Member QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _scanQRCode,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final gradeStyle = _getGradeStyle(_memberGrade);

    return Container(
      decoration: BoxDecoration(
        gradient: gradeStyle['gradient'] as LinearGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradeStyle['color'] as Color).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    gradeStyle['icon'] as IconData,
                    size: 32,
                    color: gradeStyle['textColor'] as Color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _memberGrade.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: (gradeStyle['textColor'] as Color).withValues(alpha: 0.8),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MEMBER',
                        style: TextStyle(
                          fontSize: 11,
                          color: (gradeStyle['textColor'] as Color).withValues(alpha: 0.6),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.verified,
                  color: gradeStyle['textColor'] as Color,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NAME',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: (gradeStyle['textColor'] as Color).withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _memberName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: gradeStyle['textColor'] as Color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MEMBER ID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: (gradeStyle['textColor'] as Color).withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _qrCode,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: gradeStyle['textColor'] as Color,
                      letterSpacing: 2,
                    ),
                  ),
                  if (_memberPoint != null) ...[
                    const SizedBox(height: 16),
                    Divider(
                      color: (gradeStyle['textColor'] as Color).withValues(alpha: 0.2),
                      height: 1,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'REWARD POINTS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: (gradeStyle['textColor'] as Color).withValues(alpha: 0.7),
                            letterSpacing: 1.5,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.stars,
                              size: 16,
                              color: gradeStyle['textColor'] as Color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_memberPoint',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: gradeStyle['textColor'] as Color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _scanQRCode,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Scan Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: gradeStyle['textColor'] as Color,
                side: BorderSide(
                  color: (gradeStyle['textColor'] as Color).withValues(alpha: 0.5),
                  width: 2,
                ),
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blue.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  Widget _buildRoomTypeDropdown() {
    final selectedRoomType = ref.watch(selectedRoomTypeProvider);

    return GestureDetector(
      onTap: () async {
        final selectedType = await showRoomTypeSelectionDialog(context);

        if (selectedType != null) {
          

          // Update provider
          ref.read(selectedRoomTypeProvider.notifier).selectRoomType(selectedType);
          ref.read(selectedRoomProvider.notifier).clear();

          // Fetch rooms for the selected type
          
          ref.read(roomReadyProvider.notifier).getRoom(selectedType);

          // Reset noDuration saat ganti room type (akan di-set saat pilih room)
          setState(() {
            _noDuration = false;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              Icons.meeting_room_outlined,
              size: 24,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipe Kamar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedRoomType ?? 'Pilih tipe kamar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selectedRoomType != null
                          ? Colors.grey.shade900
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSelector() {
    final roomState = ref.watch(roomReadyProvider);
    final selectedRoom = ref.watch(selectedRoomProvider);
    final selectedRoomType = ref.watch(selectedRoomTypeProvider);

    // Debug: print room data
    if (roomState.data.isNotEmpty) {
      
      for (var room in roomState.data) {
        
      }
    }

    // Tidak perlu filter lagi karena API sudah return room sesuai room type yang dipilih
    // Room type "Lobby", "Table", "Bar" dll → semua punya isRoomCheckin = false
    // Room type "Regular", "VIP", "Meeting Room" dll → semua punya isRoomCheckin = true
    final filteredRooms = roomState.data;

    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.room_preferences, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 8),
            Text(
              'Select Room',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Handle loading state
        if (roomState.isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
              ),
            ),
          )
        // Handle error state
        else if (roomState.state == false)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    roomState.message ?? 'Failed to load rooms',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        // Handle empty state (no rooms after filtering)
        else if (filteredRooms.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No rooms available for this type',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        // Display available rooms in 2 columns
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // ✅ 3 kolom
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.7, // Adjusted untuk 3 kolom
            ),
            itemCount: filteredRooms.length,
            itemBuilder: (context, index) {
              final room = filteredRooms[index];
              final roomDisplay = room.roomCode ?? '';
              final isSelected = selectedRoom == roomDisplay;
              return GestureDetector(
                onTap: () {
                  ref.read(selectedRoomProvider.notifier).selectRoom(roomDisplay);

                  // Set noDuration berdasarkan isRoomCheckin
                  // isRoomCheckin = false → Lobby (no duration)
                  // isRoomCheckin = true → Regular room (butuh duration)
                  setState(() {
                    _noDuration = room.isRoomCheckin == false;
                  });

                  
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade700 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue.shade700 : Colors.blue.shade300,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.shade700.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.meeting_room,
                            size: 16,
                            color: isSelected ? Colors.white : Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: AutoSizeText(
                              roomDisplay,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.blue.shade900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (room.roomCapacity != null) ...[
                        const SizedBox(height: 1),
                        Flexible(
                          child: AutoSizeText(
                            'Capacity: ${room.roomCapacity}',
                            minFontSize: 4,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildDurationSection() {
    final roomState = ref.watch(roomReadyProvider);
    final selectedRoom = ref.watch(selectedRoomProvider);

    // Cek apakah selected room adalah lobby (isRoomCheckin = false)
    final selectedRoomData = roomState.data.firstWhere(
      (room) => (room.roomCode ?? '') == selectedRoom,
      orElse: () => RoomModel(),
    );
    final isLobbyRoom = selectedRoomData.isRoomCheckin == false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _noDuration ? Colors.grey.shade200 : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade100),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Duration (hours)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_noDuration)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    'No Duration Limit',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIncrementButton(
                      icon: Icons.remove,
                      onPressed: () {
                        final current = _duration;
                        if (current > 1) {
                          _durationController.text = (current - 1).toString();
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                        decoration: InputDecoration(
                          suffixText: 'h',
                          suffixStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade600,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          final val = int.tryParse(value);
                          if (val != null && (val < 1 || val > 12)) {
                            _durationController.text = val < 1 ? '1' : '12';
                            _durationController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _durationController.text.length),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildIncrementButton(
                      icon: Icons.add,
                      onPressed: () {
                        final current = _duration;
                        if (current < 12) {
                          _durationController.text = (current + 1).toString();
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (isLobbyRoom && selectedRoom != null) ...[
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Lobby room can be without duration limit',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontSize: 12,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _noDuration,
                    onChanged: (value) {
                      setState(() => _noDuration = value);
                    },
                    activeTrackColor: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaxField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Number of Pax',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIncrementButton(
                icon: Icons.remove,
                onPressed: () {
                  final current = _pax;
                  if (current > 1) {
                    _paxController.text = (current - 1).toString();
                  }
                },
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _paxController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    final val = int.tryParse(value);
                    if (val != null && (val < 1 || val > 50)) {
                      _paxController.text = val < 1 ? '1' : '50';
                      _paxController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _paxController.text.length),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              _buildIncrementButton(
                icon: Icons.add,
                onPressed: () {
                  final current = _pax;
                  if (current < 50) {
                    _paxController.text = (current + 1).toString();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncrementButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.blue.shade700,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitCheckIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 24),
          SizedBox(width: 12),
          Text(
            'Check-In Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
