import 'package:flutter/foundation.dart';

import '../models/calculation_result.dart';
import '../models/comsats_grading_system.dart';
import '../models/course_input.dart';
import '../models/grading_system.dart';
import '../services/gpa_calculator_service.dart';

/// Owns the "active grading system" + latest [CalculationResult] and
/// notifies listeners when either changes.
///
/// This is intentionally the ONLY place that knows which
/// [GradingSystem] is active. Today it's hard-wired to
/// [ComsatsGradingSystem]; the future multi-university expansion swaps
/// that single line (or turns it into a user-selectable value) without
/// any other file needing to change.
class CalculatorController extends ChangeNotifier {
  CalculatorController({GradingSystem? gradingSystem})
      : gradingSystem = gradingSystem ?? ComsatsGradingSystem() {
    _service = GpaCalculatorService(this.gradingSystem);
  }

  final GradingSystem gradingSystem;
  late final GpaCalculatorService _service;

  CalculationResult? _result;
  CalculationResult? get result => _result;

  /// Runs the calculation for [input] and notifies listeners with the
  /// new result.
  void calculate(CourseInput input) {
    _result = _service.calculate(input);
    notifyListeners();
  }

  /// Clears the current result (called when the form is reset).
  void reset() {
    _result = null;
    notifyListeners();
  }
}
