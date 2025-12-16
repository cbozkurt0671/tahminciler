import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../home/presentation/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // Background Effects
          _buildBackgroundEffects(),
          
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
                  
                  // Header (Logo & Title)
                  _buildHeader(),
                  
                  const SizedBox(height: 16),
                  
                  // Feature Grid (2x2)
                  _buildFeatureGrid(),
                  
                  const SizedBox(height: 16),
                  
                  // Toggle Switch (Login / Register)
                  _buildToggleSwitch(),
                  
                  const SizedBox(height: 12),
                  
                  // Form Fields
                  _buildFormFields(),
                  
                  const SizedBox(height: 12),
                  
                  // Main Action Button
                  _buildMainButton(),
                  
                  const SizedBox(height: 12),
                  
                  // Divider
                  _buildDivider(),
                  
                  const SizedBox(height: 12),
                  
                  // Social Media Buttons
                  _buildSocialButtons(),
                  
                  const SizedBox(height: 12),
                  
                  // Guest Button
                  _buildGuestButton(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Background Effects (Gradient + Glow)
  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        // Top Gradient (Neon Green)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0df259).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        // Top Right Glow Effect
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0df259).withOpacity(0.15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Header Section
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF0df259),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.sports_soccer,
            size: 32,
            color: Color(0xFF000000),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title
        Text(
          'Futbol Tutkunu Musun?',
          style: GoogleFonts.lexend(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        Text(
          'Arkadaşlarınla yarış, tahmin yap, kazan!',
          style: GoogleFonts.lexend(
            fontSize: 12,
            color: Colors.grey[400],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Feature Grid (2x2)
  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: [
        _buildFeatureCard(
          icon: Icons.people_outline,
          title: 'Arkadaşlarını Davet Et',
          description: 'Ligler oluştur',
        ),
        _buildFeatureCard(
          icon: Icons.emoji_events_outlined,
          title: 'Yarışmalara Katıl',
          description: 'Ödüller kazan',
        ),
        _buildFeatureCard(
          icon: Icons.star_border,
          title: 'Puan Topla',
          description: 'Seviyen yüksel',
        ),
        _buildFeatureCard(
          icon: Icons.leaderboard_outlined,
          title: 'Liderlik Sıralaması',
          description: 'En iyiler arasına gir',
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xFF0df259),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.lexend(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.lexend(
              fontSize: 10,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Toggle Switch (Login / Register)
  Widget _buildToggleSwitch() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              label: 'Giriş Yap',
              isSelected: isLogin,
              onTap: () => setState(() => isLogin = true),
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              label: 'Kayıt Ol',
              isSelected: !isLogin,
              onTap: () => setState(() => isLogin = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0df259) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF000000) : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  // Form Fields
  Widget _buildFormFields() {
    return Column(
      children: [
        // Name Field (Only for Register)
        if (!isLogin) ...[
          _buildTextField(
            controller: _nameController,
            hintText: 'Ad Soyad',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
        ],
        
        // Email Field
        _buildTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        
        const SizedBox(height: 12),
        
        // Password Field
        _buildTextField(
          controller: _passwordController,
          hintText: 'Şifre',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey[500],
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        
        // Forgot Password (Only for Login)
        if (isLogin) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Forgot password logic
              },
              child: Text(
                'Şifremi Unuttum?',
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  color: const Color(0xFF0df259),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.lexend(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.lexend(
            color: Colors.grey[600],
            fontSize: 15,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey[500],
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  // Main Action Button
  Widget _buildMainButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Login/Register logic
        if (isLogin) {
          print('Login: ${_emailController.text}');
        } else {
          print('Register: ${_nameController.text}, ${_emailController.text}');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF0df259),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0df259).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? 'Giriş Yap' : 'Kayıt Ol',
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF000000),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[800],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'veya',
            style: GoogleFonts.lexend(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // Social Media Buttons
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          onTap: () {
            // TODO: Google login
            print('Google login');
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.apple,
          onTap: () {
            // TODO: Apple login
            print('Apple login');
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.close, // X (Twitter) icon
          onTap: () {
            // TODO: Twitter login
            print('X login');
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  // Guest Button
  Widget _buildGuestButton() {
    return TextButton.icon(
      onPressed: () {
        // Giriş yapmadan direkt ana sayfaya atar (Back stack'i temizleyerek)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      icon: const Icon(
        Icons.sports_soccer_outlined,
        color: Color(0xFF0df259),
        size: 20,
      ),
      label: Text(
        'Üye Olmadan Canlı Skorları Gör',
        style: GoogleFonts.lexend(
          fontSize: 14,
          color: const Color(0xFF0df259),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
