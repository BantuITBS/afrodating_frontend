import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaseme_flutter/models/content_model.dart';
import 'package:teaseme_flutter/services/api_service.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';
import 'package:teaseme_flutter/widgets/media_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:teaseme_flutter/screens/login_screen.dart';
import 'package:teaseme_flutter/screens/register_screen.dart';
import 'package:teaseme_flutter/screens/members_screen.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with SingleTickerProviderStateMixin {
  List<ContentModel> _content = [];
  bool _isLoading = true;
  bool _isAuthenticated = false;
  int _guestViewCount = 0;
  static const int _maxGuestViews = 5;
  late AnimationController _pulseController;
  int _currentCarouselIndex = 0;
  final List<String> _carouselImages = [
    'assets/images/tsm_1.jpeg',
    'assets/images/tsm_2.jpeg',
    'assets/images/tsm_3.jpeg',
    'assets/images/tsm_4.jpeg',
    'assets/images/tsm_5.jpeg',
    'assets/images/tsm_6.jpeg', // Added new image
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fetchContent();
    _checkAuthStatus();
    _loadGuestViewCount();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchContent() async {
    try {
      final data = await ApiService().get('/api/content/?is_free_teaser=true');
      setState(() {
        _content = (data['results'] as List).map((json) => ContentModel.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.pink.withOpacity(0.8),
          content: Text('Failed to load teasers: $e', style: const TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isAuthenticated = prefs.getString('user_token') != null);
  }

  Future<void> _loadGuestViewCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _guestViewCount = prefs.getInt('guest_view_count') ?? 0);
  }

  Future<void> _incrementGuestViewCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _guestViewCount++);
    await prefs.setInt('guest_view_count', _guestViewCount);
  }

  void _showAgeConfirmationDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink.withOpacity(0.9),
                    Colors.purple.withOpacity(0.9),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orangeAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Age Verification Required',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This content is strictly for adults 18 years and older. By proceeding, you confirm you are of legal age.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.pinkAccent, Colors.purpleAccent],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                if (_guestViewCount < _maxGuestViews) {
                                  _incrementGuestViewCount();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MembersScreen(),
                                    ),
                                  );
                                } else {
                                  _showMembershipPrompt();
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'I am 18+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().scaleXY(begin: 0.7, end: 1.0, duration: 400.ms, curve: Curves.easeOutBack).fadeIn(duration: 400.ms);
      },
    );
  }

  void _showMembershipPrompt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.pink.withOpacity(0.9),
                Colors.purple.withOpacity(0.9),
                Colors.black.withOpacity(0.95),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 64,
                      ).animate().scaleXY(begin: 0.8, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack).shake(),
                      const SizedBox(height: 20),
                      const Text(
                        'Ready for More?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Unlock exclusive content, private chats, and intimate experiences...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.pinkAccent, Colors.purpleAccent],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showRegisterModal();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Join the Intimacy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showLoginModal();
                        },
                        child: const Text(
                          'Already a Member? Login',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).animate().scaleXY(begin: 0.8, end: 1.0, duration: 300.ms, curve: Curves.easeOutBack);
      },
    );
  }

  void _showLoginModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.12, // 50% smaller width
            vertical: 60, // 50% smaller height
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink.withOpacity(0.9),
                    Colors.purple.withOpacity(0.9),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
              child: LoginScreen(),
            ),
          ),
        ).animate().scaleXY(begin: 0.7, end: 1.0, duration: 400.ms, curve: Curves.easeOutBack).fadeIn(duration: 400.ms);
      },
    );
  }

  void _showRegisterModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.12, // 50% smaller width
            vertical: 60, // 50% smaller height
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.withOpacity(0.9),
                    Colors.pink.withOpacity(0.9),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
              child: RegisterScreen(showLoginLink: false),
            ),
          ),
        ).animate().scaleXY(begin: 0.7, end: 1.0, duration: 400.ms, curve: Curves.easeOutBack).fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildGlassmorphicCard(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.pink.withOpacity(0.05),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }

  Widget _buildCircularImage(String imagePath, {double size = 160}) { // Doubled from 80 to 160
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(8), // Added margin for better spacing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: Colors.pinkAccent,
          width: 3, // Slightly thicker border for larger images
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade300, Colors.purple.shade300],
                ),
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: Icon(Icons.favorite, color: Colors.white, size: size / 3),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: Colors.pinkAccent, size: 28),
            const SizedBox(width: 8),
            const Text(
              'TeaseMe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.5),
        actions: [
          if (!_isAuthenticated) ...[
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + _pulseController.value * 0.1,
                  child: child,
                );
              },
              child: TextButton(
                onPressed: _showLoginModal,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: _showRegisterModal,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/members'),
              icon: const Icon(Icons.person, color: Colors.white),
              tooltip: 'Members Area',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Colors.purple, Colors.pink],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                      size: 64,
                    ).animate(onPlay: (controller) => controller.repeat()).rotate(),
                    const SizedBox(height: 20),
                    const Text(
                      'Loading your desires...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Colors.purple, Colors.pink],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/sensual_pattern.png'),
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomScrollView(
                    slivers: [
                      // No Under 18 Icon Header
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          color: Colors.black.withOpacity(0.8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(Icons.block, color: Colors.pinkAccent, size: 24),
                                  const Text(
                                    '18+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Adults Only',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 600.ms),
                      ),
                      // Hero Section with Larger Circular Image Inserts
                      SliverToBoxAdapter(
                        child: Container(
                          height: 500, // Increased height to accommodate larger images
                          child: Stack(
                            children: [
                              // Background gradient
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.9),
                                      Colors.purple.withOpacity(0.7),
                                      Colors.pink.withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                              // Semi-transparent overlay for better text visibility
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Circular image inserts - positioned to not block text
                              Positioned(
                                top: 20,
                                left: 0,
                                right: 0,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: _carouselImages.take(3).map((imagePath) {
                                    return _buildCircularImage(imagePath, size: 140)
                                        .animate()
                                        .scaleXY(
                                          begin: 0.8,
                                          end: 1.0,
                                          duration: 600.ms,
                                          curve: Curves.easeOutBack,
                                        )
                                        .fadeIn(duration: 400.ms);
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: _carouselImages.skip(3).map((imagePath) {
                                    return _buildCircularImage(imagePath, size: 140)
                                        .animate()
                                        .scaleXY(
                                          begin: 0.8,
                                          end: 1.0,
                                          duration: 600.ms,
                                          curve: Curves.easeOutBack,
                                        )
                                        .fadeIn(duration: 400.ms);
                                  }).toList(),
                                ),
                              ),
                              // Content overlay - centered with proper z-index
                              Positioned.fill(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Indulge Your\nCuriosities',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 42,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            height: 1.1,
                                            shadows: [
                                              Shadow(blurRadius: 15, color: Colors.pink),
                                              Shadow(blurRadius: 25, color: Colors.purple),
                                              Shadow(blurRadius: 35, color: Colors.black),
                                            ],
                                          ),
                                        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.5, end: 0.0),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Discover sensual content crafted for your pleasure',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                            fontStyle: FontStyle.italic,
                                            shadows: [
                                              Shadow(blurRadius: 10, color: Colors.black),
                                            ],
                                          ),
                                        ).animate().fadeIn(duration: 1000.ms),
                                        const SizedBox(height: 30),
                                        if (!_isAuthenticated)
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Colors.pinkAccent, Colors.purpleAccent],
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.pink.withOpacity(0.5),
                                                  blurRadius: 15,
                                                  spreadRadius: 3,
                                                ),
                                              ],
                                            ),
                                            child: TextButton(
                                              onPressed: _showRegisterModal,
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.favorite, color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Begin Your Journey',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).animate().fadeIn(duration: 1200.ms).scaleXY(
                                                begin: 0.8,
                                                end: 1.0,
                                                duration: 600.ms,
                                                curve: Curves.easeOutBack,
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Guest Counter - Simplified "Free Preview"
                      if (!_isAuthenticated)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                            child: GestureDetector(
                              onTap: _showAgeConfirmationDialog, // Now shows age confirmation first
                              child: _buildGlassmorphicCard(
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.remove_red_eye, color: Colors.pinkAccent, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Free Preview',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn(duration: 600.ms),
                            ),
                          ),
                        ),
                      // Featured Teasers
                      SliverPadding(
                        padding: const EdgeInsets.all(24.0),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final content = _content[index];
                              return GestureDetector(
                                onTap: () async {
                                  if (!_isAuthenticated && _guestViewCount >= _maxGuestViews) {
                                    _showMembershipPrompt();
                                  } else {
                                    await _incrementGuestViewCount();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MediaPlayer(url: content.fileUrl, type: content.type),
                                      ),
                                    );
                                  }
                                },
                                child: _buildGlassmorphicCard(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          child: Stack(
                                            children: [
                                              content.thumbnailUrl.isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl: content.thumbnailUrl,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Container(
                                                        color: Colors.black26,
                                                        child: const Center(
                                                          child: CircularProgressIndicator(color: Colors.pinkAccent),
                                                        ),
                                                      ),
                                                      errorWidget: (context, url, error) => Container(
                                                        color: Colors.black26,
                                                        child: const Icon(Icons.error, color: Colors.white),
                                                      ),
                                                    )
                                                  : Container(color: Colors.black26),
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black.withOpacity(0.7),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (content.type == 'video')
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.pink.withOpacity(0.8),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 32,
                                                    ),
                                                  ).animate().scaleXY(
                                                        begin: 0.8,
                                                        end: 1.0,
                                                        duration: 600.ms,
                                                        curve: Curves.easeOutBack,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              content.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'By ${content.teaserName}',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(
                                      duration: 500.ms,
                                      delay: Duration(milliseconds: index * 100),
                                    ).slideY(begin: 0.3, end: 0.0),
                              );
                            },
                            childCount: _content.length,
                          ),
                        ),
                      ),
                      if (!_isAuthenticated)
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 40),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}