/// Outcome of running the calculator on a [CourseInput].
///
/// [isTargetAchievable] and [targetMessage] let the UI explain edge
/// cases (target already secured, or mathematically impossible) instead
/// of silently showing a clamped number.
class CalculationResult {
  final double obtainedSoFar;
  final double totalPossible;

  /// Marks needed in the final exam to hit the target grade, clamped to
  /// [0, finalWeightage]. Null when the target grade doesn't exist in
  /// the active grading system.
  final double? requiredFinalMarks;
  final double finalWeightage;
  final bool isTargetAchievable;
  final String? targetMessage;

  final double predictedCourseGpa;
  final double predictedSemesterGpa;
  final double predictedCgpa;

  const CalculationResult({
    required this.obtainedSoFar,
    required this.totalPossible,
    required this.requiredFinalMarks,
    required this.finalWeightage,
    required this.isTargetAchievable,
    required this.targetMessage,
    required this.predictedCourseGpa,
    required this.predictedSemesterGpa,
    required this.predictedCgpa,
  });
}
