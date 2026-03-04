import 'package:flutter/material.dart';
import 'package:silviamaharjan_2408228_fyp/src/features/cycles_tab/sub_tabs/history_tab.dart';
import '../user_management/controllers/database_service.dart';
import 'sub_tabs/calendar_tab.dart';
import '../../core/theme/theme.dart';

class CyclesScreen extends StatefulWidget {
  const CyclesScreen({super.key});

  @override
  State<CyclesScreen> createState() => _CyclesScreenState();
}

class _CyclesScreenState extends State<CyclesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // This listener is the secret sauce for the animation trigger
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        // Reduced height to pull the bar up
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9DEE4),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFF1C0CB),
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                controller: _tabController,
                // 1. Prevents tabs from stretching to fill the screen width
                isScrollable: true,
                // 2. Keeps the compact tabs centered (Required when isScrollable is true)
                tabAlignment: TabAlignment.center,
                dividerColor: Colors.transparent,

                // 3. Adjust this padding to control the exact "nearness"

                labelPadding: const EdgeInsets.symmetric(horizontal: 40),

                indicatorSize: TabBarIndicatorSize.tab,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 1, color: appColors.heading),

                  insets: const EdgeInsets.only(bottom: 0, left: 30, right: 30),
                ),
                // labelPadding: EdgeInsets.zero,
                labelColor: appColors.heading,
                unselectedLabelColor: appColors.heading,
                tabs: [
                  _buildAnimatedTab("Calendar", 0),
                  _buildAnimatedTab("History", 1),
                ],
              ),
              const SizedBox(height: 10), // Minimal bottom padding to keep it tight
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CalendarTab(),
          const HistoryTab(),
        ],
      ),
    );
  }
  Widget _buildLoggedFeelings(List<String> loggedFeelings) {
    if (loggedFeelings.isEmpty) {
      return const Text(
        "No moods logged yet!", //
        style: TextStyle(color: Color(0xFFBDBDBD), fontFamily: 'Satoshi'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: loggedFeelings.map((label) {

        final String iconName = dynamicFeelingIcons[label] ?? 'default';

        return Image.asset(
          'assets/icons/mood icons/$iconName.png',
          height: 18,
          width: 18,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.face, size: 18, color: Colors.grey),
        );
      }).toList(),
    );
  }

  Widget _buildAnimatedTab(String text, int index) {
    bool isActive = _tabController.index == index;
    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 40,
        alignment: Alignment.bottomCenter,
        // The "Jump": only active tab gets bottom padding
        padding: EdgeInsets.only(bottom: isActive ? 6 : 0),
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'Satoshi', fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}