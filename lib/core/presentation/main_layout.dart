import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../features/feed/presentation/feed_page.dart';
import '../../features/explore/presentation/explore_page.dart';
import '../../features/dating/presentation/dating_page.dart';
import '../../features/activity/presentation/activity_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/chat/presentation/pages/inbox_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import 'package:image_picker/image_picker.dart';
import '../../features/feed/presentation/pages/create_post_page.dart';
import '../../core/theme/theme_controller.dart';
import 'widgets/animated_theme_switcher.dart';
import 'widgets/app_bar_icons_3d.dart';
import '../../features/settings/presentation/widgets/settings_bottom_sheet.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  int _currentIndex = 0;
  // _isDarkMode is now handled by ThemeController and Theme.of(context)

  final List<Widget> _pages = const [
    FeedPage(),
    ExplorePage(),
    DatingPage(), // This is technically index 2, but we'll handle it specially
    ActivityPage(),
    ProfilePage(),
  ];

  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) return; // Dating is handled by FAB
    setState(() {
      _currentIndex = index;
    });
  }

  void _onFabTapped() {
    setState(() {
      _currentIndex = 2; // Index for DatingPage
    });
  }

  // _toggleTheme is removed in favor of ThemeController.toggleTheme()

  void _showCreateOptions(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCreateOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Cámara',
                  color: Colors.blueAccent,
                  onTap: () => _handleImageSelection(ImageSource.camera),
                ),
                _buildCreateOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Galería',
                  color: Colors.purpleAccent,
                  onTap: () => _handleImageSelection(ImageSource.gallery),
                ),
                _buildCreateOption(
                  icon: Icons.edit_note_rounded,
                  label: 'Texto',
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePostPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    Navigator.pop(context); // Close modal
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostPage(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Widget _buildAppBarTitle() {
    if (_currentIndex == 4) {
      return const Text(
        'Mi Perfil',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    }

    return Shimmer.fromColors(
      baseColor: Colors.red,
      highlightColor: Colors.orange,
      child: const Text(
        'Swingo',
        style: TextStyle(
          fontFamily: 'Cursive',
          fontSize: 28,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, bool isDarkMode) {
    // Common actions (Theme Switcher) could be here or per page
    final themeSwitcher = Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: AnimatedThemeSwitcher(
        isDarkMode: isDarkMode,
        onToggle: () {
          ThemeController().toggleTheme();
        },
      ),
    );

    if (_currentIndex == 4) {
      // Profile Page Actions
      return [
        themeSwitcher,
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InboxPage()),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.menu_rounded,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 28,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const SettingsBottomSheet(),
            );
          },
        ),
        const SizedBox(width: 8),
      ];
    }

    // Default Actions (Feed, Explore, etc.)
    return [
      themeSwitcher,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: NewPostIcon3D(onPressed: () => _showCreateOptions(context)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: NotificationBellAnimated(
          hasUnread: true, // Mock state
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 12.0),
        child: MessageIcon3D(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InboxPage()),
            );
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: _buildAppBarTitle(),
        actions: _buildAppBarActions(context, isDarkMode),
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: _onFabTapped,
          backgroundColor: Colors.transparent, // Use container for gradient
          elevation: 0,
          shape: const CircleBorder(),
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFF0040), Color(0xFFFF5500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x66FF0040),
                  blurRadius: 10,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AnimatedNavBarIcon(
                icon: Icons.home_filled,
                label: 'Inicio',
                isSelected: _currentIndex == 0,
                onTap: () => _onItemTapped(0),
                isDarkMode: isDarkMode,
              ),
              _AnimatedNavBarIcon(
                icon: Icons.search,
                label: 'Explorar',
                isSelected: _currentIndex == 1,
                onTap: () => _onItemTapped(1),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(width: 48), // Space for FAB
              _AnimatedNavBarIcon(
                icon: Icons.waving_hand_rounded,
                label: 'Actividad',
                isSelected: _currentIndex == 3,
                onTap: () => _onItemTapped(3),
                isDarkMode: isDarkMode,
              ),
              _AnimatedNavBarIcon(
                icon: Icons.person_outline,
                label: 'Perfil',
                isSelected: _currentIndex == 4,
                onTap: () => _onItemTapped(4),
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavBarIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _AnimatedNavBarIcon({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedNavBarIcon> createState() => _AnimatedNavBarIconState();
}

class _AnimatedNavBarIconState extends State<_AnimatedNavBarIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _AnimatedNavBarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? (widget.isDarkMode ? const Color(0xFF00FFFF) : Colors.red)
        : (widget.isDarkMode ? Colors.grey : Colors.grey[600]);

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(widget.icon, color: color, size: 28),
          ),
          // Optional: Show label only when selected or always
          // if (widget.isSelected)
          //   Text(
          //     widget.label,
          //     style: TextStyle(color: color, fontSize: 10),
          //   ),
        ],
      ),
    );
  }
}
