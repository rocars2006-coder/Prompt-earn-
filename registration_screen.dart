import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/character_counter_widget.dart';
import './widgets/custom_text_field.dart';
import './widgets/password_strength_indicator.dart';
import './widgets/terms_checkbox_widget.dart';
import './widgets/terms_modal_widget.dart';
import 'widgets/character_counter_widget.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/password_strength_indicator.dart';
import 'widgets/terms_checkbox_widget.dart';
import 'widgets/terms_modal_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  bool _isTermsAccepted = false;
  bool _isLoading = false;
  bool _isFormValid = false;

  // Form validation states
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _displayNameError;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    // Add listeners for real-time validation
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
    _displayNameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
        title: Text(
          'Create Account',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Dismiss keyboard
              FocusScope.of(context).unfocus();
            },
            child: Text(
              'Done',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.accentColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),

                  // Welcome text
                  Text(
                    'Join Prompt Earn',
                    style:
                        AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Create your account to start sharing and earning from AI prompts',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Email field
                  CustomTextField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    isEmail: true,
                    validator: _validateEmail,
                    onChanged: (value) => _validateForm(),
                  ),

                  SizedBox(height: 4.h),

                  // Password field
                  CustomTextField(
                    label: 'Password',
                    hint: 'Create a strong password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: _validatePassword,
                    onChanged: (value) => _validateForm(),
                  ),

                  // Password strength indicator
                  PasswordStrengthIndicator(
                    password: _passwordController.text,
                  ),

                  SizedBox(height: 4.h),

                  // Confirm password field
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: _validateConfirmPassword,
                    onChanged: (value) => _validateForm(),
                  ),

                  SizedBox(height: 4.h),

                  // Display name field
                  CustomTextField(
                    label: 'Display Name',
                    hint: 'Choose your display name',
                    controller: _displayNameController,
                    maxLength: 30,
                    validator: _validateDisplayName,
                    onChanged: (value) => _validateForm(),
                  ),

                  // Character counter
                  CharacterCounterWidget(
                    text: _displayNameController.text,
                    maxLength: 30,
                  ),

                  SizedBox(height: 6.h),

                  // Terms checkbox
                  TermsCheckboxWidget(
                    isChecked: _isTermsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _isTermsAccepted = value ?? false;
                      });
                      _validateForm();
                    },
                    onTermsTap: _showTermsModal,
                  ),

                  SizedBox(height: 6.h),

                  // Create account button
                  AnimatedBuilder(
                    animation: _buttonScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonScaleAnimation.value,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isFormValid && !_isLoading
                                ? _handleCreateAccount
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFormValid
                                  ? AppTheme.accentColor
                                  : AppTheme.borderColor,
                              foregroundColor: _isFormValid
                                  ? AppTheme.primaryDark
                                  : AppTheme.textTertiary,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: _isFormValid ? 2 : 0,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.primaryDark,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Create Account',
                                    style: AppTheme
                                        .darkTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      color: _isFormValid
                                          ? AppTheme.primaryDark
                                          : AppTheme.textTertiary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Login link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(text: 'Already have an account? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/login-screen'),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppTheme.accentColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppTheme.accentColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }
    if (value.length < 2) {
      return 'Display name must be at least 2 characters';
    }
    if (value.length > 30) {
      return 'Display name cannot exceed 30 characters';
    }
    return null;
  }

  void _validateForm() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError =
          _validateConfirmPassword(_confirmPasswordController.text);
      _displayNameError = _validateDisplayName(_displayNameController.text);

      _isFormValid = _emailError == null &&
          _passwordError == null &&
          _confirmPasswordError == null &&
          _displayNameError == null &&
          _isTermsAccepted &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _displayNameController.text.isNotEmpty;
    });
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TermsModalWidget(),
    );
  }

  Future<void> _handleCreateAccount() async {
    if (!_isFormValid) return;

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Button animation
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate account creation
      await Future.delayed(Duration(seconds: 2));

      // Check for duplicate email (mock validation)
      if (_emailController.text.toLowerCase() == 'test@example.com') {
        _showErrorSnackBar(
            'This email is already registered. Please use a different email.');
        return;
      }

      // Success feedback
      HapticFeedback.selectionClick();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully! Welcome to Prompt Earn!',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(4.w),
        ),
      );

      // Navigate to main feed after brief delay
      await Future.delayed(Duration(milliseconds: 1500));
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main-feed-screen',
        (route) => false,
      );
    } catch (e) {
      // Network error handling
      _showErrorSnackBar(
          'Network error. Please check your connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
        action: SnackBarAction(
          label: 'Retry',
          textColor: AppTheme.textPrimary,
          onPressed: _handleCreateAccount,
        ),
      ),
    );
  }
}