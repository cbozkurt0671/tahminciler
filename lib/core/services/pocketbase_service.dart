import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  factory PocketBaseService() => _instance;
  PocketBaseService._internal();

  // PocketBase client instance
  late final PocketBase pb;

  // Initialize PocketBase client
  void initialize() {
    pb = PocketBase('http://92.5.101.38:8090');
  }

  // Login with email and password
  Future<RecordAuth> login(String email, String password) async {
    try {
      final authData = await pb.collection('users').authWithPassword(
        email,
        password,
      );
      return authData;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Register a new user
  Future<RecordAuth> register(
    String email,
    String password,
    String passwordConfirm, {
    String? name,
  }) async {
    try {
      // Create the user record
      final body = <String, dynamic>{
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      };

      if (name != null && name.isNotEmpty) {
        body['name'] = name;
      }

      await pb.collection('users').create(body: body);

      // Auto-login after registration
      final authData = await login(email, password);
      return authData;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Request password reset email
  Future<bool> requestPasswordReset(String email) async {
    try {
      await pb.collection('users').requestPasswordReset(email);
      return true;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  void logout() {
    pb.authStore.clear();
  }

  // Check if user is authenticated
  bool get isAuthenticated => pb.authStore.isValid;

  // Get current user
  RecordModel? get currentUser => pb.authStore.record;

  // Get current token
  String? get token => pb.authStore.token;

  // Error handling helper
  String _handleError(dynamic error) {
    if (error is ClientException) {
      final response = error.response;
      
      // Handle specific error codes
      if (response.containsKey('message')) {
        final message = response['message'] as String;
        
        // Common error messages
        if (message.contains('Failed to authenticate')) {
          return 'E-posta veya şifre hatalı';
        } else if (message.contains('already exists')) {
          return 'Bu e-posta adresi zaten kullanılıyor';
        } else if (message.contains('invalid email')) {
          return 'Geçersiz e-posta adresi';
        } else if (message.contains('password')) {
          return 'Şifre en az 8 karakter olmalı';
        }
        
        return message;
      }
      
      return 'Bir hata oluştu: ${error.statusCode}';
    }
    
    // Network or other errors
    if (error.toString().contains('SocketException') || 
        error.toString().contains('NetworkException')) {
      return 'Bağlantı hatası. İnternet bağlantınızı kontrol edin';
    }
    
    return 'Beklenmeyen bir hata oluştu';
  }
}
