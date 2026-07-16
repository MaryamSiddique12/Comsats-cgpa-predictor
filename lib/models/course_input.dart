/// Immutable snapshot of everything the user entered in the input form.
///
/// The course structure is fixed to COMSATS' official weightage split:
///   Midterm = 25%, Quizzes = 10% (4 quizzes), Assignments = 15%
///   (4 assignments), Final Exam = 50%.
/// Because these weightages are official and fixed, they are not
/// user-editable — only the marks obtained within each component are.
///
/// Quizzes and assignments are entered on their own raw scales (each
/// quiz out of 10, each assignment out of 15) and then converted into
/// their official course weightage via [weightedQuizMarks] /
/// [weightedAssignmentMarks] — see the class-level doc on each getter
/// for the exact formula.
class CourseInput {
  // --- Midterm (25 marks total, contributes 25% directly) ---
  final double midtermMarks;
  static const double midtermMax = 25;

  // --- Quizzes: 4 quizzes, each out of 10 raw marks (max raw total
  // 40), contributing 10% to the course total overall. ---
  final double quiz1Marks;
  final double quiz2Marks;
  final double quiz3Marks;
  final double quiz4Marks;
  static const double quizMaxEach = 10;
  static const double rawQuizMaxTotal = 40;
  static const double quizWeightage = 10;

  // --- Assignments: 4 assignments, each out of 15 raw marks (max raw
  // total 60), contributing 15% to the course total overall. ---
  final double assignment1Marks;
  final double assignment2Marks;
  final double assignment3Marks;
  final double assignment4Marks;
  static const double assignmentMaxEach = 15;
  static const double rawAssignmentMaxTotal = 60;
  static const double assignmentWeightage = 15;

  // --- Final exam (50 marks total, fixed weightage) ---
  static const double finalWeightage = 50;

  final double currentCgpa;
  final double completedCreditHours;
  final double expectedSemesterCreditHours;
  final String targetGrade;

  const CourseInput({
    required this.midtermMarks,
    required this.quiz1Marks,
    required this.quiz2Marks,
    required this.quiz3Marks,
    required this.quiz4Marks,
    required this.assignment1Marks,
    required this.assignment2Marks,
    required this.assignment3Marks,
    required this.assignment4Marks,
    required this.currentCgpa,
    required this.completedCreditHours,
    required this.expectedSemesterCreditHours,
    required this.targetGrade,
  });

  /// rawQuizTotal = q1 + q2 + q3 + q4 (out of 40).
  double get rawQuizTotal => quiz1Marks + quiz2Marks + quiz3Marks + quiz4Marks;

  /// weightedQuizMarks = (rawQuizTotal / 40) * 10.
  double get weightedQuizMarks =>
      (rawQuizTotal / rawQuizMaxTotal) * quizWeightage;

  /// rawAssignmentTotal = a1 + a2 + a3 + a4 (out of 60).
  double get rawAssignmentTotal =>
      assignment1Marks + assignment2Marks + assignment3Marks + assignment4Marks;

  /// weightedAssignmentMarks = (rawAssignmentTotal / 60) * 15.
  double get weightedAssignmentMarks =>
      (rawAssignmentTotal / rawAssignmentMaxTotal) * assignmentWeightage;

  /// Total marks obtained so far, before the final exam:
  /// midterm + weightedQuizMarks + weightedAssignmentMarks.
  double get obtainedSoFar =>
      midtermMarks + weightedQuizMarks + weightedAssignmentMarks;

  /// Total possible marks for the whole course (components + final).
  /// Always 25 + 10 + 15 + 50 = 100 under the official structure.
  double get totalPossible =>
      midtermMax + quizWeightage + assignmentWeightage + finalWeightage;
}
