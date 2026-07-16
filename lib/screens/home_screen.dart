import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../state/calculator_controller.dart';
import '../widgets/gradient_header.dart';
import '../widgets/input_section.dart';
import '../widgets/results_section.dart';

/// The app's single MVP screen: gradient header, then a white content
/// card holding the input form, then a white content card holding the
/// results dashboard.
///
/// Kept as a screen-level widget (rather than folded into main.dart) so
/// future screens — a scenario-comparison screen, a login screen, a
/// study-planner screen — can be added as siblings under `lib/screens/`
/// without restructuring app bootstrap.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = CalculatorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GradientHeader(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 64,
                vertical: isMobile ? 28 : 48,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ContentCard(
                      child: InputSection(
                        gradeOptions: _controller.gradingSystem.gradeLabels,
                        onCalculate: _controller.calculate,
                        onReset: _controller.reset,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) {
                        return _ContentCard(
                          child: ResultsSection(result: _controller.result),
                        );
                      },
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
}

/// The shared white, rounded, soft-shadow card shell used by both the
/// input section and the results section.
class _ContentCard extends StatelessWidget {
  final Widget child;

  const _ContentCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
