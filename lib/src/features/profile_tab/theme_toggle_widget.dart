import 'package:flutter/material.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';

class ThemeToggleWidget extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggleWidget({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  State<ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<ThemeToggleWidget> {
  double _dragPosition = 0; // 0 (left) → 1 (right)

  @override
  void initState() {
    super.initState();
    _dragPosition = widget.isDarkMode ? 1 : 0;
  }

  @override
  void didUpdateWidget(covariant ThemeToggleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dragPosition = widget.isDarkMode ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final double width = 48;
    final double padding = 4;
    final double knobSize = 22;
    final double maxMove = width - knobSize - (padding * 2);

    final isDarkMode = widget.isDarkMode;

    return GestureDetector(
      onTap: widget.onToggle,

      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragPosition += details.delta.dx / 80; // sensitivity
          _dragPosition = _dragPosition.clamp(0.0, 1.0);
        });
      },

      onHorizontalDragEnd: (_) {
        if (_dragPosition > 0.5 && !isDarkMode) {
          widget.onToggle();
        } else if (_dragPosition <= 0.5 && isDarkMode) {
          widget.onToggle();
        }

        // snap back visually
        setState(() {
          _dragPosition = widget.isDarkMode ? 1 : 0;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkMode
              ? context.colors.topNavBorder
              : context.colors.button,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: padding + (_dragPosition * maxMove),
              top: 4,
              bottom: 4,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? context.colors.background
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: Image.asset(
                        isDarkMode
                            ? 'assets/icons/sakhi icons/moon.png'
                            : 'assets/icons/sakhi icons/sun.png',
                        key: ValueKey(isDarkMode),
                        height: 50,
                      ),
                    )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(
      const AssetImage('assets/icons/sakhi icons/moon.png'),
      context,
    );

    precacheImage(
      const AssetImage('assets/icons/sakhi icons/sun.png'),
      context,
    );
  }
  // Widget _buildSunIcon(Color color) {
  //   return Image.asset(
  //     'assets/icons/sakhi icons/sun.png',
  //     key: const ValueKey('sun'),
  //     width: 22,
  //     height: 22,
  //     fit: BoxFit.contain,
  //   );
  // }
  //
  // Widget _buildMoonIcon() {
  //   return Image.asset(
  //     'assets/icons/sakhi icons/moon.png',
  //     key: const ValueKey('moon'),
  //     width: 22,
  //     height: 22,
  //     fit: BoxFit.contain,
  //   );
  // }
}