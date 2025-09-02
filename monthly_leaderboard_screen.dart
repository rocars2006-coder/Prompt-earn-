import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/leaderboard_header_widget.dart';
import './widgets/ranking_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/winner_card_widget.dart';

class MonthlyLeaderboardScreen extends StatefulWidget {
  const MonthlyLeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyLeaderboardScreen> createState() =>
      _MonthlyLeaderboardScreenState();
}

class _MonthlyLeaderboardScreenState extends State<MonthlyLeaderboardScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshAnimation;

  String _currentMonth = 'December 2024';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  int _currentBottomNavIndex = 2; // Leaderboard tab active

  // Mock data for leaderboard
  final List<Map<String, dynamic>> _leaderboardData = [
    {
      "id": 1,
      "username": "PromptMaster_AI",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "promptCount": 247,
      "totalUsage": 15420,
      "trending": true,
      "isWinner": true,
      "reward": "\$500 Amazon Gift Card",
    },
    {
      "id": 2,
      "username": "CreativeGenius",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "promptCount": 198,
      "totalUsage": 12850,
      "trending": true,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 3,
      "username": "AIEnthusiast",
      "avatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "promptCount": 176,
      "totalUsage": 11200,
      "trending": false,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 4,
      "username": "DigitalArtist",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "promptCount": 165,
      "totalUsage": 10890,
      "trending": true,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 5,
      "username": "TechInnovator",
      "avatar":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
      "promptCount": 142,
      "totalUsage": 9650,
      "trending": false,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 6,
      "username": "ContentCreator",
      "avatar":
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face",
      "promptCount": 128,
      "totalUsage": 8420,
      "trending": true,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 7,
      "username": "You",
      "avatar":
          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face",
      "promptCount": 89,
      "totalUsage": 5240,
      "trending": false,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 8,
      "username": "PromptWizard",
      "avatar":
          "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150&h=150&fit=crop&crop=face",
      "promptCount": 76,
      "totalUsage": 4890,
      "trending": false,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 9,
      "username": "AIArtist",
      "avatar":
          "https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=150&h=150&fit=crop&crop=face",
      "promptCount": 65,
      "totalUsage": 3920,
      "trending": true,
      "isWinner": false,
      "reward": "",
    },
    {
      "id": 10,
      "username": "DigitalCreator",
      "avatar":
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face",
      "promptCount": 58,
      "totalUsage": 3450,
      "trending": false,
      "isWinner": false,
      "reward": "",
    },
  ];

  List<Map<String, dynamic>> get _filteredData {
    if (_searchQuery.isEmpty) return _leaderboardData;
    return _leaderboardData
        .where((user) => (user['username'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Map<String, dynamic>? get _winner {
    return _leaderboardData.firstWhere(
      (user) => user['isWinner'] == true,
      orElse: () => _leaderboardData.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle infinite scroll for complete rankings
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreRankings();
    }
  }

  Future<void> _loadMoreRankings() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshLeaderboard() async {
    _refreshAnimationController.forward();

    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _refreshAnimationController.reverse();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
  }

  void _navigateToPreviousMonth() {
    // Handle month navigation
    setState(() {
      _currentMonth = 'November 2024';
    });
  }

  void _navigateToNextMonth() {
    // Handle month navigation
    setState(() {
      _currentMonth = 'January 2025';
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/main-feed-screen');
        break;
      case 1:
        Navigator.pushNamed(context, '/prompt-creation-screen');
        break;
      case 2:
        // Already on leaderboard
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile-screen');
        break;
    }
  }

  void _onUserCardTap(Map<String, dynamic> user) {
    Navigator.pushNamed(context, '/user-profile-screen');
  }

  void _onUserCardLongPress(Map<String, dynamic> user) {
    _showUserActions(user);
  }

  void _showUserActions(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.borderColor,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: user['avatar'] as String,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  user['username'] as String,
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildActionTile('View Profile', 'person', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/user-profile-screen');
            }),
            _buildActionTile('Follow', 'person_add', () {
              Navigator.pop(context);
            }),
            _buildActionTile('View Prompts', 'article', () {
              Navigator.pop(context);
            }),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: AppTheme.textPrimary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        title: Text(
          'Monthly Leaderboard',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          AnimatedBuilder(
            animation: _refreshAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _refreshAnimation.value * 2 * 3.14159,
                child: IconButton(
                  onPressed: _refreshLeaderboard,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLeaderboard,
        color: AppTheme.accentColor,
        backgroundColor: AppTheme.secondaryDark,
        child: _filteredData.isEmpty && _isSearching
            ? EmptyStateWidget(
                title: 'No Users Found',
                description:
                    'Try searching with a different username or clear your search to see all rankings.',
                actionText: 'Clear Search',
                onAction: _clearSearch,
              )
            : CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        LeaderboardHeaderWidget(
                          currentMonth: _currentMonth,
                          onPreviousMonth: _navigateToPreviousMonth,
                          onNextMonth: _navigateToNextMonth,
                          timeUntilReset: '15d 8h 42m',
                        ),
                        if (_winner != null) WinnerCardWidget(winner: _winner!),
                        SearchBarWidget(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          onClear: _clearSearch,
                        ),
                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _filteredData.length) {
                          return _isLoading
                              ? Container(
                                  padding: EdgeInsets.all(4.w),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.accentColor,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }

                        final user = _filteredData[index];
                        final position = _leaderboardData.indexOf(user) + 1;
                        final isCurrentUser = user['username'] == 'You';

                        return RankingCardWidget(
                          user: user,
                          position: position,
                          isCurrentUser: isCurrentUser,
                          onTap: () => _onUserCardTap(user),
                          onLongPress: () => _onUserCardLongPress(user),
                        );
                      },
                      childCount: _filteredData.length + (_isLoading ? 1 : 0),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 10.h),
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
}
