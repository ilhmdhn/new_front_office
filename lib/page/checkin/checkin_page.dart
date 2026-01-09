import 'package:flutter/material.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});
  static const nameRoute = '/checkin-page';

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController(text: '1');
  final _paxController = TextEditingController(text: '1');

  bool _isMember = true;
  String? _selectedRoomType;
  String? _selectedRoom;
  bool _noDuration = false;
  String _qrCode = '';
  String _memberName = '';
  String _memberGrade = '';

  final List<String> _roomTypes = ['Regular', 'VIP', 'Lobby', 'Meeting Room'];
  final List<String> _memberGrades = ['Blue', 'Silver', 'Gold', 'Black', 'Platinum'];

  final Map<String, List<String>> _roomsByType = {
    'Regular': ['R101', 'R102', 'R103', 'R104', 'R105'],
    'VIP': ['V201', 'V202', 'V203', 'V204'],
    'Lobby': ['Lobby A', 'Lobby B', 'Lobby C'],
    'Meeting Room': ['M301', 'M302', 'M303', 'M304', 'M305', 'M306'],
  };

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

  void _scanQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('Scan QR Code'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade300, width: 2),
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: Colors.blue.shade300,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Simulate QR scanner here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final randomNames = [
                'John Doe',
                'Jane Smith',
                'Michael Johnson',
                'Sarah Williams',
                'David Brown'
              ];
              final randomGrade = _memberGrades[
                  DateTime.now().millisecondsSinceEpoch % _memberGrades.length];
              final randomName = randomNames[
                  DateTime.now().millisecondsSinceEpoch % randomNames.length];

              setState(() {
                _qrCode = 'MBR${DateTime.now().millisecondsSinceEpoch % 100000}';
                _memberName = randomName;
                _memberGrade = randomGrade;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simulate Scan'),
          ),
        ],
      ),
    );
  }

  void _submitCheckIn() {
    
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

      if (_selectedRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a room'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

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
              _buildSummaryRow('Room Type', _selectedRoomType ?? '-'),
              _buildSummaryRow('Room Number', _selectedRoom ?? '-'),
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
      _selectedRoomType = null;
      _selectedRoom = null;
      _noDuration = false;
    });
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
              if (_selectedRoomType != null) _buildRoomSelector(),
              if (_selectedRoomType != null) const SizedBox(height: 20),
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
    return DropdownButtonFormField<String>(
      initialValue: _selectedRoomType,
      decoration: InputDecoration(
        labelText: 'Room Type',
        hintText: 'Select room type',
        prefixIcon: Icon(Icons.meeting_room, color: Colors.blue.shade700),
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
      items: _roomTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedRoomType = newValue;
          _selectedRoom = null; // Reset room selection when type changes
          if (newValue == 'Lobby') {
            _noDuration = true;
          } else {
            _noDuration = false;
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a room type';
        }
        return null;
      },
    );
  }

  Widget _buildRoomSelector() {
    final rooms = _roomsByType[_selectedRoomType] ?? [];

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: rooms.map((room) {
            final isSelected = _selectedRoom == room;
            return GestureDetector(
              onTap: () => setState(() => _selectedRoom = room),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.meeting_room,
                      size: 18,
                      color: isSelected ? Colors.white : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      room,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationSection() {
    final isLobby = _selectedRoomType == 'Lobby';

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
        if (isLobby) ...[
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
