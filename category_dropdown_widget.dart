import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryDropdownWidget extends StatefulWidget {
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;

  const CategoryDropdownWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  State<CategoryDropdownWidget> createState() => _CategoryDropdownWidgetState();
}

class _CategoryDropdownWidgetState extends State<CategoryDropdownWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCategories = [];
  bool _isDropdownOpen = false;

  // Mock categories with icons and descriptions
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'AI Art & Design',
      'icon': 'palette',
      'description': 'Creative prompts for image generation',
    },
    {
      'name': 'Content Writing',
      'icon': 'edit',
      'description': 'Blog posts, articles, and copywriting',
    },
    {
      'name': 'Business & Marketing',
      'icon': 'business',
      'description': 'Marketing strategies and business plans',
    },
    {
      'name': 'Programming & Tech',
      'icon': 'code',
      'description': 'Code generation and technical solutions',
    },
    {
      'name': 'Education & Learning',
      'icon': 'school',
      'description': 'Educational content and tutorials',
    },
    {
      'name': 'Social Media',
      'icon': 'share',
      'description': 'Posts, captions, and social content',
    },
    {
      'name': 'Email Marketing',
      'icon': 'email',
      'description': 'Email campaigns and newsletters',
    },
    {
      'name': 'Creative Writing',
      'icon': 'create',
      'description': 'Stories, poems, and creative content',
    },
    {
      'name': 'Data Analysis',
      'icon': 'analytics',
      'description': 'Data insights and analysis prompts',
    },
    {
      'name': 'Research & Academic',
      'icon': 'search',
      'description': 'Research papers and academic content',
    },
    {
      'name': 'Customer Service',
      'icon': 'support_agent',
      'description': 'Customer support and service prompts',
    },
    {
      'name': 'Personal Development',
      'icon': 'psychology',
      'description': 'Self-improvement and coaching',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(_categories);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _categories
          .where((category) =>
              (category['name'] as String).toLowerCase().contains(query) ||
              (category['description'] as String).toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _selectCategory(String categoryName) {
    widget.onCategoryChanged(categoryName);
    setState(() {
      _isDropdownOpen = false;
    });
    _searchController.clear();
  }

  void _clearSelection() {
    widget.onCategoryChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose the most relevant category for your prompt',
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 2.h),

        // Dropdown trigger
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.secondaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isDropdownOpen
                    ? AppTheme.accentColor
                    : AppTheme.borderColor,
                width: _isDropdownOpen ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.selectedCategory != null) ...[
                  _getCategoryIcon(widget.selectedCategory!),
                  SizedBox(width: 3.w),
                ],
                Expanded(
                  child: Text(
                    widget.selectedCategory ?? 'Select a category',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: widget.selectedCategory != null
                          ? AppTheme.textPrimary
                          : AppTheme.textTertiary,
                    ),
                  ),
                ),
                if (widget.selectedCategory != null)
                  GestureDetector(
                    onTap: _clearSelection,
                    child: Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                CustomIconWidget(
                  iconName: _isDropdownOpen
                      ? 'keyboard_arrow_up'
                      : 'keyboard_arrow_down',
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),

        // Dropdown content
        if (_isDropdownOpen) ...[
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              children: [
                // Search field
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.borderColor),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
                      hintStyle:
                          AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 1.h),
                    ),
                  ),
                ),

                // Categories list
                Container(
                  constraints: BoxConstraints(maxHeight: 30.h),
                  child: _filteredCategories.isEmpty
                      ? _buildNoResultsWidget()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredCategories.length,
                          itemBuilder: (context, index) {
                            final category = _filteredCategories[index];
                            return _buildCategoryItem(category);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    final isSelected = widget.selectedCategory == category['name'];

    return GestureDetector(
      onTap: () => _selectCategory(category['name'] as String),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppTheme.borderColor.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: category['icon'] as String,
              color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['name'] as String,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.accentColor
                          : AppTheme.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    category['description'] as String,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check',
                color: AppTheme.accentColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.textTertiary,
            size: 32,
          ),
          SizedBox(height: 2.h),
          Text(
            'No categories found',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try a different search term',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String categoryName) {
    final category = _categories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => {'icon': 'category'},
    );

    return CustomIconWidget(
      iconName: category['icon'] as String,
      color: AppTheme.accentColor,
      size: 20,
    );
  }
}
