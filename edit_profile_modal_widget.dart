import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EditProfileModalWidget extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileModalWidget({
    Key? key,
    required this.userProfile,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditProfileModalWidget> createState() => _EditProfileModalWidgetState();
}

class _EditProfileModalWidgetState extends State<EditProfileModalWidget> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String? _selectedImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.userProfile["username"] as String? ?? "",
    );
    _bioController = TextEditingController(
      text: widget.userProfile["bio"] as String? ?? "",
    );
    _selectedImageUrl = widget.userProfile["profileImage"] as String?;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileImageSection(),
                  SizedBox(height: 3.h),
                  _buildUsernameField(),
                  SizedBox(height: 3.h),
                  _buildBioField(),
                  SizedBox(height: 4.h),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Text(
            "Edit Profile",
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(width: 16.w), // Balance the layout
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _selectImage,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentColor,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: _selectedImageUrl != null
                    ? CustomImageWidget(
                        imageUrl: _selectedImageUrl!,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppTheme.borderColor,
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.textSecondary,
                          size: 40,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: _selectImage,
            child: Text(
              "Change Photo",
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Username",
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _usernameController,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: "Enter your username",
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          maxLength: 30,
        ),
      ],
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bio",
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _bioController,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: "Tell us about yourself...",
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'info',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          maxLines: 4,
          maxLength: 150,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: AppTheme.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryDark),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'save',
                    color: AppTheme.primaryDark,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    "Save Changes",
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _selectImage() {
    // Mock image selection - in real app would use image_picker
    final List<String> mockImages = [
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
    ];

    setState(() {
      _selectedImageUrl = mockImages[
          (mockImages.indexOf(_selectedImageUrl ?? "") + 1) %
              mockImages.length];
    });
  }

  void _saveProfile() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username cannot be empty"),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    final updatedProfile = Map<String, dynamic>.from(widget.userProfile);
    updatedProfile["username"] = _usernameController.text.trim();
    updatedProfile["bio"] = _bioController.text.trim();
    updatedProfile["profileImage"] = _selectedImageUrl;

    widget.onSave(updatedProfile);
    Navigator.pop(context);
  }
}
