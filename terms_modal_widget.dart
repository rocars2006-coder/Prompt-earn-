import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsModalWidget extends StatelessWidget {
  const TermsModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms & Privacy',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: AppTheme.borderColor,
            height: 1,
            thickness: 1,
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Terms of Service',
                    _getTermsContent(),
                  ),
                  SizedBox(height: 4.h),
                  _buildSection(
                    'Privacy Policy',
                    _getPrivacyContent(),
                  ),
                ],
              ),
            ),
          ),

          // Accept button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.primaryDark,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'I Understand',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryDark,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.accentColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          content,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 13.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _getTermsContent() {
    return '''Welcome to Prompt Earn! By creating an account, you agree to these terms:

1. Account Responsibility
You are responsible for maintaining the security of your account and all activities that occur under your account.

2. Content Guidelines
All prompts shared must be original or properly attributed. Inappropriate, harmful, or copyrighted content is prohibited.

3. Earning System
Earnings are based on prompt usage metrics and monthly leaderboard rankings. Rewards are distributed fairly and transparently.

4. Community Standards
Respect other users, provide constructive feedback, and maintain a positive environment for all creators.

5. Intellectual Property
You retain ownership of your original prompts while granting us license to display and distribute them on our platform.

6. Prohibited Activities
No spam, fake accounts, manipulation of metrics, or any activities that harm the platform or other users.

7. Account Termination
We reserve the right to suspend or terminate accounts that violate these terms or engage in harmful behavior.''';
  }

  String _getPrivacyContent() {
    return '''Your privacy is important to us. Here's how we handle your data:

1. Information We Collect
We collect information you provide (email, display name, prompts) and usage data to improve our services.

2. How We Use Your Data
Your data helps us provide personalized experiences, calculate earnings, and maintain platform security.

3. Data Sharing
We don't sell your personal information. Data is only shared with trusted partners for essential services.

4. Data Security
We use industry-standard encryption and security measures to protect your information.

5. Your Rights
You can access, update, or delete your personal information at any time through your account settings.

6. Cookies and Tracking
We use cookies to enhance your experience and analyze platform usage patterns.

7. Data Retention
We retain your data as long as your account is active or as needed to provide services.

8. Contact Us
For privacy concerns or questions, contact our support team through the app settings.''';
  }
}
