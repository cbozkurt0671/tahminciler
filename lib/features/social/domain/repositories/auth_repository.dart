import '../../data/models/user_entity.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<UserEntity> login(String email, String password);

  /// Register new user
  Future<UserEntity> register({
    required String email,
    required String username,
    required String password,
  });

  /// Get currently logged in user
  Future<UserEntity?> getCurrentUser();

  /// Logout current user
  Future<void> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Update user profile
  Future<UserEntity> updateProfile({
    String? username,
    String? avatarUrl,
  });
}
