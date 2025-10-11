import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String _username = 'Guest';
  bool _isGuest = true;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Online', 'New', 'Popular', 'Live Soon'];
  
  final List<Teaser> _teasers = [
    Teaser(
      id: '1',
      name: 'Sofia',
      profilePic: 'assets/images/tsm_1.jpeg',
      isOnline: true,
      subscriptionFee: 29.99,
      liveSessionFee: 49.99,
      privateLiveFee: 99.99,
      age: 25,
      height: '5\'6"',
      measurements: '34-24-36',
      ethnicity: 'Latin',
      orientation: 'Bi-curious',
      specialties: 'Dancing • Roleplay',
      lastMessage: 'Ready for fun? 💋',
      communityMembers: 1247,
      nextLiveSession: DateTime.now().add(const Duration(hours: 2)),
      rating: 4.8,
      excitingTagline: '🔥 Wild & Adventurous • Loves to Explore Fantasies',
    ),
    Teaser(
      id: '2',
      name: 'Luna',
      profilePic: 'assets/images/tsm_2.jpeg',
      isOnline: false,
      subscriptionFee: 39.99,
      liveSessionFee: 59.99,
      privateLiveFee: 119.99,
      age: 22,
      height: '5\'4"',
      measurements: '32-22-34',
      ethnicity: 'Asian',
      orientation: 'Straight',
      specialties: 'ASMR • Teasing',
      lastMessage: 'New outfit! 😘',
      communityMembers: 892,
      nextLiveSession: DateTime.now().add(const Duration(days: 1)),
      rating: 4.9,
      excitingTagline: '✨ Sensual ASMR Queen • Ultimate Tease Experience',
    ),
    Teaser(
      id: '3',
      name: 'Bella',
      profilePic: 'assets/images/tsm_3.jpeg',
      isOnline: true,
      subscriptionFee: 24.99,
      liveSessionFee: 44.99,
      privateLiveFee: 89.99,
      age: 28,
      height: '5\'8"',
      measurements: '36-26-38',
      ethnicity: 'European',
      orientation: 'Open',
      specialties: 'Domination • Cosplay',
      lastMessage: 'Exclusive content! 🔥',
      communityMembers: 2156,
      nextLiveSession: DateTime.now().add(const Duration(hours: 6)),
      rating: 4.7,
      excitingTagline: '👑 Dominant Goddess • Fantasy Roleplay Specialist',
    ),
    Teaser(
      id: '4',
      name: 'Chloe',
      profilePic: 'assets/images/tsm_4.jpeg',
      isOnline: true,
      subscriptionFee: 34.99,
      liveSessionFee: 54.99,
      privateLiveFee: 109.99,
      age: 24,
      height: '5\'5"',
      measurements: '33-25-35',
      ethnicity: 'Mixed',
      orientation: 'Lesbian',
      specialties: 'Yoga • Stories',
      lastMessage: 'Live soon! 💕',
      communityMembers: 1678,
      nextLiveSession: DateTime.now().add(const Duration(days: 2)),
      rating: 4.6,
      excitingTagline: '💫 Flexible Yogi • Intimate Storyteller • Wild Dreams',
    ),
    Teaser(
      id: '5',
      name: 'Aria',
      profilePic: 'assets/images/tsm_5.jpeg',
      isOnline: false,
      subscriptionFee: 31.99,
      liveSessionFee: 51.99,
      privateLiveFee: 104.99,
      age: 26,
      height: '5\'7"',
      measurements: '35-25-37',
      ethnicity: 'African',
      orientation: 'Pan',
      specialties: 'Dance • Confidence',
      lastMessage: 'New photos! 👀',
      communityMembers: 743,
      nextLiveSession: DateTime.now().add(const Duration(hours: 12)),
      rating: 4.8,
      excitingTagline: '💃 Confident Dancer • Unleash Your Wild Side',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Guest';
      _isGuest = prefs.getBool('isGuest') ?? true;
    });
  }

  List<Teaser> get _filteredTeasers {
    switch (_selectedFilter) {
      case 'Online':
        return _teasers.where((teaser) => teaser.isOnline).toList();
      case 'New':
        return _teasers.take(2).toList();
      case 'Popular':
        return _teasers.where((teaser) => teaser.rating >= 4.8).toList();
      case 'Live Soon':
        return _teasers.where((teaser) => 
          teaser.nextLiveSession.difference(DateTime.now()).inHours <= 6).toList();
      default:
        return _teasers;
    }
  }

  void _showSignUpModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Icon(Icons.favorite, color: Colors.pinkAccent, size: 40),
            const SizedBox(height: 15),
            Text(
              'Join Our Community!',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create a free account to:\n• Chat with creators\n• Join communities\n• Request live shows\n• Access private sessions',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _completeSignUp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Sign Up Free', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maybe Later', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  void _completeSignUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuest', false);
    await prefs.setString('username', 'Member');
    
    setState(() {
      _isGuest = false;
      _username = 'Member';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Welcome to our community!', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _checkMembership(VoidCallback action, String serviceName) {
    if (_isGuest) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            'Join to $serviceName',
            style: TextStyle(color: Colors.pinkAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Create a free account to start $serviceName with our creators',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSignUpModal();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              child: const Text('Sign Up Free', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      action();
    }
  }

  void _showPaywallDialog(Teaser teaser, String contentType, double price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(
          'Premium $contentType',
          style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          'Access ${teaser.name}\'s $contentType for \$$price',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.pinkAccent,
                  content: Text('Purchased $contentType access!', style: const TextStyle(color: Colors.black)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            child: const Text('Buy Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLiveOptions(Teaser teaser) {
    _checkMembership(() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black87,
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Live with ${teaser.name}',
                style: TextStyle(color: Colors.pinkAccent, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.group, color: Colors.pinkAccent, size: 24),
                title: const Text('Group Live', style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: Text('Next: ${_formatTime(teaser.nextLiveSession)} • \$${teaser.liveSessionFee}', 
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                onTap: () => _showPaywallDialog(teaser, 'group live', teaser.liveSessionFee),
              ),
              ListTile(
                leading: const Icon(Icons.video_call, color: Colors.pinkAccent, size: 24),
                title: const Text('Private Live', style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: Text('\$${teaser.privateLiveFee} per session', 
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                onTap: () => _requestPrivateLive(teaser),
              ),
            ],
          ),
        ),
      );
    }, 'enjoy live shows');
  }

  void _requestPrivateLive(Teaser teaser) {
    _checkMembership(() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            'Private Live Request',
            style: TextStyle(color: Colors.pinkAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Request sent to ${teaser.name} for private live session. They will respond with exact pricing.',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      );
    }, 'request private live sessions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.purple, Colors.pink],
          ),
        ),
        child: Column(
          children: [
            // Enhanced Header with Connect Message
            Container(
              padding: const EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Back Button
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.pinkAccent, width: 1.5),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _username,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Connect with amazing creators',
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Filter
                      Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.pinkAccent),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            icon: const Icon(Icons.filter_list, color: Colors.pinkAccent, size: 14),
                            iconSize: 14,
                            dropdownColor: Colors.black87,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            onChanged: (String? newValue) {
                              setState(() => _selectedFilter = newValue!);
                            },
                            items: _filters.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Teasers Grid - 5cm x 5cm cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0, // Perfect 5cm x 5cm square
                  ),
                  itemCount: _filteredTeasers.length,
                  itemBuilder: (context, index) {
                    return _buildTeaserTile(_filteredTeasers[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeaserTile(Teaser teaser) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.4),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture - 80% of card
          Expanded(
            flex: 80, // 80% of space
            child: Stack(
              children: [
                // Main Profile Image
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(teaser.profilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Online Status
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: teaser.isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
                // Rating
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 8),
                        const SizedBox(width: 1),
                        Text(
                          teaser.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Exciting Tagline Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                    ),
                    child: Text(
                      teaser.excitingTagline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sexual Info - Single Row (Increased font by 2px)
          Container(
            height: 22, // Slightly increased height
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                // Name and Age
                Text(
                  '${teaser.name}, ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12, // Increased from 10
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${teaser.age}',
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 12, // Increased from 10
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                // Measurements
                Expanded(
                  child: Text(
                    '${teaser.measurements} • ${teaser.ethnicity}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11, // Increased from 9
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Community
                Row(
                  children: [
                    const Icon(Icons.people, color: Colors.white70, size: 10),
                    const SizedBox(width: 2),
                    Text(
                      _formatNumber(teaser.communityMembers),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10, // Increased from 8
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Functionality Icons - Single Row (15% bigger icons)
          Container(
            height: 26, // Slightly increased height
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Chat (Free) - Requires membership
                _buildFunctionalityIcon(
                  icon: Icons.chat,
                  onTap: () => _checkMembership(() => _startChat(teaser), 'chat with creators'),
                  tooltip: 'Chat with ${teaser.name}',
                  isFree: true,
                ),
                // Community - Requires membership
                _buildFunctionalityIcon(
                  icon: Icons.people,
                  onTap: () => _checkMembership(() => _joinCommunity(teaser), 'join communities'),
                  tooltip: 'Join Community',
                  isFree: true,
                ),
                // Photos - No membership required
                _buildFunctionalityIcon(
                  icon: Icons.photo_library,
                  onTap: () => _showPaywallDialog(teaser, 'photos', teaser.subscriptionFee),
                  tooltip: 'View Photos - \$${teaser.subscriptionFee}',
                  isFree: false,
                ),
                // Videos - No membership required
                _buildFunctionalityIcon(
                  icon: Icons.videocam,
                  onTap: () => _showPaywallDialog(teaser, 'videos', teaser.subscriptionFee),
                  tooltip: 'Watch Videos - \$${teaser.subscriptionFee}',
                  isFree: false,
                ),
                // Live Show - Requires membership
                _buildFunctionalityIcon(
                  icon: Icons.live_tv,
                  onTap: () => _checkMembership(() => _showLiveOptions(teaser), 'enjoy live shows'),
                  tooltip: 'Live Shows - \$${teaser.liveSessionFee}',
                  isFree: false,
                ),
                // Private Live - Requires membership
                _buildFunctionalityIcon(
                  icon: Icons.video_call,
                  onTap: () => _checkMembership(() => _requestPrivateLive(teaser), 'request private live'),
                  tooltip: 'Private Live - Request',
                  isFree: false,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildFunctionalityIcon({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    required bool isFree,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 20, // Increased from 18 (15% bigger)
          height: 20, // Increased from 18 (15% bigger)
          decoration: BoxDecoration(
            color: isFree ? Colors.pinkAccent : Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
            border: Border.all(
              color: isFree ? Colors.transparent : Colors.white.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 12, // Increased from 10 (15% bigger)
          ),
        ),
      ),
    );
  }

  void _startChat(Teaser teaser) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.pinkAccent,
        content: Text('Chatting with ${teaser.name}', style: const TextStyle(color: Colors.black, fontSize: 14)),
      ),
    );
  }

  void _joinCommunity(Teaser teaser) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.purpleAccent,
        content: Text('Joined ${teaser.name}\'s community', style: const TextStyle(color: Colors.black, fontSize: 14)),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

class Teaser {
  final String id;
  final String name;
  final String profilePic;
  final bool isOnline;
  final double subscriptionFee;
  final double liveSessionFee;
  final double privateLiveFee;
  final int age;
  final String height;
  final String measurements;
  final String ethnicity;
  final String orientation;
  final String specialties;
  final String lastMessage;
  final int communityMembers;
  final DateTime nextLiveSession;
  final double rating;
  final String excitingTagline;

  Teaser({
    required this.id,
    required this.name,
    required this.profilePic,
    required this.isOnline,
    required this.subscriptionFee,
    required this.liveSessionFee,
    required this.privateLiveFee,
    required this.age,
    required this.height,
    required this.measurements,
    required this.ethnicity,
    required this.orientation,
    required this.specialties,
    required this.lastMessage,
    required this.communityMembers,
    required this.nextLiveSession,
    required this.rating,
    required this.excitingTagline,
  });
}