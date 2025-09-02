import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TermsCheckboxWidget extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTermsTap;

  const TermsCheckboxWidget({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.onTermsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: AppTheme.accentColor,
            checkColor: AppTheme.primaryDark,
            side: BorderSide(
              color: isChecked ? AppTheme.accentColor : AppTheme.borderColor,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 12.sp,
                height: 1.4,
              ),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.accentColor,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.accentColor,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
