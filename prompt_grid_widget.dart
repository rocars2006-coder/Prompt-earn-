import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PromptGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> prompts;
  final bool isOwnProfile;
  final Function(Map<String, dynamic>) onPromptTap;
  final Function(Map<String, dynamic>) onEditPrompt;
  final Function(Map<String, dynamic>) onDeletePrompt;
  final Function(Map<String, dynamic>) onSharePrompt;
  final VoidCallback? onRefresh;

  const PromptGridWidget({
    Key? key,
    required this.prompts,
    required this.isOwnProfile,
    required this.onPromptTap,
    required this.onEditPrompt,
    required this.onDeletePrompt,
    required this.onSharePrompt,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (prompts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      color: AppTheme.accentColor,
      backgroundColor: AppTheme.secondaryDark,
      child: GridView.builder(
        padding: EdgeInsets.all(4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 3.w,
          childAspectRatio: 0.75,
        ),
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          return _buildPromptCard(prompts[index]);
        },
      ),
    );
  }

  Widget _buildPromptCard(Map<String, dynamic> prompt) {
    return GestureDetector(
      onTap: () => onPromptTap(prompt),
      onLongPress: isOwnProfile ? () => _showContextMenu(prompt) : null,
      child: Container(
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
            _buildPromptImage(prompt),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prompt["title"] as String? ?? "Untitled",
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Expanded(
                      child: Text(
                        prompt["description"] as String? ?? "",
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildPromptStats(prompt),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptImage(Map<String, dynamic> prompt) {
    return Container(
      height: 20.w,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: CustomImageWidget(
          imageUrl: prompt["imageUrl"] as String? ?? "",
          width: double.infinity,
          height: 20.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPromptStats(Map<String, dynamic> prompt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'visibility',
              color: AppTheme.textTertiary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              "${prompt["usageCount"] as int? ?? 0}",
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textTertiary,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'favorite',
              color: AppTheme.textTertiary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              "${prompt["likes"] as int? ?? 0}",
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textTertiary,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'article',
            color: AppTheme.textTertiary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            isOwnProfile ? "No prompts yet" : "No prompts found",
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            isOwnProfile
                ? "Create your first prompt to get started"
                : "This user hasn't shared any prompts yet",
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          if (isOwnProfile) ...[
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                // Navigate to prompt creation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryDark,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.primaryDark,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text("Create First Prompt"),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> prompt) {
    // This would typically show a bottom sheet or popup menu
    // For now, we'll just call the edit function
    onEditPrompt(prompt);
  }
}
