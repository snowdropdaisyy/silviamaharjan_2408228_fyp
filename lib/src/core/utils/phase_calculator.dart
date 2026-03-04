import 'package:intl/intl.dart';

enum CyclePhase {
  menstrual,
  follicular,
  ovulation,
  luteal,
}

class PhaseCalculator {
  /// Calculates the current phase
  static CyclePhase calculatePhase({
    required DateTime lastPeriodDate,
    required int cycleLength,
    required int periodDuration,
  }) {
    final today = DateTime.now();

    // Days since last period started
    final daysSinceLastPeriod =
        today.difference(lastPeriodDate).inDays;

    // Current day in cycle (1-based)
    final currentCycleDay =
        (daysSinceLastPeriod % cycleLength) + 1;

    // --- Phase ranges (scaled to cycle length) ---
    final menstrualEnd = periodDuration;

    final follicularEnd =
    (cycleLength * 0.4).round(); // ~40%

    final ovulationEnd =
        follicularEnd + (cycleLength * 0.15).round(); // ~15%

    // Luteal = rest of days

    if (currentCycleDay <= menstrualEnd) {
      return CyclePhase.menstrual;
    } else if (currentCycleDay <= follicularEnd) {
      return CyclePhase.follicular;
    } else if (currentCycleDay <= ovulationEnd) {
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }

  static String phaseName(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Menstrual Phase';
      case CyclePhase.follicular:
        return 'Follicular Phase';
      case CyclePhase.ovulation:
        return 'Ovulation Phase';
      case CyclePhase.luteal:
        return 'Luteal Phase';
    }
  }
}
