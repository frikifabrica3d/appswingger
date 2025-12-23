import '../../features/profile/domain/models/user_model.dart';

class MockDataSource {
  // 1. Usuario Actual (currentUser)
  static const UserModel currentUser = UserModel(
    id: 'user_me',
    name: 'Pareja Swing Madrid',
    username: 'parejaswingmadrid',
    avatarUrl: 'https://picsum.photos/seed/profile/200',
    coverUrl: 'https://picsum.photos/seed/cover/800/400',
    bio:
        'Explorando nuevos horizontes 🌍\nAmantes del vino y la buena compañía 🍷\nBuscamos gente con buena vibra ✨',
    partnerName: 'LadySwingo',
    postsCount: 125,
    followersCount: 854,
    followingCount: 320,
    likesCount: '15.2K',
    rating: 4.8,
    isVerified: true,
    isPremium: true,
  );

  // 2. Otros Usuarios (mockUsers)
  static final List<UserModel> mockUsers = [
    const UserModel(
      id: 'user_001',
      name: 'LadySwingo',
      username: 'ladyswingo',
      avatarUrl: 'https://picsum.photos/seed/lady/200',
      coverUrl: 'https://picsum.photos/seed/lady_cover/800/400',
      bio:
          'Disfrutando de la vida al máximo 💃\nSiempre lista para una nueva aventura.',
      partnerName: 'Pareja Swing Madrid',
      postsCount: 45,
      followersCount: 1200,
      followingCount: 150,
      likesCount: '5.4K',
      rating: 4.9,
      isVerified: true,
      isPremium: false,
    ),
    const UserModel(
      id: 'user_002',
      name: 'Carlos y Ana',
      username: 'carlosyana',
      avatarUrl: 'https://picsum.photos/seed/couple1/200',
      coverUrl: 'https://picsum.photos/seed/couple1_cover/800/400',
      bio:
          'Pareja divertida buscando conocer gente nueva.\nNos encanta viajar y bailar.',
      postsCount: 89,
      followersCount: 560,
      followingCount: 400,
      likesCount: '2.1K',
      rating: 4.5,
      isVerified: false,
      isPremium: true,
    ),
    const UserModel(
      id: 'user_003',
      name: 'Vanesa Free',
      username: 'vanesafree',
      avatarUrl: 'https://picsum.photos/seed/vanesa/200',
      coverUrl: 'https://picsum.photos/seed/vanesa_cover/800/400',
      bio:
          'Espíritu libre 🦋\nAmante de la naturaleza y las conexiones reales.',
      postsCount: 210,
      followersCount: 3500,
      followingCount: 120,
      likesCount: '25K',
      rating: 5.0,
      isVerified: true,
      isPremium: true,
    ),
    const UserModel(
      id: 'user_004',
      name: 'Club Paraíso',
      username: 'clubparaiso',
      avatarUrl: 'https://picsum.photos/seed/club/200',
      coverUrl: 'https://picsum.photos/seed/club_cover/800/400',
      bio:
          'El mejor lugar para tus noches más atrevidas 🥂\nEventos exclusivos cada fin de semana.',
      postsCount: 500,
      followersCount: 10500,
      followingCount: 50,
      likesCount: '100K',
      rating: 4.7,
      isVerified: true,
      isPremium: true,
    ),
  ];

  // 3. Método estático getUserById
  static UserModel getUserById(String id) {
    if (id == 'user_me' || id == 'me') {
      return currentUser;
    }

    try {
      return mockUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return UserModel.unknown();
    }
  }
}
