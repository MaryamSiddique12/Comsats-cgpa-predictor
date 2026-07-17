/// Immutable snapshot of everything the user entered in the input form.
///
/// The course structure is fixed to COMSATS' official weightage split:
///   Midterm = 25%, Quizzes = 10% (4 quizzes), Assignments = 15%
///   (4 assignments), Final Exam = 50%.
/// Because these weightages are official and fixed, they are not
/// user-editable — only the marks obtained within each component are.
///
/// The *raw scale* each quiz/assignment is marked out of IS
/// configurable ([marksPerQuiz], [marksPerAssignment]) — e.g. an
/// instructor might mark quizzes out of 10 or out of 5. Changing the
/// raw scale never changes the fixed 10%/15% weightage; it only
/// changes how raw marks are converted into that weightage via
/// [weightedQuizMarks] / [weightedAssignmentMarks].
class CourseInput {
  // --- Midterm (25 marks total, contributes 25% directly) ---
  final double midtermMarks;
  static const double midtermMax = 25;

  // --- Quizzes: 4 quizzes, each out of [marksPerQuiz] raw marks,
  // contributing a FIXED 10% to the course total overall regardless
  // of what marksPerQuiz is set to. ---
  final double quiz1Marks;
  final double quiz2Marks;
  final double quiz3Marks;
  final double quiz4Marks;

  /// The raw scale each individual quiz is marked out of. Defaults to
  /// 10, but is configurable by the user (e.g. 5, 10, 20).
  final double marksPerQuiz;
  static const double defaultMarksPerQuiz = 10;
  static const double quizWeightage = 10; // fixed, never changes

  // --- Assignments: 4 assignments, each out of [marksPerAssignment]
  // raw marks, contributing a FIXED 15% to the course total overall
  // regardless of what marksPerAssignment is set to. ---
  final double assignment1Marks;
  final double assignment2Marks;
  final double assignment3Marks;
  final double assignment4Marks;

  /// The raw scale each individual assignment is marked out of.
  /// Defaults to 15, but is configurable by the user.
  final double marksPerAssignment;
  static const double defaultMarksPerAssignment = 15;
  static const double assignmentWeightage = 15; // fixed, never changes

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
    this.marksPerQuiz = defaultMarksPerQuiz,
    required this.assignment1Marks,
    required this.assignment2Marks,
    required this.assignment3Marks,
    required this.assignment4Marks,
    this.marksPerAssignment = defaultMarksPerAssignment,
    required this.currentCgpa,
    required this.completedCreditHours,
    required this.expectedSemesterCreditHours,
    required this.targetGrade,
  });

  /// rawQuizTotal = q1 + q2 + q3 + q4.
  double get rawQuizTotal => quiz1Marks + quiz2Marks + quiz3Marks + quiz4Marks;

  /// rawQuizMaxTotal = marksPerQuiz * 4.
  double get rawQuizMaxTotal => marksPerQuiz * 4;

  /// weightedQuizMarks = (rawQuizTotal / rawQuizMaxTotal) * 10.
  /// The 10% weightage is fixed regardless of marksPerQuiz.
  double get weightedQuizMarks => rawQuizMaxTotal <= 0
      ? 0
      : (rawQuizTotal / rawQuizMaxTotal) * quizWeightage;

  /// rawAssignmentTotal = a1 + a2 + a3 + a4.
  double get rawAssignmentTotal =>
      assignment1Marks + assignment2Marks + assignment3Marks + assignment4Marks;

  /// rawAssignmentMaxTotal = marksPerAssignment * 4.
  double get rawAssignmentMaxTotal => marksPerAssignment * 4;

  /// weightedAssignmentMarks = (rawAssignmentTotal / rawAssignmentMaxTotal) * 15.
  /// The 15% weightage is fixed regardless of marksPerAssignment.
  double get weightedAssignmentMarks => rawAssignmentMaxTotal <= 0
      ? 0
      : (rawAssignmentTotal / rawAssignmentMaxTotal) * assignmentWeightage;

  /// Total marks obtained so far, before the final exam:
  /// midterm + weightedQuizMarks + weightedAssignmentMarks.
  double get obtainedSoFar =>
      midtermMarks + weightedQuizMarks + weightedAssignmentMarks;

  /// Total possible marks for the whole course (components + final).
  /// Always 25 + 10 + 15 + 50 = 100 under the official structure —
  /// this stays constant no matter what marksPerQuiz/marksPerAssignment
  /// are set to, since those only affect how raw marks are scaled
  /// *into* the fixed 10%/15% pools.
  double get totalPossible =>
      midtermMax + quizWeightage + assignmentWeightage + finalWeightage;
}
