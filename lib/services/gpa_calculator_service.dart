import '../models/calculation_result.dart';
import '../models/course_input.dart';
import '../models/grading_system.dart';

/// All GPA/CGPA math lives here, deliberately separated from widgets so
/// it can be unit-tested and reused (e.g. by a future "what-if" scenario
/// comparison screen that runs it many times over slightly different
/// inputs).
///
/// The service is constructed with a [GradingSystem] rather than a
/// hard-coded COMSATS table, so supporting another university later is
/// just: `GpaCalculatorService(otherUniversityGradingSystem)`.
class GpaCalculatorService {
  final GradingSystem gradingSystem;

  const GpaCalculatorService(this.gradingSystem);

  /// Runs the full prediction pipeline for a single course + semester.
  CalculationResult calculate(CourseInput input) {
    final obtainedSoFar = input.obtainedSoFar;
    final totalPossible = input.totalPossible;

    final targetBand = gradingSystem.bandForLabel(input.targetGrade);

    double? requiredFinalMarks;
    bool isTargetAchievable = true;
    String? targetMessage;

    if (targetBand == null) {
      isTargetAchievable = false;
      targetMessage = 'Unknown target grade for the active grading system.';
    } else {
      // Marks needed across the WHOLE course to reach the target
      // grade's minimum percentage, translated into raw marks on the
      // totalPossible scale.
      final requiredTotalMarks =
          (targetBand.minPercentage / 100) * totalPossible;
      final rawRequiredFinal = requiredTotalMarks - obtainedSoFar;

      if (rawRequiredFinal <= 0) {
        // Already secured, even scoring zero in the final.
        requiredFinalMarks = 0;
        targetMessage =
            'Target already secured — 0 marks needed in the final exam.';
      } else if (rawRequiredFinal > CourseInput.finalWeightage) {
        // Not mathematically possible.
        requiredFinalMarks = CourseInput.finalWeightage;
        isTargetAchievable = false;
        targetMessage =
            'Not achievable: even full marks in the final exam fall short '
            'of the target grade.';
      } else {
        requiredFinalMarks = rawRequiredFinal;
      }
    }

    // --- Predicted Course GPA ---
    // Best-effort prediction of the course grade point. If the target
    // is achievable, we predict the student hits it exactly (the
    // scenario they asked about). If not achievable, we predict the
    // best possible outcome (full marks in the final) so the number
    // reflects the true ceiling rather than a misleading "target" GPA.
    double predictedPercentage;
    if (isTargetAchievable) {
      predictedPercentage = ((obtainedSoFar + (requiredFinalMarks ?? 0)) /
              totalPossible) *
          100;
    } else {
      predictedPercentage =
          ((obtainedSoFar + CourseInput.finalWeightage) / totalPossible) *
              100;
    }
    final predictedCourseGpa =
        gradingSystem.bandForPercentage(predictedPercentage).gpaValue;

    // --- Predicted Semester GPA ---
    // The MVP models a single representative course; the semester GPA
    // is therefore this course's predicted GPA. (Future expansion: once
    // multiple courses can be entered, this becomes a credit-weighted
    // average across all of them.)
    final predictedSemesterGpa = predictedCourseGpa;

    // --- Predicted Updated CGPA ---
    // Standard credit-weighted CGPA rollup:
    //   newCGPA = (oldCGPA * completedHours + semesterGPA * newHours)
    //             / (completedHours + newHours)
    final combinedHours =
        input.completedCreditHours + input.expectedSemesterCreditHours;
    final predictedCgpa = combinedHours <= 0
        ? input.currentCgpa
        : ((input.currentCgpa * input.completedCreditHours) +
                (predictedSemesterGpa * input.expectedSemesterCreditHours)) /
            combinedHours;

    return CalculationResult(
      obtainedSoFar: obtainedSoFar,
      totalPossible: totalPossible,
      requiredFinalMarks: requiredFinalMarks,
      finalWeightage: CourseInput.finalWeightage,
      isTargetAchievable: isTargetAchievable,
      targetMessage: targetMessage,
      predictedCourseGpa: double.parse(predictedCourseGpa.toStringAsFixed(2)),
      predictedSemesterGpa:
          double.parse(predictedSemesterGpa.toStringAsFixed(2)),
      predictedCgpa: double.parse(predictedCgpa.toStringAsFixed(2)),
    );
  }
}
