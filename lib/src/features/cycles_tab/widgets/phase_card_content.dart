import '../../../core/utils/phase_calculator.dart';

class PhaseCardContent {
  final String title;
  final String description;

  PhaseCardContent({required this.title, required this.description});

  static PhaseCardContent getContent(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return PhaseCardContent(
          title: "Menstrual Phase!",
          description: "It’s okay to slow down right now. Rest more, keep things easy, and if you’re craving comfort food, enjoy it. Just make sure you’re actually nourishing yourself too.",
        );
      case CyclePhase.follicular:
        return PhaseCardContent(
          title: "Follicular Phase!",
          description: "Your energy is coming back and your mind feels clearer. This is a great time to try gentle movement, plan things you’ve been putting off, and do what makes you feel good you’ve got this.",
        );
      case CyclePhase.ovulation:
        return PhaseCardContent(
          title: "Ovulation Phase!",
          description: "You’re probably feeling more open and confident, so lean into it. Make plans, speak up, try something new, and enjoy being around people. This is a good moment for you.",
        );
      case CyclePhase.luteal:
        return PhaseCardContent(
          title: "Luteal Phase!",
          description: "Things might feel a little heavier and more emotional. That’s normal. Listen to your body, honor your cravings in a balanced way, wrap things up calmly, and be gentle with yourself.",
        );
    }
  }
}