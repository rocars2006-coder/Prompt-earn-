import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_dropdown_widget.dart';
import './widgets/character_counter_widget.dart';
import './widgets/image_upload_widget.dart';
import './widgets/tag_input_widget.dart';

class PromptCreationScreen extends StatefulWidget {
  const PromptCreationScreen({Key? key}) : super(key: key);

  @override
  State<PromptCreationScreen> createState() => _PromptCreationScreenState();
}

class _PromptCreationScreenState extends State<PromptCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  XFile? _selectedImage;
  List<String> _selectedTags = [];
  String? _selectedCategory;
  bool _isPublishing = false;
  bool _hasUnsavedChanges = false;

  // Character limits
  static const int _titleMaxLength = 60;
  static const int _descriptionMaxLength = 500; // ~100 words

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFormChanged);
    _descriptionController.removeListener(_onFormChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      _hasUnsavedChanges = _titleController.text.isNotEmpty ||
          _descriptionController.text.isNotEmpty ||
          _selectedImage != null ||
          _selectedTags.isNotEmpty ||
          _selectedCategory != null;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: Text(
          'Unsaved Changes',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Stay',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Leave',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  void _onImageSelected(XFile? image) {
    setState(() {
      _selectedImage = image;
    });
    _onFormChanged();
  }

  void _onTagsChanged(List<String> tags) {
    setState(() {
      _selectedTags = tags;
    });
    _onFormChanged();
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _onFormChanged();
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedCategory == null) {
      _showErrorSnackBar('Please select a category');
      return false;
    }

    if (_selectedImage == null) {
      _showErrorSnackBar('Please add an image');
      return false;
    }

    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _publishPrompt() async {
    if (!_validateForm()) return;

    setState(() => _isPublishing = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Haptic feedback
      HapticFeedback.lightImpact();

      _showSuccessSnackBar('Prompt published successfully!');

      // Navigate back to feed
      Navigator.pushReplacementNamed(context, '/main-feed-screen');
    } catch (e) {
      _showErrorSnackBar('Failed to publish prompt. Please try again.');
    } finally {
      setState(() => _isPublishing = false);
    }
  }

  void _previewPrompt() {
    if (_titleController.text.isEmpty && _descriptionController.text.isEmpty) {
      _showErrorSnackBar('Add some content to preview');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildPreviewModal(),
    );
  }

  Widget _buildPreviewModal() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
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
                  'Preview',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
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

          // Preview content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildPromptCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (_selectedImage != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 25.h,
                width: double.infinity,
                color: AppTheme.surfaceElevated,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'image',
                        color: AppTheme.accentColor,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Image Preview',
                        style: AppTheme.darkTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                if (_titleController.text.isNotEmpty)
                  Text(
                    _titleController.text,
                    style: AppTheme.darkTheme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                if (_titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty)
                  SizedBox(height: 2.h),

                // Description
                if (_descriptionController.text.isNotEmpty)
                  Text(
                    _descriptionController.text,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),

                if (_selectedTags.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _selectedTags
                        .take(3)
                        .map((tag) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.accentColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag,
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],

                SizedBox(height: 2.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.accentColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'content_copy',
                              color: AppTheme.accentColor,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Copy',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Container(
                      padding: EdgeInsets.all(1.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.primaryDark,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryDark,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
          title: Text(
            'Create Prompt',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          actions: [
            TextButton(
              onPressed: _previewPrompt,
              child: Text(
                'Preview',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 4.w),
              child: ElevatedButton(
                onPressed: _isPublishing ? null : _publishPrompt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.primaryDark,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isPublishing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryDark,
                        ),
                      )
                    : Text(
                        'Publish',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                Text(
                  'Title *',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Give your prompt a catchy and descriptive title',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _titleController,
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  maxLength: _titleMaxLength,
                  decoration: InputDecoration(
                    hintText: 'Enter prompt title...',
                    counterText: '',
                    filled: true,
                    fillColor: AppTheme.secondaryDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppTheme.accentColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    if (value.trim().length < 5) {
                      return 'Title must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 1.h),
                CharacterCounterWidget(
                  currentLength: _titleController.text.length,
                  maxLength: _titleMaxLength,
                  isError: _titleController.text.length > _titleMaxLength,
                ),

                SizedBox(height: 4.h),

                // Description field
                Text(
                  'Description *',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Provide a detailed description of your prompt and its use case',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _descriptionController,
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  maxLines: 6,
                  maxLength: _descriptionMaxLength,
                  decoration: InputDecoration(
                    hintText:
                        'Describe your prompt, its purpose, and how to use it effectively...',
                    counterText: '',
                    filled: true,
                    fillColor: AppTheme.secondaryDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppTheme.accentColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    if (value.trim().length < 20) {
                      return 'Description must be at least 20 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 1.h),
                CharacterCounterWidget(
                  currentLength: _descriptionController.text.length,
                  maxLength: _descriptionMaxLength,
                  isError: _descriptionController.text.length >
                      _descriptionMaxLength,
                ),

                SizedBox(height: 4.h),

                // Image upload
                Text(
                  'Image *',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Add an eye-catching image to represent your prompt',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                ImageUploadWidget(
                  selectedImage: _selectedImage,
                  onImageSelected: _onImageSelected,
                ),

                SizedBox(height: 4.h),

                // Category dropdown
                CategoryDropdownWidget(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: _onCategoryChanged,
                ),

                SizedBox(height: 4.h),

                // Tags input
                TagInputWidget(
                  selectedTags: _selectedTags,
                  onTagsChanged: _onTagsChanged,
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
