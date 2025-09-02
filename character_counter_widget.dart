import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CharacterCounterWidget extends StatelessWidget {
  final int currentLength;
  final int maxLength;
  final bool isError;

  const CharacterCounterWidget({
    Key? key,
    required this.currentLength,
    required this.maxLength,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = currentLength / maxLength;
    final isNearLimit = percentage >= 0.8;
    final isAtLimit = currentLength >= maxLength;

    Color getCounterColor() {
      if (isError || isAtLimit) return AppTheme.errorColor;
      if (isNearLimit) return AppTheme.warningColor;
      return AppTheme.textSecondary;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Progress indicator
        Expanded(
          child: Container(
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (percentage > 1.0 ? 1.0 : percentage),
              child: Container(
                decoration: BoxDecoration(
                  color: getCounterColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),

        // Counter text
        Text(
          '$currentLength/$maxLength',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: getCounterColor(),
            fontWeight: isAtLimit ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
