class UserModel {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final String? coverUrl;
  final String? bio;
  final String? partnerName;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final String
  likesCount; // Keeping as String to match "15.2K" format or I can handle formatting later. Let's use String for now as per UI.
  final double rating;
  final bool isVerified;
  final bool isPremium;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    this.coverUrl,
    this.bio,
    this.partnerName,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesCount = '0',
    this.rating = 0.0,
    this.isVerified = false,
    this.isPremium = false,
  });

  // Factory for empty/unknown user
  factory UserModel.unknown() {
    return const UserModel(
      id: 'unknown',
      name: 'Usuario Desconocido',
      username: 'unknown',
      avatarUrl: 'https://picsum.photos/seed/unknown/200',
      bio: 'Este usuario no existe o ha sido eliminado.',
    );
  }
}
