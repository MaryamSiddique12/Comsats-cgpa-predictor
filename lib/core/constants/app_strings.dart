/// All user-facing copy lives here so it can be reviewed, localized, or
/// changed without hunting through widget code.
class AppStrings {
  AppStrings._();

  static const String appTitle = 'COMSATS CGPA Predictor';
  static const String appSubtitle =
      'Predict your semester GPA, forecast your CGPA, and find out '
      'exactly what you need to score in your final exam to hit your '
      'target grade — built for COMSATS students.';

  static const String inputSectionTitle = 'Course & Semester Details';
  static const String resultsSectionTitle = 'Your Predicted Results';

  // Field labels
  static const String midtermLabel = 'Midterm Marks (out of 25)';

  // "Marks per Quiz" / "Marks per Assignment" — configurable raw
  // scales. Changing these never changes the fixed 10%/15% weightage.
  static const String marksPerQuizLabel = 'Marks per Quiz';
  static const String marksPerAssignmentLabel = 'Marks per Assignment';
  static const String weightageHelperText =
      'Changing the total marks only rescales the raw marks you enter '
      'below — the quiz component always contributes 10% and the '
      'assignment component always contributes 15% to your final '
      'course total.';

  // Quizzes are grouped into their own section; each quiz is out of
  // the configurable "Marks per Quiz" value, and the component always
  // contributes a fixed 10% overall regardless of that value.
  static String quizSectionTitle(double marksPerQuiz) =>
      'Quizzes (4 quizzes, each out of ${_trimZero(marksPerQuiz)} marks)';
  static const String quiz1Label = 'Quiz 1';
  static const String quiz2Label = 'Quiz 2';
  static const String quiz3Label = 'Quiz 3';
  static const String quiz4Label = 'Quiz 4';

  // Assignments are grouped into their own section; each assignment is
  // out of the configurable "Marks per Assignment" value, and the
  // component always contributes a fixed 15% overall regardless of
  // that value.
  static String assignmentSectionTitle(double marksPerAssignment) =>
      'Assignments (4 assignments, each out of '
      '${_trimZero(marksPerAssignment)} marks)';
  static const String assignment1Label = 'Assignment 1';
  static const String assignment2Label = 'Assignment 2';
  static const String assignment3Label = 'Assignment 3';
  static const String assignment4Label = 'Assignment 4';

  /// Formats a whole-number double without a trailing ".0" (e.g. 10
  /// instead of 10.0), but keeps one decimal place for non-whole
  /// values (e.g. 7.5).
  static String _trimZero(double value) {
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }

  static const String currentCgpaLabel = 'Current CGPA';
  static const String completedCreditHoursLabel = 'Completed Credit Hours';
  static const String expectedCreditHoursLabel =
      'Expected Semester Credit Hours';
  static const String targetGradeLabel = 'Target Grade';

  // Result card labels
  static const String requiredFinalMarksLabel = 'Required Final Marks';
  static const String predictedCourseGpaLabel = 'Predicted Course GPA';
  static const String predictedSemesterGpaLabel = 'Predicted Semester GPA';
  static const String predictedCgpaLabel = 'Predicted Updated CGPA';

  static const String calculateButton = 'Calculate';
  static const String resetButton = 'Reset';

  // Validation messages
  static const String errorRequired = 'This field is required';
  static const String errorInvalidNumber = 'Enter a valid number';
  static const String errorOutOfRange = 'Value is out of the allowed range';
  static const String errorCgpaRange = 'CGPA must be between 0.0 and 4.0';
  static const String errorCreditHours = 'Credit hours must be greater than 0';

  static const String noResultsYet =
      'Fill in the details and tap Calculate to see your predictions here.';
  static const String targetUnreachableLow =
      'Target grade is already secured even with 0 in the final exam.';
  static const String targetUnreachableHigh =
      'Target grade is not achievable even with full final exam marks.';
}
