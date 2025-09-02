import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/prompt_card_widget.dart';
import './widgets/search_bar_widget.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({Key? key}) : super(key: key);

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicatorKey = RefreshIndicator(
    onRefresh: () async {},
    child: Container(),
  );

  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingAnimation;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isOffline = false;
  String _searchQuery = '';
  int _currentBottomNavIndex = 0;

  Map<String, dynamic> _currentFilters = {
    'category': 'All',
    'sortBy': 'Latest',
    'showFavorites': false,
  };

  List<Map<String, dynamic>> _allPrompts = [];
  List<Map<String, dynamic>> _filteredPrompts = [];

  // Mock data for prompts
  final List<Map<String, dynamic>> _mockPrompts = [
    {
      "id": 1,
      "title": "Creative Writing Assistant",
      "description":
          "A comprehensive prompt designed to help writers overcome creative blocks and generate engaging story ideas. This prompt guides you through character development, plot structure, and world-building techniques that professional authors use to craft compelling narratives.",
      "imageUrl":
          "https://images.unsplash.com/photo-1455390582262-044cdead277a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "creatorName": "Sarah Mitchell",
      "usageCount": 1247,
      "promptText":
          "You are a creative writing assistant. Help me develop a compelling story by asking thought-provoking questions about characters, setting, and plot. Guide me through the creative process step by step.",
      "tags": ["writing", "creativity", "storytelling", "fiction"],
      "category": "Writing",
      "createdAt": DateTime.now().subtract(Duration(hours: 2)),
      "isFavorite": false,
    },
    {
      "id": 2,
      "title": "Marketing Campaign Generator",
      "description":
          "Transform your marketing strategy with this powerful prompt that creates data-driven campaigns. Perfect for businesses looking to increase engagement, boost conversions, and build brand awareness across multiple digital platforms and social media channels.",
      "imageUrl":
          "https://images.pexels.com/photos/590022/pexels-photo-590022.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "creatorName": "Marcus Johnson",
      "usageCount": 892,
      "promptText":
          "Create a comprehensive marketing campaign for [product/service]. Include target audience analysis, key messaging, channel strategy, and measurable KPIs. Focus on digital-first approach with social media integration.",
      "tags": ["marketing", "business", "strategy", "social-media"],
      "category": "Marketing",
      "createdAt": DateTime.now().subtract(Duration(hours: 5)),
      "isFavorite": true,
    },
    {
      "id": 3,
      "title": "Code Review Expert",
      "description":
          "Elevate your programming skills with this detailed code review prompt. Designed for developers who want to write cleaner, more efficient code while following industry best practices and maintaining high security standards.",
      "imageUrl":
          "https://images.pixabay.com/photo/2016/11/30/20/58/programming-1873854_1280.png",
      "creatorName": "Alex Chen",
      "usageCount": 2156,
      "promptText":
          "Review this code for best practices, security vulnerabilities, performance optimizations, and maintainability. Provide specific suggestions for improvement with explanations and alternative approaches.",
      "tags": ["programming", "code-review", "development", "best-practices"],
      "category": "Development",
      "createdAt": DateTime.now().subtract(Duration(hours: 8)),
      "isFavorite": false,
    },
    {
      "id": 4,
      "title": "UI/UX Design Consultant",
      "description":
          "Create stunning user interfaces with this comprehensive design prompt. Perfect for designers and developers who want to build intuitive, accessible, and visually appealing digital experiences that users love.",
      "imageUrl":
          "https://images.pexels.com/photos/196644/pexels-photo-196644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "creatorName": "Emma Rodriguez",
      "usageCount": 743,
      "promptText":
          "Analyze this design and provide recommendations for improving user experience, accessibility, visual hierarchy, and conversion optimization. Consider mobile-first approach and modern design trends.",
      "tags": ["design", "ui-ux", "user-experience", "accessibility"],
      "category": "Design",
      "createdAt": DateTime.now().subtract(Duration(hours: 12)),
      "isFavorite": false,
    },
    {
      "id": 5,
      "title": "Business Strategy Advisor",
      "description":
          "Develop winning business strategies with this expert-level prompt. Ideal for entrepreneurs, executives, and consultants who need to make data-driven decisions, identify market opportunities, and create sustainable competitive advantages.",
      "imageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "creatorName": "David Park",
      "usageCount": 1089,
      "promptText":
          "Analyze the business situation and provide strategic recommendations including market analysis, competitive positioning, growth opportunities, risk assessment, and implementation roadmap.",
      "tags": ["business", "strategy", "consulting", "analysis"],
      "category": "Business",
      "createdAt": DateTime.now().subtract(Duration(hours: 18)),
      "isFavorite": true,
    },
    {
      "id": 6,
      "title": "Educational Content Creator",
      "description":
          "Transform complex topics into engaging educational content. This prompt helps educators, trainers, and content creators develop comprehensive learning materials that improve student engagement and knowledge retention.",
      "imageUrl":
          "https://images.pixabay.com/photo/2015/07/17/22/43/student-849825_1280.jpg",
      "creatorName": "Lisa Thompson",
      "usageCount": 567,
      "promptText":
          "Create educational content for [topic] that includes learning objectives, interactive elements, assessment methods, and practical applications. Make it engaging and suitable for [target audience].",
      "tags": ["education", "teaching", "learning", "content-creation"],
      "category": "Education",
      "createdAt": DateTime.now().subtract(Duration(days: 1)),
      "isFavorite": false,
    },
    {
      "id": 7,
      "title": "Social Media Content Planner",
      "description":
          "Boost your social media presence with this comprehensive content planning prompt. Perfect for influencers, brands, and marketers who want to create consistent, engaging content that drives audience growth and engagement.",
      "imageUrl":
          "https://images.pexels.com/photos/267350/pexels-photo-267350.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "creatorName": "Jordan Kim",
      "usageCount": 1834,
      "promptText":
          "Create a 30-day social media content calendar for [platform/brand]. Include post types, captions, hashtag strategies, optimal posting times, and engagement tactics for maximum reach.",
      "tags": ["social-media", "content-planning", "marketing", "engagement"],
      "category": "Marketing",
      "createdAt": DateTime.now().subtract(Duration(days: 2)),
      "isFavorite": false,
    },
    {
      "id": 8,
      "title": "Creative Problem Solver",
      "description":
          "Unlock innovative solutions with this creative problem-solving prompt. Designed for teams and individuals who need to think outside the box and find breakthrough solutions to complex challenges.",
      "imageUrl":
          "https://images.unsplash.com/photo-1553877522-43269d4ea984?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "creatorName": "Ryan Foster",
      "usageCount": 923,
      "promptText":
          "Analyze this problem from multiple perspectives and generate creative solutions using design thinking methodology. Include brainstorming techniques, feasibility analysis, and implementation strategies.",
      "tags": [
        "problem-solving",
        "creativity",
        "innovation",
        "design-thinking"
      ],
      "category": "Business",
      "createdAt": DateTime.now().subtract(Duration(days: 3)),
      "isFavorite": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
    _setupScrollListener();
    _checkConnectivity();
  }

  void _initializeAnimations() {
    _loadingAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeData() {
    setState(() {
      _allPrompts = List.from(_mockPrompts);
      _filteredPrompts = List.from(_allPrompts);
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMorePrompts();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult.contains(ConnectivityResult.none);
    });
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _isLoading = true;
    });

    _loadingAnimationController.repeat();

    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 1500));

    // Refresh data
    _initializeData();
    _applyFilters();

    setState(() {
      _isLoading = false;
    });

    _loadingAnimationController.stop();
    _loadingAnimationController.reset();

    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Feed refreshed!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: AppTheme.primaryDark,
    );
  }

  Future<void> _loadMorePrompts() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    await Future.delayed(Duration(milliseconds: 1000));

    // For demo purposes, we'll just duplicate some existing prompts
    final List<Map<String, dynamic>> newPrompts =
        _mockPrompts.take(3).map((prompt) {
      return Map<String, dynamic>.from(prompt)
        ..['id'] = _allPrompts.length + 1
        ..['createdAt'] =
            DateTime.now().subtract(Duration(days: _allPrompts.length));
    }).toList();

    setState(() {
      _allPrompts.addAll(newPrompts);
      _isLoadingMore = false;
      // Simulate end of data after a few loads
      if (_allPrompts.length > 20) {
        _hasMoreData = false;
      }
    });

    _applyFilters();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allPrompts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((prompt) {
        final title = (prompt['title'] as String).toLowerCase();
        final description = (prompt['description'] as String).toLowerCase();
        final tags = (prompt['tags'] as List).join(' ').toLowerCase();
        final creator = (prompt['creatorName'] as String).toLowerCase();

        return title.contains(_searchQuery) ||
            description.contains(_searchQuery) ||
            tags.contains(_searchQuery) ||
            creator.contains(_searchQuery);
      }).toList();
    }

    // Apply category filter
    if (_currentFilters['category'] != 'All') {
      filtered = filtered
          .where((prompt) => prompt['category'] == _currentFilters['category'])
          .toList();
    }

    // Apply favorites filter
    if (_currentFilters['showFavorites'] == true) {
      filtered =
          filtered.where((prompt) => prompt['isFavorite'] == true).toList();
    }

    // Apply sorting
    switch (_currentFilters['sortBy']) {
      case 'Most Popular':
        filtered.sort((a, b) =>
            (b['usageCount'] as int).compareTo(a['usageCount'] as int));
        break;
      case 'Most Used':
        filtered.sort((a, b) =>
            (b['usageCount'] as int).compareTo(a['usageCount'] as int));
        break;
      case 'Trending':
        // Simple trending algorithm based on recent usage
        filtered.sort((a, b) {
          final aScore = (a['usageCount'] as int) /
              DateTime.now()
                  .difference(a['createdAt'] as DateTime)
                  .inHours
                  .clamp(1, 1000);
          final bScore = (b['usageCount'] as int) /
              DateTime.now()
                  .difference(b['createdAt'] as DateTime)
                  .inHours
                  .clamp(1, 1000);
          return bScore.compareTo(aScore);
        });
        break;
      case 'Latest':
      default:
        filtered.sort((a, b) =>
            (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));
        break;
    }

    setState(() {
      _filteredPrompts = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    HapticFeedback.selectionClick();

    switch (index) {
      case 0:
        // Already on feed screen
        break;
      case 1:
        Navigator.pushNamed(context, '/prompt-creation-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/monthly-leaderboard-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile-screen');
        break;
    }
  }

  void _sharePrompt(Map<String, dynamic> prompt) {
    // Simulate sharing functionality
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Sharing prompt...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accentColor,
      textColor: AppTheme.primaryDark,
    );
  }

  void _savePrompt(Map<String, dynamic> prompt) {
    setState(() {
      prompt['isFavorite'] = !(prompt['isFavorite'] as bool? ?? false);
    });

    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: prompt['isFavorite']
          ? "Prompt saved!"
          : "Prompt removed from favorites",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor:
          prompt['isFavorite'] ? AppTheme.successColor : AppTheme.warningColor,
      textColor: AppTheme.primaryDark,
    );
  }

  void _reportPrompt(Map<String, dynamic> prompt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: Text(
          'Report Prompt',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to report this prompt? Our team will review it for violations of community guidelines.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg:
                    "Prompt reported. Thank you for keeping our community safe!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppTheme.errorColor,
                textColor: AppTheme.textPrimary,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text(
              'Report',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _viewCreatorProfile(Map<String, dynamic> prompt) {
    Navigator.pushNamed(context, '/user-profile-screen');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header with search bar
            Container(
              color: AppTheme.primaryDark,
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      children: [
                        Text(
                          'Prompt Earn',
                          style: AppTheme.darkTheme.textTheme.headlineSmall
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        if (_isOffline)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.warningColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.warningColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'wifi_off',
                                  color: AppTheme.warningColor,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Offline',
                                  style: AppTheme.darkTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.warningColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Search bar
                  SearchBarWidget(
                    onSearchChanged: _onSearchChanged,
                    onFilterTap: _showFilterBottomSheet,
                    hintText: 'Search prompts, creators, tags...',
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: _filteredPrompts.isEmpty && _searchQuery.isNotEmpty
                  ? _buildEmptySearchState()
                  : _filteredPrompts.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _refreshFeed,
                          color: AppTheme.accentColor,
                          backgroundColor: AppTheme.secondaryDark,
                          child: CustomScrollView(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            slivers: [
                              // Loading indicator
                              if (_isLoading)
                                SliverToBoxAdapter(
                                  child: Container(
                                    height: 6.h,
                                    child: Center(
                                      child: AnimatedBuilder(
                                        animation: _loadingAnimation,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: _loadingAnimation.value *
                                                2 *
                                                3.14159,
                                            child: CustomIconWidget(
                                              iconName: 'refresh',
                                              color: AppTheme.accentColor,
                                              size: 24,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                              // Prompt cards
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index >= _filteredPrompts.length) {
                                      return null;
                                    }

                                    final prompt = _filteredPrompts[index];
                                    return PromptCardWidget(
                                      promptData: prompt,
                                      onShare: () => _sharePrompt(prompt),
                                      onSave: () => _savePrompt(prompt),
                                      onReport: () => _reportPrompt(prompt),
                                      onViewProfile: () =>
                                          _viewCreatorProfile(prompt),
                                    );
                                  },
                                  childCount: _filteredPrompts.length,
                                ),
                              ),

                              // Load more indicator
                              if (_isLoadingMore)
                                SliverToBoxAdapter(
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppTheme.accentColor,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),

                              // End of data indicator
                              if (!_hasMoreData && _filteredPrompts.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    child: Center(
                                      child: Text(
                                        'You\'ve reached the end!',
                                        style: AppTheme
                                            .darkTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.textTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // Bottom padding for navigation
                              SliverToBoxAdapter(
                                child: SizedBox(height: 2.h),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.textTertiary,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No prompts found',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search terms or filters to find what you\'re looking for.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _currentFilters = {
                    'category': 'All',
                    'sortBy': 'Latest',
                    'showFavorites': false,
                  };
                });
                _applyFilters();
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'lightbulb_outline',
              color: AppTheme.accentColor,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No prompts yet',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Be the first to share an amazing AI prompt with the community!',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/prompt-creation-screen'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryDark,
                size: 20,
              ),
              label: Text(
                'Create First Prompt',
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
