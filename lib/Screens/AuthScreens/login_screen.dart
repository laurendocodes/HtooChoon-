import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Screens/auth/otp_screen.dart';
import 'package:provider/provider.dart';

import 'package:htoochoon_flutter/Theme/themedata.dart';

// RIGHT SIDE: Education Theme

class RightSideVisual extends StatelessWidget {
  const RightSideVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F4FF), // Very light indigo/blue
            Color(0xFFD9E4FF),
            Color(0xFFAEC6FF), // Soft Blue
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating Education 3D Image Placeholder
            Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  // 3D Education/Rocket/Book illustration
                  image: NetworkImage(
                    'https://cdn3d.iconscout.com/3d/premium/thumb/online-education-4635835-3864077.png',
                  ),
                  fit: BoxFit.contain,
                ),

                // Soft shadow for depth
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4D7CFE).withOpacity(0.2),
                    blurRadius: 60,
                    spreadRadius: 10,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET HELPERS
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logos/main_logo.jpeg', height: 100),
        const SizedBox(width: 12),
        const Text(
          "HtooChoon",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class LoginToggleSwitch extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChanged;

  const LoginToggleSwitch({
    super.key,
    required this.isLogin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _toggleItem("Login", isLogin, () => onChanged(true)),
          _toggleItem("Sign up", !isLogin, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _toggleItem(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String iconUrl;
  final bool isBlack;
  final bool isBlue;

  const SocialButton({
    super.key,
    required this.iconUrl,
    this.isBlack = false,
    this.isBlue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isBlack
            ? Colors.black
            : (isBlue ? const Color(0xFF1877F2) : Colors.white),
        border: isBlack || isBlue
            ? null
            : Border.all(color: Colors.grey.shade300),
        boxShadow: [
          if (!isBlack && !isBlue)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: isBlue || isBlack
          ? Image.network(iconUrl, color: Colors.white)
          : Image.network(iconUrl),
    );
  }
}

class PremiumLoginScreen extends StatelessWidget {
  const PremiumLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // Desktop/Web: Split screen layout
            return Row(
              children: [
                Expanded(flex: 5, child: _AuthFormSection()),
                Expanded(flex: 5, child: _RightSideVisual()),
              ],
            );
          } else {
            // Mobile: Single column
            return Center(child: _AuthFormSection());
          }
        },
      ),
    );
  }
}

/// Auth Form Section - Left side on desktop, full screen on mobile
class _AuthFormSection extends StatefulWidget {
  const _AuthFormSection();

  @override
  State<_AuthFormSection> createState() => _AuthFormSectionState();
}

class _AuthFormSectionState extends State<_AuthFormSection> {
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleSubmit() async {
    // Use mounted-safe context from the State's own context getter
    if (!mounted) return;
    final ctx = context; // capture once before any async gap

    print("[_handleSubmit] tapped");

    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(ctx, listen: false);

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final name = _usernameController.text.trim();

      final action = _isSignUp ? "register" : "login";
      print("[_handleSubmit] action=$action email=$email");

      final success = await authProvider.requestOtp(email, "VERIFY_EMAIL");
      print("[_handleSubmit] requestOtp success=$success");

      if (success && mounted) {
        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              email: email,
              password: password,
              name: name,
              action: action,
            ),
          ),
        );
      } else if (!success && mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Failed to send OTP')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600
              ? AppTheme.space4xl
              : AppTheme.spaceLg,
          vertical: AppTheme.space2xl,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                const _LogoBranding(),

                const SizedBox(height: AppTheme.space3xl),

                // Header
                _AuthHeader(isSignUp: _isSignUp),

                const SizedBox(height: AppTheme.space2xl),

                // Mode Toggle
                _AuthModeToggle(isSignUp: _isSignUp, onToggle: _toggleMode),

                const SizedBox(height: AppTheme.space2xl),

                // Form Fields
                if (_isSignUp) ...[
                  _FormField(
                    controller: _usernameController,
                    label: 'Username',
                    hint: 'Choose a unique username',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                ],

                _FormField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppTheme.spaceLg),

                _FormField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                if (_isSignUp) ...[
                  const SizedBox(height: AppTheme.spaceLg),
                  _FormField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Repeat your password',
                    prefixIcon: Icons.lock_reset_outlined,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: AppTheme.space2xl),
                _SubmitButton(
                  textColorGoogle: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.inversePrimary,
                  isSignUp: _isSignUp,
                  isLoading: authProvider.isLoading,
                  // ✅ Correct: closure with no args — _handleSubmit uses State.context
                  onPressed: _handleSubmit,
                  //TODO add google login
                  onPressedGoogle: authProvider.isLoading ? () {} : () {},
                ),

                const SizedBox(height: AppTheme.spaceLg),

                // Footer Text
                _FooterText(isSignUp: _isSignUp, onToggle: _toggleMode),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo and branding
class _LogoBranding extends StatelessWidget {
  const _LogoBranding();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logos/main_logo.jpeg', height: 150),
        const SizedBox(width: AppTheme.spaceSm),
      ],
    );
  }
}

/// Header with title and subtitle
class _AuthHeader extends StatelessWidget {
  final bool isSignUp;

  const _AuthHeader({required this.isSignUp});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSignUp ? 'Create Account' : 'Welcome Back',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppTheme.spaceXs),
        Text(
          isSignUp
              ? 'Sign up to start your learning journey'
              : 'Login to continue your progress',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.getTextSecondary(context),
          ),
        ),
      ],
    );
  }
}

/// Login/Signup mode toggle
class _AuthModeToggle extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggle;

  const _AuthModeToggle({required this.isSignUp, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space2xs),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceVariant(context),
        borderRadius: AppTheme.borderRadiusLg,
      ),
      child: Row(
        children: [
          _ToggleOption(
            label: 'Login',
            isActive: !isSignUp,
            onTap: isSignUp ? onToggle : null,
          ),
          _ToggleOption(
            label: 'Sign up',
            isActive: isSignUp,
            onTap: !isSignUp ? onToggle : null,
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _ToggleOption({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).cardColor : Colors.transparent,
            borderRadius: AppTheme.borderRadiusMd,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActive
                    ? Theme.of(context).colorScheme.onSurface
                    : AppTheme.getTextSecondary(context),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable form field with consistent styling
class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: 20),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}

/// Submit button with loading state
class _SubmitButton extends StatelessWidget {
  final bool isSignUp;
  final bool isLoading;
  final VoidCallback onPressed;
  final VoidCallback onPressedGoogle;
  final Color? textColor;
  final Color? textColorGoogle;
  const _SubmitButton({
    required this.isSignUp,
    required this.isLoading,
    required this.onPressed,
    required this.onPressedGoogle,
    required this.textColor,
    required this.textColorGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMd),
            ),
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    isSignUp ? 'Create Account' : 'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                      color: textColor,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'or continue with',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            icon: Image.asset('assets/images/logos/google.png', height: 22),
            label: Text(
              isSignUp ? 'Sign up with Google' : 'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColorGoogle,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onPressedGoogle,
          ),
        ),
      ],
    );
  }
}

/// Footer text with mode switch link
class _FooterText extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggle;

  const _FooterText({required this.isSignUp, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isSignUp ? 'Already have an account?' : "Don't have an account?",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const SizedBox(width: AppTheme.spaceXs),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              isSignUp ? 'Login' : 'Sign up',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Right side visual panel (desktop only)
class _RightSideVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1E3A8A).withOpacity(0.3),
                  const Color(0xFF1E40AF).withOpacity(0.2),
                  const Color(0xFF3B82F6).withOpacity(0.1),
                ]
              : [
                  const Color(0xFFF0F4FF),
                  const Color(0xFFD9E4FF),
                  const Color(0xFFAEC6FF),
                ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration container
            Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                borderRadius: AppTheme.borderRadius2xl,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.2),
                    blurRadius: 60,
                    spreadRadius: 10,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: AppTheme.borderRadius2xl,
                child: Image.network(
                  'https://cdn3d.iconscout.com/3d/premium/thumb/online-education-4635835-3864077.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: AppTheme.borderRadius2xl,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 120,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                          ),
                          const SizedBox(height: AppTheme.spaceLg),
                          Text(
                            'Learn & Grow',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppTheme.getTextSecondary(context),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: AppTheme.space3xl),

            // Feature highlights
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space4xl,
              ),
              child: Column(
                children: [
                  _FeatureItem(
                    icon: Icons.workspace_premium,
                    title: 'Premium Education',
                    subtitle: 'Access world-class learning resources',
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  _FeatureItem(
                    icon: Icons.people_outline,
                    title: 'Expert Instructors',
                    subtitle: 'Learn from industry professionals',
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  _FeatureItem(
                    icon: Icons.trending_up,
                    title: 'Track Progress',
                    subtitle: 'Monitor your learning journey',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceSm),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: AppTheme.borderRadiusMd,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: AppTheme.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
