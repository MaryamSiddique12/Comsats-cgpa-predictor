import 'grading_system.dart';

/// COMSATS University's official absolute grading scale (0–100%, 4.0
/// GPA scale), per the Version 1 official requirements:
///   90+    = 4.0
///   85–89  = 3.7
///   80–84  = 3.3
///   75–79  = 3.0
///   70–74  = 2.7
///   65–69  = 2.3
///   60–64  = 2.0
///   55–59  = 1.7
///   50–54  = 1.3
///   below 50 = 0.0
///
/// Because this table is fully isolated behind [GradingSystem], swapping
/// in a different scale later (or adding other universities'
/// [GradingSystem] implementations) requires no changes to the
/// calculator or UI.
class ComsatsGradingSystem extends GradingSystem {
  @override
  String get name => 'COMSATS University (Official Grading)';

  @override
  List<GradeBand> get gradeBands => const [
        GradeBand(label: 'A', minPercentage: 90, gpaValue: 4.0),
        GradeBand(label: 'A-', minPercentage: 85, gpaValue: 3.7),
        GradeBand(label: 'B+', minPercentage: 80, gpaValue: 3.3),
        GradeBand(label: 'B', minPercentage: 75, gpaValue: 3.0),
        GradeBand(label: 'B-', minPercentage: 70, gpaValue: 2.7),
        GradeBand(label: 'C+', minPercentage: 65, gpaValue: 2.3),
        GradeBand(label: 'C', minPercentage: 60, gpaValue: 2.0),
        GradeBand(label: 'C-', minPercentage: 55, gpaValue: 1.7),
        GradeBand(label: 'D', minPercentage: 50, gpaValue: 1.3),
        GradeBand(label: 'F', minPercentage: 0, gpaValue: 0.0),
      ];
}
