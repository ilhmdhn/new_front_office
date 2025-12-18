import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/call_service_history.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class CallServiceHistoryPage extends StatefulWidget {
  static const nameRoute = '/callservice-history';
  const CallServiceHistoryPage({super.key});

  @override
  State<CallServiceHistoryPage> createState() => _CallServiceHistoryPageState();
}

class _CallServiceHistoryPageState extends State<CallServiceHistoryPage> {

  List<CallServiceHistory> historyData = [];
  bool isLoading = true;
  String errorMessage = '';
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    final data = await ApiRequest().getServiceHistory();
    if(data.state == true){
      if(isNotNullOrEmpty(data.data)){
        historyData = data.data;
      }else{
        historyData = [];
      }
    }else{
      showToastError('Gagal memuat data history call service');
      errorMessage = data.message??'';
    }
    setState(() {
      historyData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        elevation: 0,
        title: Text(
          'Call Service History',
          style: CustomTextStyle.titleAppBar(),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: 
      isLoading?
      Center(
        child: CircularProgressIndicator(
          color: CustomColorStyle.bluePrimary(),
        ),
      ):
      Column(
        children: [
          // Header Stats
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  CustomColorStyle.appBarBackground(),
                  CustomColorStyle.appBarBackground().withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Active Calls',
                      historyData.where((item) => item.isNow == 1).length.toString(),
                      Icons.phone_in_talk_rounded,
                      Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Completed',
                      historyData.where((item) => item.isNow == 0).length.toString(),
                      Icons.check_circle_rounded,
                      Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List History
          Expanded(
            child: historyData.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: historyData.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryCard(historyData[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: CustomTextStyle.blackMediumSize(20),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: CustomTextStyle.blackStandard().copyWith(
              fontSize: 11,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(CallServiceHistory data) {
    final bool isActive = data.isNow == 1;
    final String room = data.roomCode;
    final String callTime = data.callTime;
    final String responseTime = data.callResponse??'';
    final String responseBy = data.responsedBy??'';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? Colors.orange.shade300
              : Colors.green.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isActive
                ? Colors.orange
                : Colors.green).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.orange.shade50
                  : Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                // Room Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.orange.shade700
                        : Colors.green.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.room_service_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Room $room',
                        style: CustomTextStyle.whiteStandard().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.orange.shade700
                        : Colors.green.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isActive ? 'CALLING' : 'DONE',
                        style: CustomTextStyle.whiteStandard().copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Timeline Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline Visual
                Column(
                  children: [
                    // Call Time Icon
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: CustomColorStyle.bluePrimary(),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_callback_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    // Connecting Line
                    Container(
                      width: 2,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isActive
                              ? [
                                  CustomColorStyle.bluePrimary(),
                                  Colors.grey.shade300,
                                ]
                              : [
                                  CustomColorStyle.bluePrimary(),
                                  Colors.green.shade600,
                                ],
                        ),
                      ),
                    ),
                    // Response Icon
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.grey.shade300
                            : Colors.green.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive
                            ? Icons.hourglass_empty_rounded
                            : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Time Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Call Time
                      _buildTimeInfo(
                        'Call Time',
                        callTime,
                        CustomColorStyle.bluePrimary(),
                      ),
                      const SizedBox(height: 24),
                      // Response Time
                      if (isActive)
                        _buildTimeInfo(
                          'Waiting...',
                          'Pending',
                          const Color.fromARGB(255, 199, 113, 113),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTimeInfo(
                              'Response Time',
                                responseTime,
                              Colors.green.shade600,
                            ),
                            ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_rounded,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    responseBy,
                                    style: CustomTextStyle.blackStandard().copyWith(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Button (for active calls)
          if (isActive)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ElevatedButton(
                onPressed: () async{
                  final result = ConfirmationDialog.confirmation(context, 'Respond to call service for room $room?');
                  await ApiRequest().callResponse(data.roomCode);
                  getData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_forwarded_rounded, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Respond Now',
                      style: CustomTextStyle.whiteStandard().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomTextStyle.blackStandard().copyWith(
            fontSize: 10,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: CustomTextStyle.blackMedium().copyWith(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        // if (subtitle.isNotEmpty) ...[
        //   const SizedBox(height: 1),
        //   Text(
        //     subtitle,
        //     style: CustomTextStyle.blackStandard().copyWith(
        //       fontSize: 10,
        //       color: Colors.black45,
        //     ),
        //   ),
        // ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Call History',
            style: CustomTextStyle.blackMedium().copyWith(
              fontSize: 18,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Call history will appear here',
            style: CustomTextStyle.blackStandard().copyWith(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: CustomTextStyle.blackStandard().copyWith(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
