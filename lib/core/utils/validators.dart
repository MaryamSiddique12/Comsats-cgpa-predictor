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

  /// A single quiz field: each of the 4 quizzes is out of 10 raw marks.
  /// There is no total cap here — the raw total across all 4 quizzes
  /// is allowed to go up to 40 (it is then converted into the
  /// official 10% quiz weightage via weightedQuizMarks).
  static String? quizField(String? value) =>
      numberInRange(value, min: 0, max: 10);

  /// A single assignment field: each of the 4 assignments is out of 15
  /// raw marks. There is no total cap here — the raw total across all
  /// 4 assignments is allowed to go up to 60 (it is then converted
  /// into the official 15% assignment weightage via
  /// weightedAssignmentMarks).
  static String? assignmentField(String? value) =>
      numberInRange(value, min: 0, max: 15);

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
