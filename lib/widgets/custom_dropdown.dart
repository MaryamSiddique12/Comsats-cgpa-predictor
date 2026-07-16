import 'package:flutter/material.dart';

import '../core/constants/app_text_styles.dart';

/// A labeled dropdown, used for target-grade selection. Generic enough
/// to reuse later for a "university" selector in the multi-university
/// expansion.
class CustomDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        // NOTE: uses the stable `value` parameter (not `initialValue`,
        // which only exists on newer Flutter SDKs) for compatibility
        // across Flutter versions.
        DropdownButtonFormField<String>(
          value: value,
          items: options
              .map(
                (grade) => DropdownMenuItem<String>(
                  value: grade,
                  child: Text(grade, style: AppTextStyles.inputText),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}
