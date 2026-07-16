import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_text_styles.dart';
import '../core/utils/validators.dart';
import '../models/course_input.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';

/// The full input form: midterm, a grouped quizzes section, a grouped
/// assignments section, CGPA/credit-hour fields, and target grade —
/// plus Calculate / Reset actions.
///
/// This widget owns its [TextEditingController]s and its [Form] key; it
/// only ever talks to the outside world through [onCalculate] and
/// [onReset], keeping it fully decoupled from the calculation service
/// and from how/where results get displayed.
class InputSection extends StatefulWidget {
  final List<String> gradeOptions;
  final void Function(CourseInput input) onCalculate;
  final VoidCallback onReset;

  const InputSection({
    super.key,
    required this.gradeOptions,
    required this.onCalculate,
    required this.onReset,
  });

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final _formKey = GlobalKey<FormState>();

  final _midtermController = TextEditingController();

  final _quiz1Controller = TextEditingController();
  final _quiz2Controller = TextEditingController();
  final _quiz3Controller = TextEditingController();
  final _quiz4Controller = TextEditingController();

  final _assignment1Controller = TextEditingController();
  final _assignment2Controller = TextEditingController();
  final _assignment3Controller = TextEditingController();
  final _assignment4Controller = TextEditingController();

  final _currentCgpaController = TextEditingController();
  final _completedCreditHoursController = TextEditingController();
  final _expectedCreditHoursController = TextEditingController();

  // NOTE: `widget` is not safely accessible from a field initializer
  // (the framework attaches the widget to this State object AFTER
  // construction, but BEFORE initState()). So the default target
  // grade is assigned in initState(), not inline above.
  late String _targetGrade;

  @override
  void initState() {
    super.initState();
    _targetGrade = widget.gradeOptions.first;
  }

  @override
  void dispose() {
    _midtermController.dispose();
    _quiz1Controller.dispose();
    _quiz2Controller.dispose();
    _quiz3Controller.dispose();
    _quiz4Controller.dispose();
    _assignment1Controller.dispose();
    _assignment2Controller.dispose();
    _assignment3Controller.dispose();
    _assignment4Controller.dispose();
    _currentCgpaController.dispose();
    _completedCreditHoursController.dispose();
    _expectedCreditHoursController.dispose();
    super.dispose();
  }

  void _handleCalculate() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final input = CourseInput(
      midtermMarks: Validators.parseOrZero(_midtermController.text),
      quiz1Marks: Validators.parseOrZero(_quiz1Controller.text),
      quiz2Marks: Validators.parseOrZero(_quiz2Controller.text),
      quiz3Marks: Validators.parseOrZero(_quiz3Controller.text),
      quiz4Marks: Validators.parseOrZero(_quiz4Controller.text),
      assignment1Marks: Validators.parseOrZero(_assignment1Controller.text),
      assignment2Marks: Validators.parseOrZero(_assignment2Controller.text),
      assignment3Marks: Validators.parseOrZero(_assignment3Controller.text),
      assignment4Marks: Validators.parseOrZero(_assignment4Controller.text),
      currentCgpa: Validators.parseOrZero(_currentCgpaController.text),
      completedCreditHours:
          Validators.parseOrZero(_completedCreditHoursController.text),
      expectedSemesterCreditHours:
          Validators.parseOrZero(_expectedCreditHoursController.text),
      targetGrade: _targetGrade,
    );

    widget.onCalculate(input);
  }

  void _handleReset() {
    _formKey.currentState?.reset();
    _midtermController.clear();
    _quiz1Controller.clear();
    _quiz2Controller.clear();
    _quiz3Controller.clear();
    _quiz4Controller.clear();
    _assignment1Controller.clear();
    _assignment2Controller.clear();
    _assignment3Controller.clear();
    _assignment4Controller.clear();
    _currentCgpaController.clear();
    _completedCreditHoursController.clear();
    _expectedCreditHoursController.clear();
    setState(() {
      _targetGrade = widget.gradeOptions.first;
    });
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.inputSectionTitle,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 20),

          // --- Midterm ---
          CustomTextField(
            label: AppStrings.midtermLabel,
            controller: _midtermController,
            validator: Validators.midterm,
          ),
          const SizedBox(height: 28),

          // --- Quizzes (grouped section) ---
          _GroupedSection(
            title: AppStrings.quizSectionTitle,
            child: _FieldGrid(
              isMobile: isMobile,
              children: [
                CustomTextField(
                  label: AppStrings.quiz1Label,
                  controller: _quiz1Controller,
                  validator: Validators.quizField,
                ),
                CustomTextField(
                  label: AppStrings.quiz2Label,
                  controller: _quiz2Controller,
                  validator: Validators.quizField,
                ),
                CustomTextField(
                  label: AppStrings.quiz3Label,
                  controller: _quiz3Controller,
                  validator: Validators.quizField,
                ),
                CustomTextField(
                  label: AppStrings.quiz4Label,
                  controller: _quiz4Controller,
                  validator: Validators.quizField,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // --- Assignments (grouped section) ---
          _GroupedSection(
            title: AppStrings.assignmentSectionTitle,
            child: _FieldGrid(
              isMobile: isMobile,
              children: [
                CustomTextField(
                  label: AppStrings.assignment1Label,
                  controller: _assignment1Controller,
                  validator: Validators.assignmentField,
                ),
                CustomTextField(
                  label: AppStrings.assignment2Label,
                  controller: _assignment2Controller,
                  validator: Validators.assignmentField,
                ),
                CustomTextField(
                  label: AppStrings.assignment3Label,
                  controller: _assignment3Controller,
                  validator: Validators.assignmentField,
                ),
                CustomTextField(
                  label: AppStrings.assignment4Label,
                  controller: _assignment4Controller,
                  validator: Validators.assignmentField,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // --- CGPA / credit hours / target grade ---
          _FieldGrid(
            isMobile: isMobile,
            children: [
              CustomTextField(
                label: AppStrings.currentCgpaLabel,
                controller: _currentCgpaController,
                validator: Validators.cgpa,
              ),
              CustomTextField(
                label: AppStrings.completedCreditHoursLabel,
                controller: _completedCreditHoursController,
                validator: Validators.creditHours,
                allowDecimal: false,
              ),
              CustomTextField(
                label: AppStrings.expectedCreditHoursLabel,
                controller: _expectedCreditHoursController,
                validator: Validators.creditHours,
                allowDecimal: false,
              ),
              CustomDropdown(
                label: AppStrings.targetGradeLabel,
                value: _targetGrade,
                options: widget.gradeOptions,
                onChanged: (grade) {
                  if (grade != null) setState(() => _targetGrade = grade);
                },
              ),
            ],
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: _handleCalculate,
                icon: const Icon(Icons.calculate_outlined, size: 20),
                label: const Text(AppStrings.calculateButton),
              ),
              OutlinedButton.icon(
                onPressed: _handleReset,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(AppStrings.resetButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A titled, lightly-bordered group used to visually cluster the four
/// quiz fields (or the four assignment fields) as one unit.
class _GroupedSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _GroupedSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.fieldLabel.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Lays fields out as 2 columns on desktop/tablet and 1 column on
/// mobile, without pulling in an external grid package.
class _FieldGrid extends StatelessWidget {
  final bool isMobile;
  final List<Widget> children;

  const _FieldGrid({required this.isMobile, required this.children});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: children
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: c,
                ))
            .toList(),
      );
    }

    // Two-column responsive grid for wider viewports.
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final hasSecond = i + 1 < children.length;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: 24),
              Expanded(
                child: hasSecond ? children[i + 1] : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
