import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/core.dart';

class TextInputField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextInputType inputType;
  final bool obscureText;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final int maxLines;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool enabled;
  final Widget? suffix;
  final Widget? prefix;
  final List<TextInputFormatter> inputFormatters;
  final String? errorText;
  final FocusNode? focusNode;
  final Widget? multiLineIcon;
  final int? maxLength;

  const TextInputField({
    this.label,
    required this.inputType,
    this.hint = '',
    this.obscureText = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.words,
    this.initialValue,
    this.maxLines = 1,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.controller,
    this.enabled = true,
    this.suffix,
    this.prefix,
    required this.inputFormatters,
    this.errorText,
    this.focusNode,
    this.multiLineIcon,
    this.maxLength,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        if (label != null)
          Text(
            label!,
            style: textTheme.subtitle1!.copyWith(color: AppTheme.fontLightColor),
          ),
        // spacing
        if (label != null) const SizedBox(height: 8.0),
        // text field
        TextFormField(
          controller: controller,
          style: obscureText ? textTheme.headline4!.copyWith(letterSpacing: 2.0) : textTheme.bodyText1,
          autofocus: autofocus,
          keyboardType: inputType,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          initialValue: initialValue,
          maxLines: maxLines,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
          decoration: InputDecoration(
            prefixIcon: prefix,
            errorText: errorText,
            alignLabelWithHint: true,
            errorStyle: textTheme.bodyText2!.copyWith(color: AppTheme.secondaryColor),
            filled: true,
            fillColor: AppTheme.cardColor,
            suffix: multiLineIcon,
            suffixIcon: multiLineIcon != null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: suffix,
                  ),
            counterStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.fontLightColor,
            ),
          ),
          inputFormatters: inputFormatters,
          focusNode: focusNode,
        ),
      ],
    );
  }
}
