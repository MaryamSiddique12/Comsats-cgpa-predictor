import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_text_styles.dart';
import '../models/calculation_result.dart';
import 'result_card.dart';

/// Renders the four required result cards (Required Final Marks,
/// Predicted Course GPA, Predicted Semester GPA, Predicted Updated
/// CGPA), or a friendly empty state before the first calculation.
class ResultsSection extends StatelessWidget {
  final CalculationResult? result;

  const ResultsSection({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.resultsSectionTitle,
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(height: 20),
        if (result == null)
          const _EmptyState()
        else
          _ResultGrid(isMobile: isMobile, result: result!),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.insights_outlined,
              color: AppColors.textSecondary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              AppStrings.noResultsYet,
              style: AppTextStyles.cardCaption
                  .copyWith(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultGrid extends StatelessWidget {
  final bool isMobile;
  final CalculationResult result;

  const _ResultGrid({required this.isMobile, required this.result});

  @override
  Widget build(BuildContext context) {
    final requiredMarksText = result.requiredFinalMarks == null
        ? '—'
        : '${result.requiredFinalMarks!.toStringAsFixed(1)} / '
            '${result.finalWeightage.toStringAsFixed(0)}';

    final cards = [
      ResultCard(
        label: AppStrings.requiredFinalMarksLabel,
        value: requiredMarksText,
        icon: Icons.flag_outlined,
        accentColor: result.isTargetAchievable
            ? AppColors.cardAccentBlue
            : AppColors.warning,
        caption: result.targetMessage,
      ),
      ResultCard(
        label: AppStrings.predictedCourseGpaLabel,
        value: result.predictedCourseGpa.toStringAsFixed(2),
        icon: Icons.menu_book_outlined,
        accentColor: AppColors.cardAccentTeal,
      ),
      ResultCard(
        label: AppStrings.predictedSemesterGpaLabel,
        value: result.predictedSemesterGpa.toStringAsFixed(2),
        icon: Icons.calendar_month_outlined,
        accentColor: AppColors.cardAccentIndigo,
      ),
      ResultCard(
        label: AppStrings.predictedCgpaLabel,
        value: result.predictedCgpa.toStringAsFixed(2),
        icon: Icons.trending_up_rounded,
        accentColor: AppColors.cardAccentNavy,
      ),
    ];

    return GridView.count(
      crossAxisCount: isMobile ? 1 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: isMobile ? 2.6 : 1.7,
      children: cards,
    );
  }
}
