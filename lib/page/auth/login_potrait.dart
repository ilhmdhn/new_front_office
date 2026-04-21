import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController tfUser;
  final TextEditingController tfPassword;

  final bool showPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onFingerprint;

  const LoginForm({
    super.key,
    required this.tfUser,
    required this.tfPassword,
    required this.showPassword,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onFingerprint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _usernameField(),
          const SizedBox(height: 24),
          _passwordField(),
          const SizedBox(height: 32),
          _actionButtons(),
        ],
      ),
    );
  }

  // ========================
  // Username
  // ========================
  Widget _usernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: _shadowBox(),
          child: TextField(
            controller: tfUser,
            autofillHints: const [AutofillHints.username],
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              hint: 'Masukkan username',
              icon: Icons.person_outline,
            ),
          ),
        ),
      ],
    );
  }

  // ========================
  // Password
  // ========================
  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: _shadowBox(),
          child: TextField(
            controller: tfPassword,
            obscureText: !showPassword,
            autofillHints: const [AutofillHints.password],
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              hint: 'Masukkan password',
              icon: Icons.lock_outline,
              suffix: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========================
  // Buttons
  // ========================
  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: onLogin,
              style: CustomButtonStyle.blueAppbar(),
              child: Center(
                  child: Text(
                    'Login',
                    style: CustomTextStyle.whiteSizeMedium(19),
                  ),
                ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: onFingerprint,
          child: SizedBox(
            height: 46,
            child: AspectRatio(
              aspectRatio: 1/1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: CustomColorStyle.appBarBackground()
                ),
                child: Center(
                  child: Icon(Icons.fingerprint_rounded, color: Colors.white, size: 31,)
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========================
  // Reusable styles
  // ========================
  BoxDecoration _shadowBox() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[50],
      prefixIcon: Icon(
        icon,
        color: CustomColorStyle.appBarBackground(),
      ),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: CustomColorStyle.appBarBackground(),
          width: 2,
        ),
      ),
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: Colors.grey[400],
        fontSize: 14,
      ),
    );
  }
}