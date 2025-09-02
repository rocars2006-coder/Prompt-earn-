import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    final strengthColor = _getStrengthColor(strength);
    final strengthText = _getStrengthText(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 0.5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppTheme.borderColor,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: strength / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: strengthColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              strengthText,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: strengthColor,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;

    // Uppercase check
    if (password.contains(RegExp(r'[A-Z]'))) strength++;

    // Lowercase check
    if (password.contains(RegExp(r'[a-z]'))) strength++;

    // Number check
    if (password.contains(RegExp(r'[0-9]'))) strength++;

    // Special character check
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength > 4 ? 4 : strength;
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppTheme.errorColor;
      case 2:
        return AppTheme.warningColor;
      case 3:
        return AppTheme.warningColor.withValues(alpha: 0.8);
      case 4:
        return AppTheme.successColor;
      default:
        return AppTheme.errorColor;
    }
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
        return 'Very Weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Very Weak';
    }
  }
}
