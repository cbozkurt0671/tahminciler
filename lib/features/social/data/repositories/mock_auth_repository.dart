import 'dart:math';
import '../../data/models/user_entity.dart';
import '../../data/models/power_up_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock implementation of AuthRepository for development
class MockAuthRepository implements AuthRepository {
  UserEntity? _currentUser;

  // Mock users database
  final List<UserEntity> _users = [
    UserEntity(
      id: 'user_1',
      username: 'Bozkurt',
      email: 'bozkurt@example.com',
      totalPoints: 1250,
      globalRank: 2,
      correctPredictions: 45,
      totalPredictions: 60,
      badges: ['Derby King', 'Sniper', 'Prophet'],
      powerUps: [
        PowerUpEntity(
          id: 'pu_1',
          name: 'Casus',
          icon: '🕵️',
          count: 2,
          description: 'Rakiplerin tahminlerini gör',
          type: PowerUpType.spy,
        ),
        PowerUpEntity(
          id: 'pu_2',
          name: 'x2 Çarpan',
          icon: '⚡',
          count: 1,
          description: 'Kazanç/Kayıp x2',
          type: PowerUpType.booster,
        ),
        PowerUpEntity(
          id: 'pu_3',
          name: 'Sigorta',
          icon: '🛡️',
          count: 1,
          description: 'Puan kaybına karşı koruma',
          type: PowerUpType.shield,
        ),
      ],
      createdAt: DateTime(2025, 11, 1),
    ),
  ];

  @override
  Future<UserEntity> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email ve şifre boş olamaz');
    }

    if (password.length < 6) {
      throw Exception('Şifre en az 6 karakter olmalı');
    }

    // Find user
    final user = _users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Kullanıcı bulunamadı'),
    );

    _currentUser = user;
    print('✅ Mock: User logged in: ${user.username}');
    return user;
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Validation
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      throw Exception('Tüm alanları doldurun');
    }

    if (password.length < 6) {
      throw Exception('Şifre en az 6 karakter olmalı');
    }

    // Check if email exists
    if (_users.any((u) => u.email == email)) {
      throw Exception('Bu email zaten kullanılıyor');
    }

    // Create new user
    final newUser = UserEntity(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      totalPoints: 0,
      globalRank: _users.length + 1,
      badges: [],
    );

    _users.add(newUser);
    _currentUser = newUser;

    print('✅ Mock: User registered: $username');
    return newUser;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Auto-login for development
    if (_currentUser == null && _users.isNotEmpty) {
      _currentUser = _users.first;
      print('🔑 Mock: Auto-logged in as ${_currentUser!.username}');
    }
    
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    print('👋 Mock: User logged out');
    _currentUser = null;
  }

  @override
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _currentUser != null;
  }

  @override
  Future<UserEntity> updateProfile({
    String? username,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_currentUser == null) {
      throw Exception('Kullanıcı giriş yapmamış');
    }

    _currentUser = _currentUser!.copyWith(
      username: username,
      avatarUrl: avatarUrl,
    );

    print('✅ Mock: Profile updated');
    return _currentUser!;
  }

  /// Helper: Get all users (for testing)
  List<UserEntity> getAllUsers() => List.unmodifiable(_users);
}
