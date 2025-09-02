import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/edit_profile_modal_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_tabs_widget.dart';
import './widgets/prompt_grid_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _isOwnProfile =
      true; // This would be determined by navigation parameters
  bool _isFollowing = false;
  bool _isLoading = false;

  // Mock user profile data
  Map<String, dynamic> _userProfile = {
    "id": 1,
    "username": "Alex Rodriguez",
    "profileImage":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
    "bio":
        "AI enthusiast & prompt creator. Helping others unlock the power of artificial intelligence through creative prompts.",
    "joinDate": "March 2024",
    "totalPrompts": 42,
    "totalUsage": 1250,
    "currentRank": 7,
    "followers": 234,
    "following": 89,
  };

  // Mock prompts data
  final List<Map<String, dynamic>> _myPrompts = [
    {
      "id": 1,
      "title": "Creative Writing Assistant",
      "description":
          "Generate engaging stories with unique characters and compelling plots for any genre or theme.",
      "imageUrl":
          "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400&h=300&fit=crop",
      "usageCount": 245,
      "likes": 89,
      "createdAt": "2024-08-20",
      "tags": ["writing", "creative", "storytelling"],
    },
    {
      "id": 2,
      "title": "Business Strategy Planner",
      "description":
          "Develop comprehensive business strategies with market analysis and competitive insights.",
      "imageUrl":
          "https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400&h=300&fit=crop",
      "usageCount": 178,
      "likes": 67,
      "createdAt": "2024-08-18",
      "tags": ["business", "strategy", "planning"],
    },
    {
      "id": 3,
      "title": "Social Media Content Creator",
      "description":
          "Create viral social media posts with trending hashtags and engaging captions.",
      "imageUrl":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=300&fit=crop",
      "usageCount": 312,
      "likes": 124,
      "createdAt": "2024-08-15",
      "tags": ["social media", "content", "marketing"],
    },
    {
      "id": 4,
      "title": "Code Review Assistant",
      "description":
          "Analyze code quality, suggest improvements, and identify potential bugs or security issues.",
      "imageUrl":
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=300&fit=crop",
      "usageCount": 156,
      "likes": 78,
      "createdAt": "2024-08-12",
      "tags": ["programming", "code review", "development"],
    },
    {
      "id": 5,
      "title": "Recipe Generator",
      "description":
          "Create delicious recipes based on available ingredients and dietary preferences.",
      "imageUrl":
          "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop",
      "usageCount": 203,
      "likes": 95,
      "createdAt": "2024-08-10",
      "tags": ["cooking", "recipes", "food"],
    },
    {
      "id": 6,
      "title": "Email Marketing Optimizer",
      "description":
          "Craft compelling email campaigns with high open rates and conversion optimization.",
      "imageUrl":
          "https://images.unsplash.com/photo-1596526131083-e8c633c948d2?w=400&h=300&fit=crop",
      "usageCount": 134,
      "likes": 56,
      "createdAt": "2024-08-08",
      "tags": ["email", "marketing", "conversion"],
    },
  ];

  final List<Map<String, dynamic>> _savedPrompts = [
    {
      "id": 7,
      "title": "Travel Itinerary Planner",
      "description":
          "Plan perfect trips with detailed itineraries, local recommendations, and budget estimates.",
      "imageUrl":
          "https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop",
      "usageCount": 445,
      "likes": 189,
      "createdAt": "2024-08-22",
      "tags": ["travel", "planning", "itinerary"],
      "author": "Sarah Chen",
    },
    {
      "id": 8,
      "title": "Fitness Workout Designer",
      "description":
          "Create personalized workout routines based on fitness goals and available equipment.",
      "imageUrl":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop",
      "usageCount": 298,
      "likes": 142,
      "createdAt": "2024-08-19",
      "tags": ["fitness", "workout", "health"],
      "author": "Mike Johnson",
    },
    {
      "id": 9,
      "title": "Language Learning Tutor",
      "description":
          "Practice conversations and learn grammar with interactive language learning exercises.",
      "imageUrl":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400&h=300&fit=crop",
      "usageCount": 367,
      "likes": 156,
      "createdAt": "2024-08-16",
      "tags": ["language", "learning", "education"],
      "author": "Emma Wilson",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildLoadingState()
          : Column(
              children: [
                ProfileHeaderWidget(
                  userProfile: _userProfile,
                  isOwnProfile: _isOwnProfile,
                  onEditProfile: _showEditProfileModal,
                  onFollowToggle: _toggleFollow,
                ),
                SizedBox(height: 2.h),
                ProfileTabsWidget(
                  onTabChanged: _onTabChanged,
                  initialIndex: _currentTabIndex,
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: _buildTabContent(),
                ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryDark,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      title: Text(
        _isOwnProfile
            ? "My Profile"
            : _userProfile["username"] as String? ?? "Profile",
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      actions: [
        if (_isOwnProfile)
          IconButton(
            onPressed: _navigateToSettings,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        IconButton(
          onPressed: _shareProfile,
          icon: CustomIconWidget(
            iconName: 'share',
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
          ),
          SizedBox(height: 2.h),
          Text(
            "Loading profile...",
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final prompts = _currentTabIndex == 0 ? _myPrompts : _savedPrompts;

    return PromptGridWidget(
      prompts: prompts,
      isOwnProfile: _isOwnProfile && _currentTabIndex == 0,
      onPromptTap: _onPromptTap,
      onEditPrompt: _onEditPrompt,
      onDeletePrompt: _onDeletePrompt,
      onSharePrompt: _onSharePrompt,
      onRefresh: _refreshPrompts,
    );
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileModalWidget(
        userProfile: _userProfile,
        onSave: _updateProfile,
      ),
    );
  }

  void _updateProfile(Map<String, dynamic> updatedProfile) {
    setState(() {
      _userProfile = updatedProfile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile updated successfully!"),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _userProfile["followers"] = (_userProfile["followers"] as int) + 1;
      } else {
        _userProfile["followers"] = (_userProfile["followers"] as int) - 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing ? "Following user!" : "Unfollowed user"),
        backgroundColor:
            _isFollowing ? AppTheme.successColor : AppTheme.textSecondary,
      ),
    );
  }

  void _onPromptTap(Map<String, dynamic> prompt) {
    // Navigate to prompt detail or copy prompt
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Prompt copied to clipboard!"),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _onEditPrompt(Map<String, dynamic> prompt) {
    Navigator.pushNamed(context, '/prompt-creation-screen');
  }

  void _onDeletePrompt(Map<String, dynamic> prompt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: Text(
          "Delete Prompt",
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this prompt? This action cannot be undone.",
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _myPrompts.removeWhere((p) => p["id"] == prompt["id"]);
                _userProfile["totalPrompts"] =
                    (_userProfile["totalPrompts"] as int) - 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Prompt deleted successfully"),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            child: Text(
              "Delete",
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _onSharePrompt(Map<String, dynamic> prompt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Prompt shared successfully!"),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _refreshPrompts() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile refreshed!"),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _navigateToSettings() {
    // Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Settings feature coming soon!"),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile link copied to clipboard!"),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
