import 'package:flutter/material.dart';
import '../presentation/monthly_leaderboard_screen/monthly_leaderboard_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/prompt_creation_screen/prompt_creation_screen.dart';
import '../presentation/main_feed_screen/main_feed_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String monthlyLeaderboard = '/monthly-leaderboard-screen';
  static const String userProfile = '/user-profile-screen';
  static const String login = '/login-screen';
  static const String promptCreation = '/prompt-creation-screen';
  static const String mainFeed = '/main-feed-screen';
  static const String registration = '/registration-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    monthlyLeaderboard: (context) => const MonthlyLeaderboardScreen(),
    userProfile: (context) => const UserProfileScreen(),
    login: (context) => const LoginScreen(),
    promptCreation: (context) => const PromptCreationScreen(),
    mainFeed: (context) => const MainFeedScreen(),
    registration: (context) => const RegistrationScreen(),
    // TODO: Add your other routes here
  };
}
