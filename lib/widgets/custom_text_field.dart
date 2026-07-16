import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_text_styles.dart';

/// A labeled numeric input field with consistent styling and inline
/// validation, used throughout the input section.
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String? suffixText;
  final bool allowDecimal;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.validator,
    this.suffixText,
    this.allowDecimal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: AppTextStyles.inputText,
          keyboardType: TextInputType.numberWithOptions(
            decimal: allowDecimal,
          ),
          inputFormatters: [
            if (allowDecimal)
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            else
              FilteringTextInputFormatter.digitsOnly,
          ],
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            suffixText: suffixText,
            hintText: '0',
          ),
        ),
      ],
    );
  }
}
