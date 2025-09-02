import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CharacterCounterWidget extends StatelessWidget {
  final String text;
  final int maxLength;

  const CharacterCounterWidget({
    Key? key,
    required this.text,
    required this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLength = text.length;
    final isOverLimit = currentLength > maxLength;
    final color = isOverLimit ? AppTheme.errorColor : AppTheme.textSecondary;

    return Padding(
      padding: EdgeInsets.only(top: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$currentLength/$maxLength',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
