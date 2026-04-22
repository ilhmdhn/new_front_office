import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/model/app_update_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/dialog/update_dialog.dart';
import 'package:front_office_2/page/operational/operational_page.dart';
import 'package:front_office_2/page/profile/profile_page.dart';
import 'package:front_office_2/page/report/report_page.dart';
import 'package:front_office_2/page/status/state_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/riverpod/device_info_provider.dart';
import 'package:front_office_2/tools/permissions.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainPage extends ConsumerStatefulWidget {
  static const nameRoute = '/main';

  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    CloudRequest.insertLogin();
    _notifPermissionState();
    _updateCheck();
  }

  /// REQUEST NOTIFICATION PERMISSION
  Future<void> _notifPermissionState() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      showToastWarningLong('Berikan Izin Notifikasi');
      Permissions().getNotificationPermission();
    } else {
      await ref.read(fcmTokenProvider.notifier).refresh();
      ApiRequest().tokenPost();
      CloudRequest.insertLogin();
    }
  }

  /// CHECK APP UPDATE
  Future<void> _updateCheck() async {
    try {
      final currentVersion = await PackageInfo.fromPlatform();
      final updateData = await CloudRequest.getVersion();

      int updateLevel = 0;
      bool isUpdateAvailable = false;

      debugPrint('update option ${updateData.option} update force ${updateData.force}');

      if (updateData.state) {
        if (int.parse(currentVersion.buildNumber) < updateData.force) {
          isUpdateAvailable = true;
          updateLevel = 2;
        } else if (num.parse(currentVersion.buildNumber) < updateData.option) {
          isUpdateAvailable = true;
          updateLevel = 1;
        }
      }

      final updateDialogData = AppUpdateInfo(
        isForceUpdate: updateLevel > 1,
        version: (updateLevel > 1 ? updateData.force : updateData.option).toString(),
        releaseNotes: updateData.desc,
        storeUrl: updateData.url,
      );

      if (isUpdateAvailable && mounted) {
        showDialog(
          context: context,
          barrierDismissible: updateLevel > 1 ? false : true,
          builder: (context) => UpdateDialog(updateInfo: updateDialogData),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error ${e.toString()} $stackTrace');
      showToastWarning('Gagal cek versi');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopLandscape = context.isDesktop && context.isLandscape;

    final pages = [
      const OperationalPage(),
      const StatePage(),
      const ReportPage(),
      const ProfilePage(),
    ];

    if (isDesktopLandscape) {
      return Scaffold(
        backgroundColor: CustomColorStyle.background(),
        body: Row(
          children: [
            _buildSideNavigation(),
            Expanded(child: pages[currentPageIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      bottomNavigationBar: _buildBottomNavigation(),
      body: pages[currentPageIndex],
    );
  }

  Widget _buildSideNavigation() {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade700.withAlpha(40),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header/Logo
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/icon/reception_blue.png',
                      width: 48,
                      height: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Front Office',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Poin Of Sale',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 16),
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_work_outlined,
                    selectedIcon: Icons.home_work,
                    label: 'Reception',
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.monitor_heart_outlined,
                    selectedIcon: Icons.monitor_heart,
                    label: 'Status',
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.assessment_outlined,
                    selectedIcon: Icons.assessment,
                    label: 'Report',
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.desktop_windows, size: 14, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      'Desktop Mode',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = currentPageIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => currentPageIndex = index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? Colors.blue.shade700 : Colors.white70,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.blue.shade700 : Colors.white,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                index: 0,
                icon: Icons.home_work_outlined,
                selectedIcon: Icons.home_work,
                label: 'Reception',
                useAsset: true,
              ),
              _buildBottomNavItem(
                index: 1,
                icon: Icons.monitor_heart_outlined,
                selectedIcon: Icons.monitor_heart,
                label: 'Status',
              ),
              _buildBottomNavItem(
                index: 2,
                icon: Icons.assessment_outlined,
                selectedIcon: Icons.assessment,
                label: 'Report',
              ),
              _buildBottomNavItem(
                index: 3,
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    bool useAsset = false,
  }) {
    final isSelected = currentPageIndex == index;

    return InkWell(
      onTap: () => setState(() => currentPageIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (useAsset)
              Image.asset(
                isSelected
                    ? 'assets/icon/reception_blue.png'
                    : 'assets/icon/reception_grey.png',
                width: 26,
                height: 26,
              )
            else
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
                size: 26,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}