import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PromptCardWidget extends StatelessWidget {
  final Map<String, dynamic> promptData;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onReport;
  final VoidCallback? onViewProfile;

  const PromptCardWidget({
    Key? key,
    required this.promptData,
    this.onShare,
    this.onSave,
    this.onReport,
    this.onViewProfile,
  }) : super(key: key);

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Prompt copied to clipboard!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accentColor,
      textColor: AppTheme.primaryDark,
      fontSize: 14.sp,
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionItem(
              context,
              'Save Prompt',
              'bookmark',
              AppTheme.successColor,
              onSave,
            ),
            _buildQuickActionItem(
              context,
              'View Creator Profile',
              'person',
              AppTheme.accentColor,
              onViewProfile,
            ),
            _buildQuickActionItem(
              context,
              'Report Prompt',
              'flag',
              AppTheme.errorColor,
              onReport,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String title,
    String iconName,
    Color color,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: color,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: AppTheme.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = (promptData['title'] as String?) ?? 'Untitled Prompt';
    final String description =
        (promptData['description'] as String?) ?? 'No description available';
    final String imageUrl = (promptData['imageUrl'] as String?) ?? '';
    final String creatorName =
        (promptData['creatorName'] as String?) ?? 'Anonymous';
    final int usageCount = (promptData['usageCount'] as int?) ?? 0;
    final String promptText = (promptData['promptText'] as String?) ?? '';
    final List<dynamic> tags = (promptData['tags'] as List?) ?? [];

    return GestureDetector(
      onLongPress: () => _showQuickActions(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large thumbnail image
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 25.h,
                  fit: BoxFit.cover,
                ),
              ),

            // Content section
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Description preview (100 words max)
                  Text(
                    description.length > 150
                        ? '${description.substring(0, 150)}...'
                        : description,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  // Tags
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children:
                          (tags.take(3).toList()).map<Widget>((dynamic tag) {
                        final String tagString = tag.toString();
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  AppTheme.accentColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '#$tagString',
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  if (tags.isNotEmpty) SizedBox(height: 2.h),

                  // Creator info and metrics
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.textTertiary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          creatorName,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: AppTheme.successColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '$usageCount uses',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _copyToClipboard(promptText),
                          icon: CustomIconWidget(
                            iconName: 'content_copy',
                            color: AppTheme.primaryDark,
                            size: 18,
                          ),
                          label: Text(
                            'Copy Prompt',
                            style: TextStyle(
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: AppTheme.primaryDark,
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 3.w),

                      // Share button
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.borderColor,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: onShare,
                          icon: CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(1.5.h),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
