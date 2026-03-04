class CycleCalculator {
  static int getCycleDay(DateTime lastPeriodDate) {
    final today = DateTime.now();
    return today.difference(lastPeriodDate).inDays + 1;
  }

  static String getPhase({
    required int cycleDay,
    required int cycleLength,
    required int periodLength,
  }) {
    // Menstrual
    if (cycleDay <= periodLength) {
      return 'menstrual';
    }

    // Ovulation approx 14 days before next period
    final ovulationDay = cycleLength - 14;

    // Ovulation window (5 days)
    if (cycleDay >= ovulationDay - 2 && cycleDay <= ovulationDay + 2) {
      return 'ovulation';
    }

    // Follicular
    if (cycleDay < ovulationDay - 2) {
      return 'follicular';
    }

    // Luteal
    return 'luteal';
  }
}
