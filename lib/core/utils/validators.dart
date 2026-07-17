import '../constants/app_strings.dart';

/// Pure validation helpers used by the input form.
///
/// Kept as static functions (no widget/state dependency) so they can be
/// unit-tested in isolation and reused if the form is ever rebuilt with
/// a different widget (e.g. a stepper wizard for future onboarding).
class Validators {
  Validators._();

  /// Validates a numeric field that must fall within [min, max]
  /// (inclusive). Returns an error message, or null if valid.
  static String? numberInRange(
    String? value, {
    required double min,
    required double max,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return AppStrings.errorInvalidNumber;
    }
    if (parsed < min || parsed > max) {
      return AppStrings.errorOutOfRange;
    }
    return null;
  }

  /// Midterm marks: 0–25.
  static String? midterm(String? value) =>
      numberInRange(value, min: 0, max: 25);

  /// "Marks per Quiz" / "Marks per Assignment" fields: must be a
  /// positive number (the raw scale each quiz/assignment is marked
  /// out of). Zero or negative would make the weighted-marks
  /// conversion meaningless (division by zero / by a negative).
  static String? positiveScale(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return AppStrings.errorInvalidNumber;
    if (parsed <= 0) return 'Must be greater than 0';
    return null;
  }

  /// A single quiz field: must fall between 0 and [marksPerQuiz] (the
  /// configurable raw scale each quiz is marked out of). There is no
  /// total cap here — the raw total across all 4 quizzes is allowed to
  /// go up to `marksPerQuiz * 4` (it is then converted into the fixed
  /// 10% quiz weightage via weightedQuizMarks).
  static String? quizField(String? value, {required double marksPerQuiz}) {
    final result = numberInRange(value, min: 0, max: marksPerQuiz);
    if (result == AppStrings.errorOutOfRange) {
      return 'Cannot exceed ${marksPerQuiz.toStringAsFixed(
        marksPerQuiz.truncateToDouble() == marksPerQuiz ? 0 : 1,
      )} marks per quiz';
    }
    return result;
  }

  /// A single assignment field: must fall between 0 and
  /// [marksPerAssignment] (the configurable raw scale each assignment
  /// is marked out of). There is no total cap here — the raw total
  /// across all 4 assignments is allowed to go up to
  /// `marksPerAssignment * 4` (it is then converted into the fixed 15%
  /// assignment weightage via weightedAssignmentMarks).
  static String? assignmentField(
    String? value, {
    required double marksPerAssignment,
  }) {
    final result = numberInRange(value, min: 0, max: marksPerAssignment);
    if (result == AppStrings.errorOutOfRange) {
      return 'Cannot exceed ${marksPerAssignment.toStringAsFixed(
        marksPerAssignment.truncateToDouble() == marksPerAssignment ? 0 : 1,
      )} marks per assignment';
    }
    return result;
  }

  static String? cgpa(String? value) {
    return numberInRange(value, min: 0.0, max: 4.0) != null
        ? AppStrings.errorCgpaRange
        : null;
  }

  /// Credit hours must be strictly positive.
  static String? creditHours(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return AppStrings.errorInvalidNumber;
    if (parsed <= 0) return AppStrings.errorCreditHours;
    return null;
  }

  /// Safely parses a numeric string, returning 0 on failure. Used only
  /// after a field has already passed its own validator, as a final
  /// safety net before running calculations.
  static double parseOrZero(String? value) {
    if (value == null || value.trim().isEmpty) return 0;
    return double.tryParse(value.trim()) ?? 0;
  }
}
