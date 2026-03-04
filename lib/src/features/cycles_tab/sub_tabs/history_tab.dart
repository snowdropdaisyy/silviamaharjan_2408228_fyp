import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final user = FirebaseAuth.instance.currentUser;

  // Data from user's table
  int cycleLength = 0;
  int periodDuration = 0;

  @override
  void initState() {
    super.initState();
    _loadUserTableData();
  }

  Future<void> _loadUserTableData() async {
    if (user == null) return;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    if (userDoc.exists) {
      setState(() {
        // Specifically collecting from cycle_length and period_duration
        cycleLength = userDoc.data()?['cycle_length'] ?? 0;
        periodDuration = userDoc.data()?['period_duration'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard("Cycle Length", "$cycleLength Days"),
                  const SizedBox(width: 15),
                  _buildStatCard("Period Length", "$periodDuration Days"),
                ],
              ),
            ),

             Padding(
              padding: EdgeInsets.fromLTRB(25, 40, 25, 00),
              child: Text(
                "Your recent cycles",
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: appColors.textPrimary,
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) return const SizedBox();

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                  final String onboardingLastPeriod = userData?['last_period'] ?? "";

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('period_history')
                        .snapshots(), // We will sort manually to ensure the pile is perfect
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      // 1. MERGE EVERYTHING INTO ONE LIST
                      List<Map<String, dynamic>> allLogs = [];

                      // Add history logs
                      for (var doc in snapshot.data!.docs) {
                        allLogs.add(doc.data() as Map<String, dynamic>);
                      }

                      // Add onboarding log if it exists
                      if (onboardingLastPeriod.isNotEmpty) {
                        DateTime obDate = DateTime.parse(onboardingLastPeriod);
                        allLogs.add({
                          'start_date': Timestamp.fromDate(obDate),
                          'end_date': Timestamp.fromDate(obDate.add(Duration(days: (userData?['period_duration'] ?? 4) - 1))),
                          'duration': userData?['period_duration'] ?? 4,
                        });
                      }

                      // 2. SORT BY DATE (DESCENDING) - This makes Feb push Jan down
                      allLogs.sort((a, b) {
                        DateTime dateA = (a['start_date'] as Timestamp).toDate();
                        DateTime dateB = (b['start_date'] as Timestamp).toDate();
                        return dateB.compareTo(dateA); // Newer date first
                      });

                      // 3. REMOVE DUPLICATES (In case onboarding date was also saved to history)
                      final seenDates = <String>{};
                      allLogs = allLogs.where((log) {
                        final dateStr = (log['start_date'] as Timestamp).toDate().toString().substring(0, 10);
                        return seenDates.add(dateStr);
                      }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemCount: allLogs.length,
                        itemBuilder: (context, index) {
                          final data = allLogs[index];
                          DateTime currentStart = (data['start_date'] as Timestamp).toDate();

                          // CALCULATE CYCLE: Current Start - Start of the OLDER log below it
                          int displayCycle;
                          if (index < allLogs.length - 1) {
                            DateTime olderStart = (allLogs[index + 1]['start_date'] as Timestamp).toDate();
                            displayCycle = currentStart.difference(olderStart).inDays.abs(); //
                          } else {
                            displayCycle = cycleLength; // Fallback for the very oldest log
                          }

                          // Year Header Logic
                          String currentYear = DateFormat('yyyy').format(currentStart);
                          bool showYearHeader = index == 0 ||
                              DateFormat('yyyy').format((allLogs[index - 1]['start_date'] as Timestamp).toDate()) != currentYear;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showYearHeader)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    currentYear,
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: appColors.heading, //
                                    ),
                                  ),
                                ),
                              _buildHistoryRow(data, displayCycle),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFFBE5EB),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 15,
                color: appColors.heading,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: appColors.heading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryRow(Map<String, dynamic> data, int calculatedCycle) {
    final DateTime start = (data['start_date'] as Timestamp).toDate();
    final DateTime end = (data['end_date'] as Timestamp).toDate();

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: InkWell(
        // Navigation to History Detail Page
        onTap: () {
          // Replace 'HistoryDetailPage' with your actual class name
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailPage(data: data)));
        },
        child: Row(
          children: [

            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$calculatedCycle",
                    style:  TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: appColors.textPrimary,
                    ),
                  ),
                   Text(
                    "days",
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: appColors.textPrimary,
                      height: 0.7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Date Range
            Expanded(
              child: Text(
                "${DateFormat('d MMM').format(start)} - ${DateFormat('d MMM').format(end)}",
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: appColors.textPrimary,
                ),
              ),
            ),

            Image.asset(
              'assets/icons/cycle tab icons/menstrual.png',
              height: 16,
              width: 16,

            ),
            const SizedBox(width: 25),
            // Chevron indicating navigation
            const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 16
            ),
          ],
        ),
      ),
    );
  }
}