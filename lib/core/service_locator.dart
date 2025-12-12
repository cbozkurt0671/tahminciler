import 'package:get_it/get_it.dart';
import '../features/home/domain/repositories/match_repository.dart';
import '../features/home/data/repositories/mock_match_repository.dart';
import '../features/home/data/repositories/pocketbase_match_repository.dart';
import '../features/home/data/repositories/sofascore_repository.dart';
import '../features/social/domain/repositories/auth_repository.dart';
import '../features/social/domain/repositories/social_repository.dart';
import '../features/social/data/repositories/mock_auth_repository.dart';
import '../features/social/data/repositories/mock_social_repository.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Data source configuration
/// Choose your data source for match data:
/// - 'mock': Local dummy data (development)
/// - 'sofascore': Real-time data from SofaScore API
/// - 'pocketbase': Your own backend server
enum DataSource { mock, sofascore, pocketbase }

/// Toggle between data sources
/// Change this to switch data sources
const DataSource _activeDataSource = DataSource.sofascore;

/// Initialize all dependencies
/// Call this in main() before runApp()
void setupServiceLocator() {
  // Register MatchRepository based on active data source
  // This is a singleton - only one instance exists throughout the app lifecycle
  getIt.registerLazySingleton<MatchRepository>(() {
    switch (_activeDataSource) {
      case DataSource.mock:
        return MockMatchRepository();
      case DataSource.sofascore:
        return SofaScoreRepository();
      case DataSource.pocketbase:
        return PocketBaseMatchRepository();
    }
  });

  // Register AuthRepository
  getIt.registerLazySingleton<AuthRepository>(
    () => MockAuthRepository(), // Always use mock for now
  );

  // Register SocialRepository
  getIt.registerLazySingleton<SocialRepository>(
    () => MockSocialRepository(), // Always use mock for now
  );

  // Log configuration
  final dataSourceName = _activeDataSource.toString().split('.').last.toUpperCase();
  print('🔧 Service Locator initialized');
  print('📦 Data Source: $dataSourceName');
  if (_activeDataSource == DataSource.sofascore) {
    print('🌐 SofaScore API: Live data from real matches');
    print('📅 Date: 12 Aralık 2025');
  }
  print('👤 Auth: Mock (Auto-login enabled)');
  print('🏆 Social: Mock (Ofis Tayfa league ready)');
}

/// Helper function to get MatchRepository anywhere in the app
/// Usage: final repo = getMatchRepository();
MatchRepository getMatchRepository() {
  return getIt<MatchRepository>();
}

/// Helper function to get AuthRepository anywhere in the app
/// Usage: final repo = getAuthRepository();
AuthRepository getAuthRepository() {
  return getIt<AuthRepository>();
}

/// Helper function to get SocialRepository anywhere in the app
/// Usage: final repo = getSocialRepository();
SocialRepository getSocialRepository() {
  return getIt<SocialRepository>();
}

/// Reset service locator (useful for testing)
void resetServiceLocator() {
  getIt.reset();
  print('🔄 Service Locator reset');
}
