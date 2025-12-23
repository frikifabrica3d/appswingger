import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../feed/presentation/pages/post_detail_page.dart';
import '../../../feed/domain/models/post.dart';
import 'edit_profile_page.dart';
import '../../../stories/presentation/widgets/profile_highlights.dart';

import '../../../settings/presentation/widgets/settings_bottom_sheet.dart';
import '../../../chat/presentation/pages/inbox_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../domain/models/user_model.dart';
import '../../../../core/data/mock_data_source.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mock current user ID
  static const String currentUserId = 'me';

  late bool isMyProfile;
  late bool showAppBar;
  bool isFollowing = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    // Logic: If userId is null or matches currentUserId, it's my profile.
    // If userId is provided (and not currentUserId), it's someone else's.
    isMyProfile =
        widget.userId == null ||
        widget.userId == currentUserId ||
        widget.userId == 'user_me';

    // Logic: Show AppBar only if userId is provided (implies pushed navigation).
    // If userId is null, it's likely the MainLayout tab, which handles the AppBar.
    showAppBar = widget.userId != null;

    _loadUserProfile(widget.userId);
  }

  void _loadUserProfile(String? targetId) {
    if (targetId == null || targetId == 'me' || targetId == 'user_me') {
      setState(() {
        user = MockDataSource.getUserById('user_me');
      });
    } else {
      setState(() {
        user = MockDataSource.getUserById(targetId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cyanNeon = const Color(0xFF00FFFF);
    // final isDark = Theme.of(context).brightness == Brightness.dark; // Unused for now

    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00FFFF)),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            // Conditional AppBar for pushed navigation
            if (showAppBar)
              SliverAppBar(
                backgroundColor: Colors.black,
                pinned: true,
                title: Text(
                  isMyProfile ? 'Mi Perfil' : user!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton(color: Colors.white),
                actions: [
                  if (isMyProfile) ...[
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
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
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InboxPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const SettingsBottomSheet(),
                        );
                      },
                    ),
                  ] else
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Acción: $value')),
                        );
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'report',
                          child: Text('Reportar usuario'),
                        ),
                        const PopupMenuItem(
                          value: 'block',
                          child: Text('Bloquear usuario'),
                        ),
                      ],
                    ),
                ],
              ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Stack: Portada + Avatar Pulsante Centrado
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        // Capa 1: Portada
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                user!.coverUrl ??
                                    'https://picsum.photos/seed/cover/800/400',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Capa 2: Avatar Pulsante Centrado
                        Positioned(
                          top: 140, // Se monta 60px sobre la portada
                          left: 0,
                          right: 0,
                          child: Center(
                            child: PulsatingAvatar(imageUrl: user!.avatarUrl),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cuerpo del Perfil (Debajo del Stack)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // Nombre y Bio con Badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user!.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Badges Logic
                            if (user!.isVerified) ...[
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                            ],
                            if (user!.isPremium)
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Partner Display
                        Builder(
                          builder: (context) {
                            final String? partnerName = user!.partnerName;
                            if (partnerName == null) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ver perfil de pareja'),
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: '🔗 En Pareja con: ',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '@$partnerName',
                                      style: const TextStyle(
                                        color: Color(0xFF00FFFF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user!.bio ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Estadísticas (4 items)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(
                              count: user!.postsCount.toString(),
                              label: 'Posts',
                            ),
                            _StatItem(
                              count: user!.followersCount.toString(),
                              label: 'Seguidores',
                            ),
                            _StatItem(
                              count: user!.followingCount.toString(),
                              label: 'Seguidos',
                            ),
                            _StatItem(count: user!.likesCount, label: 'Likes'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Botones de Acción Adaptativos
                        if (isMyProfile)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfilePage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cyanNeon,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Editar perfil'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.grey),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Estadísticas'),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isFollowing = !isFollowing;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFollowing
                                      ? Colors.transparent
                                      : cyanNeon,
                                  foregroundColor: isFollowing
                                      ? Colors.white
                                      : Colors.black,
                                  side: isFollowing
                                      ? const BorderSide(color: Colors.white)
                                      : null,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  isFollowing ? 'Siguiendo' : 'Seguir',
                                ),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const InboxPage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.grey),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Mensaje'),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),

                        // Rating de Usuario
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < user!.rating.floor()
                                      ? Icons.star
                                      : Icons.star_half,
                                  color: Colors.amber,
                                  size: 18,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Calificación: ${user!.rating}/5.0',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Highlights
                        const ProfileHighlights(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sticky TabBar
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicatorColor: cyanNeon,
                  labelColor: cyanNeon,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on_rounded)),
                    Tab(icon: Icon(Icons.video_library_rounded)),
                    Tab(icon: Icon(Icons.person_pin_rounded)),
                  ],
                ),
              ),
              pinned: true,
            ),

            // Contenido TabBarView
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  _PhotoGrid(seed: 'posts', user: user!),
                  _PhotoGrid(seed: 'reels', user: user!),
                  _PhotoGrid(seed: 'tagged', user: user!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PulsatingAvatar extends StatefulWidget {
  final String imageUrl;

  const PulsatingAvatar({super.key, required this.imageUrl});

  @override
  State<PulsatingAvatar> createState() => _PulsatingAvatarState();
}

class _PulsatingAvatarState extends State<PulsatingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF0040), // Rojo-Rosado Neón
                blurRadius: 5 + (15 * _animation.value), // 5 a 20
                spreadRadius: 0 + (10 * _animation.value), // 0 a 10
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(3), // Borde sólido de 3px
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Blanco Puro
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: CachedNetworkImageProvider(widget.imageUrl),
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ],
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  final String seed;
  final UserModel user;

  const _PhotoGrid({required this.seed, required this.user});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        final imageUrl = 'https://picsum.photos/seed/$seed$index/300';
        final heroTag = 'profile_$seed$index';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(
                  post: Post(
                    id: 'profile_$seed$index',
                    userId: user.id, // Use dynamic user ID
                    username: user.name, // Use dynamic user name
                    userAvatarUrl: user.avatarUrl, // Use dynamic avatar
                    imageUrl: imageUrl,
                    caption: 'Foto de perfil #$index',
                    timestamp: DateTime.now(),
                    likesCount: 120,
                    commentsCount: 15,
                  ),
                  heroTag: heroTag,
                ),
              ),
            );
          },
          child: Hero(
            tag: heroTag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: Colors.grey.shade900),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.black, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
