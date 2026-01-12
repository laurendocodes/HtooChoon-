import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // WEBDESKTOP VIEW (Split Screen)
            return Row(
              children: [
                const Expanded(flex: 5, child: LeftSideForm()),
                Expanded(flex: 5, child: RightSideVisual()),
              ],
            );
          } else {
            // MOBILE VIEW (Single Column)
            return const Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: LeftSideForm(isMobile: true),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// LEFT SIDE: The Login Form

class LeftSideForm extends StatefulWidget {
  final bool isMobile;
  const LeftSideForm({super.key, this.isMobile = false});

  @override
  State<LeftSideForm> createState() => _LeftSideFormState();
}

class _LeftSideFormState extends State<LeftSideForm> {
  bool isLogin = true; // toggle state
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 10 : 80.0,
        vertical: 40,
      ),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isMobile) ...[const LogoWidget(), const Spacer()],
          if (widget.isMobile) const Center(child: LogoWidget()),
          if (widget.isMobile) const SizedBox(height: 40),

          const Center(
            child: Text(
              "Student Portal",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 40),

          LoginToggleSwitch(
            isLogin: isLogin,
            onChanged: (value) {
              setState(() => isLogin = value);
            },
          ),

          const SizedBox(height: 30),

          const CustomTextField(
            label: "Student ID / Email",
            icon: Icons.alternate_email_rounded,
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: "Password",
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: obscurePassword,
            onToggleVisibility: () {
              setState(() => obscurePassword = !obscurePassword);
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                isLogin ? "Login" : "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        // School / Book Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4D7CFE).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 28,
            color: Color(0xFF4D7CFE),
          ),
        ),
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

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword ? obscureText : false,
        decoration: InputDecoration(
          icon: Icon(icon),
          labelText: label,
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
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
