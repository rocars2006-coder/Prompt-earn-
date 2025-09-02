import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TagInputWidget extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;

  const TagInputWidget({
    Key? key,
    required this.selectedTags,
    required this.onTagsChanged,
  }) : super(key: key);

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  // Mock popular tags for autocomplete
  final List<String> _popularTags = [
    'AI Art',
    'ChatGPT',
    'Midjourney',
    'DALL-E',
    'Stable Diffusion',
    'Creative Writing',
    'Business',
    'Marketing',
    'Social Media',
    'Productivity',
    'Education',
    'Programming',
    'Design',
    'Photography',
    'Content Creation',
    'SEO',
    'Email Marketing',
    'Copywriting',
    'Storytelling',
    'Character Design',
    'Logo Design',
    'Web Development',
    'Data Analysis',
    'Research',
    'Academic',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _tagController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _tagController.removeListener(_onTextChanged);
    _focusNode.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _tagController.text.isNotEmpty;
    });
  }

  void _onTextChanged() {
    final query = _tagController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _filteredSuggestions = _popularTags
          .where((tag) =>
              tag.toLowerCase().contains(query) &&
              !widget.selectedTags.contains(tag))
          .take(5)
          .toList();
      _showSuggestions = _focusNode.hasFocus && _filteredSuggestions.isNotEmpty;
    });
  }

  void _addTag(String tag) {
    if (tag.trim().isEmpty || widget.selectedTags.contains(tag.trim())) {
      return;
    }

    final updatedTags = List<String>.from(widget.selectedTags)..add(tag.trim());
    widget.onTagsChanged(updatedTags);
    _tagController.clear();
    setState(() {
      _filteredSuggestions = [];
      _showSuggestions = false;
    });
  }

  void _removeTag(String tag) {
    final updatedTags = List<String>.from(widget.selectedTags)..remove(tag);
    widget.onTagsChanged(updatedTags);
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      _addTag(value.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Add relevant tags to help users discover your prompt',
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 2.h),

        // Tag input field
        Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppTheme.accentColor
                  : AppTheme.borderColor,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _tagController,
            focusNode: _focusNode,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Type a tag and press Enter',
              hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textTertiary,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              suffixIcon: _tagController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () => _addTag(_tagController.text),
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.accentColor,
                        size: 24,
                      ),
                    )
                  : null,
            ),
            onSubmitted: _onSubmitted,
            textInputAction: TextInputAction.done,
          ),
        ),

        // Suggestions dropdown
        if (_showSuggestions) ...[
          SizedBox(height: 1.h),
          Container(
            constraints: BoxConstraints(maxHeight: 20.h),
            decoration: BoxDecoration(
              color: AppTheme.secondaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    suggestion,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  leading: CustomIconWidget(
                    iconName: 'local_offer',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  onTap: () => _addTag(suggestion),
                );
              },
            ),
          ),
        ],

        // Selected tags
        if (widget.selectedTags.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children:
                widget.selectedTags.map((tag) => _buildTagChip(tag)).toList(),
          ),
        ],

        // Popular tags section
        if (widget.selectedTags.isEmpty && !_focusNode.hasFocus) ...[
          SizedBox(height: 2.h),
          Text(
            'Popular Tags',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _popularTags
                .take(8)
                .map((tag) => _buildSuggestionChip(tag))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: () => _removeTag(tag),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.accentColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String tag) {
    return GestureDetector(
      onTap: () => _addTag(tag),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Text(
          tag,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
