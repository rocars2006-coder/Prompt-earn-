import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final bool isOwnProfile;
  final VoidCallback? onEditProfile;
  final VoidCallback? onFollowToggle;

  const ProfileHeaderWidget({
    Key? key,
    required this.userProfile,
    required this.isOwnProfile,
    this.onEditProfile,
    this.onFollowToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          _buildProfileImage(),
          SizedBox(height: 2.h),
          _buildUserInfo(),
          SizedBox(height: 2.h),
          _buildStatsRow(),
          SizedBox(height: 2.h),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.accentColor,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: CustomImageWidget(
          imageUrl: userProfile["profileImage"] as String? ?? "",
          width: 25.w,
          height: 25.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          userProfile["username"] as String? ?? "Unknown User",
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          "Joined ${userProfile["joinDate"] as String? ?? "Unknown"}",
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (userProfile["bio"] != null &&
            (userProfile["bio"] as String).isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(
            userProfile["bio"] as String,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          "Prompts",
          (userProfile["totalPrompts"] as int? ?? 0).toString(),
        ),
        _buildStatItem(
          "Usage",
          (userProfile["totalUsage"] as int? ?? 0).toString(),
        ),
        _buildStatItem(
          "Rank",
          "#${userProfile["currentRank"] as int? ?? 0}",
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.accentColor,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isOwnProfile ? onEditProfile : onFollowToggle,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOwnProfile
              ? AppTheme.darkTheme.colorScheme.surface
              : AppTheme.accentColor,
          foregroundColor:
              isOwnProfile ? AppTheme.accentColor : AppTheme.primaryDark,
          side: isOwnProfile
              ? BorderSide(color: AppTheme.accentColor, width: 1.5)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: isOwnProfile ? 'edit' : 'person_add',
              color: isOwnProfile ? AppTheme.accentColor : AppTheme.primaryDark,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              isOwnProfile ? "Edit Profile" : "Follow",
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isOwnProfile ? AppTheme.accentColor : AppTheme.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
