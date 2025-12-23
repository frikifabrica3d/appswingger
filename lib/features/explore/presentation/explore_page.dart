import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../feed/presentation/pages/post_detail_page.dart';
import '../../feed/domain/models/post.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<String> _filters = [
    "Para ti",
    "Cerca",
    "Nuevos",
    "Verificados",
    "Parejas",
    "Singles",
    "Lugares",
    "Clubs",
  ];
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar & Filters Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar usuarios, hashtags...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_filters.length, (index) {
                          final isSelected = _selectedFilterIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(_filters[index]),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedFilterIndex = index;
                                });
                              },
                              selectedColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Staggered Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childCount: 30, // Mock items
                itemBuilder: (context, index) {
                  // Random height for staggered effect
                  final height = (index % 5 + 2) * 50.0;
                  final imageUrl =
                      'https://picsum.photos/seed/explore$index/300/${height.toInt()}';
                  final heroTag = 'explore_image_$index';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(
                            post: Post(
                              id: 'explore_$index',
                              userId: 'user_$index',
                              username: 'Usuario $index',
                              userAvatarUrl:
                                  'https://picsum.photos/seed/avatar$index/100',
                              imageUrl: imageUrl,
                              caption: 'Explorando #$index',
                              timestamp: DateTime.now(),
                              likesCount: index * 10,
                              commentsCount: index,
                            ),
                            heroTag: heroTag,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: height,
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: height,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
