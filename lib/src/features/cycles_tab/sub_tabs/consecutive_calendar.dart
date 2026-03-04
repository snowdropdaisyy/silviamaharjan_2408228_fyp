import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';

class ConsecutiveCalendar extends StatelessWidget {
  final DateTime month;
  final List<DateTime> selectedDates;
  final List<DateTime> historyDates;
  final Function(DateTime) onDateSelected;

  const ConsecutiveCalendar({
    super.key,
    required this.month,
    required this.selectedDates,
    required this.historyDates,
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    // Sunday start: weekday % 7
    final firstDayOffset = DateTime(month.year, month.month, 1).weekday % 7;
    final Color menstrualColor = const Color(0xFFCF4145);
    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return Column(
      children: [
        // --- Centered Month Heading ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            DateFormat('MMMM yyyy').format(month),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: menstrualColor,
              fontFamily: 'Satoshi',
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 70,
          ),
          itemCount: daysInMonth + firstDayOffset,
          itemBuilder: (context, index) {
            if (index < firstDayOffset) return const SizedBox.shrink();

            final dayNumber = index - firstDayOffset + 1;
            final date = DateTime(month.year, month.month, dayNumber);

            final bool isSelected = selectedDates.any((d) => _isSameDay(d, date));
            final bool isHistory = historyDates.any((d) => _isSameDay(d, date));
            final bool isFuture = date.isAfter(today);
            final bool isToday = _isSameDay(date, today);

            return GestureDetector(
              onTap: isFuture ? null : () => onDateSelected(date),
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                    child: isToday
                        ? Text("Today",
                        style: TextStyle(
                            fontSize: 10,
                            color: appColors.heading,
                            fontWeight: FontWeight.w700))
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isSelected || isHistory) ? menstrualColor : Colors.transparent,
                      border: (isToday && !isSelected && !isHistory)
                          ? Border.all(color: menstrualColor, width: 1)
                          : null,
                    ),
                    child: Text(
                      "$dayNumber",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 16,
                        fontWeight: (isSelected || isHistory) ? FontWeight.w700 : FontWeight.w500,
                        color: isFuture
                            ? Colors.grey.shade300
                            : (isSelected || isHistory ? Colors.white : appColors.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}