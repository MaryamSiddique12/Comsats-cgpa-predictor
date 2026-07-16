/// A single letter grade band: a label, the minimum percentage needed
/// to earn it, and its grade-point value on a 4.0 scale.
class GradeBand {
  final String label; // e.g. "A", "A-", "B+"
  final double minPercentage; // inclusive lower bound, e.g. 85.0
  final double gpaValue; // e.g. 4.0

  const GradeBand({
    required this.label,
    required this.minPercentage,
    required this.gpaValue,
  });
}

/// Abstract contract for a university's grading system.
///
/// This is the seam that lets the app support multiple universities in
/// the future (per the brief's "Future Expansion" section): a new
/// university is added by implementing this interface with its own
/// grade bands, without touching any calculation or UI code.
abstract class GradingSystem {
  /// Human-readable name, e.g. "COMSATS University Islamabad".
  String get name;

  /// All grade bands, ordered from highest to lowest.
  List<GradeBand> get gradeBands;

  /// Convenience list of grade labels for dropdowns, e.g.
  /// ["A", "A-", "B+", "B", ...].
  List<String> get gradeLabels => gradeBands.map((g) => g.label).toList();

  /// Returns the [GradeBand] matching [label], or null if not found.
  GradeBand? bandForLabel(String label) {
    for (final band in gradeBands) {
      if (band.label == label) return band;
    }
    return null;
  }

  /// Returns the grade band whose range contains [percentage].
  GradeBand bandForPercentage(double percentage) {
    for (final band in gradeBands) {
      if (percentage >= band.minPercentage) return band;
    }
    // Fall back to the lowest band (e.g. "F") if below every threshold.
    return gradeBands.last;
  }
}
