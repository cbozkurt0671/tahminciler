import 'dart:math';
import '../../data/models/user_entity.dart';
import '../../data/models/league_entity.dart';
import '../../data/models/league_message_entity.dart';
import '../../data/models/duel_entity.dart';
import '../../data/models/power_up_entity.dart';
import '../../domain/repositories/social_repository.dart';

/// Mock implementation of SocialRepository for development
class MockSocialRepository implements SocialRepository {
  final String _currentUserId = 'user_1'; // Bozkurt

  // Mock users with power-ups
  final List<UserEntity> _allUsers = [
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
    ),
    UserEntity(
      id: 'user_2',
      username: 'Ali Yılmaz',
      email: 'ali@example.com',
      totalPoints: 1450,
      globalRank: 1,
      correctPredictions: 52,
      totalPredictions: 60,
      badges: ['Champion', 'Oracle'],
      powerUps: [],
    ),
    UserEntity(
      id: 'user_3',
      username: 'Ayşe Demir',
      email: 'ayse@example.com',
      totalPoints: 980,
      globalRank: 3,
      correctPredictions: 38,
      totalPredictions: 60,
      badges: ['Rising Star'],
      powerUps: [],
    ),
    UserEntity(
      id: 'user_4',
      username: 'Mehmet Kaya',
      email: 'mehmet@example.com',
      totalPoints: 750,
      globalRank: 4,
      correctPredictions: 30,
      totalPredictions: 60,
      badges: [],
      powerUps: [],
    ),
    UserEntity(
      id: 'user_5',
      username: 'Fatma Şahin',
      email: 'fatma@example.com',
      totalPoints: 420,
      globalRank: 5,
      correctPredictions: 18,
      totalPredictions: 60,
      badges: [],
      powerUps: [],
    ),
  ];

  // Mock leagues
  List<LeagueEntity> _leagues = [];

  MockSocialRepository() {
    _initializeLeagues();
  }

  void _initializeLeagues() {
    // Create "Ofis Tayfa" league
    _leagues = [
      LeagueEntity(
        id: 'league_1',
        name: 'Ofis Tayfa',
        inviteCode: 'OFIS99',
        ownerId: 'user_2',
        members: [
          LeagueMember(
            user: _allUsers[1], // Ali - #1
            leaguePoints: 1450,
            leagueRank: 1,
            weeklyChange: 150,
          ),
          LeagueMember(
            user: _allUsers[0], // Bozkurt - #2 (Current user)
            leaguePoints: 1250,
            leagueRank: 2,
            weeklyChange: 80,
          ),
          LeagueMember(
            user: _allUsers[2], // Ayşe - #3
            leaguePoints: 980,
            leagueRank: 3,
            weeklyChange: -20,
          ),
          LeagueMember(
            user: _allUsers[3], // Mehmet - #4
            leaguePoints: 750,
            leagueRank: 4,
            weeklyChange: 30,
          ),
          LeagueMember(
            user: _allUsers[4], // Fatma - #5 (Last place)
            leaguePoints: 420,
            leagueRank: 5,
            weeklyChange: -50,
          ),
        ],
        createdAt: DateTime(2025, 11, 15),
      ),
    ];
  }

  @override
  Future<List<LeagueEntity>> getMyLeagues() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return leagues where current user is a member
    return _leagues.where((league) {
      return league.members.any((m) => m.user.id == _currentUserId);
    }).toList();
  }

  @override
  Future<LeagueEntity> createLeague(String name) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (name.isEmpty) {
      throw Exception('Lig adı boş olamaz');
    }

    // Generate random invite code
    final inviteCode = _generateInviteCode();

    // Create new league with only the creator
    final currentUser = _allUsers.firstWhere((u) => u.id == _currentUserId);
    final newLeague = LeagueEntity(
      id: 'league_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      inviteCode: inviteCode,
      ownerId: _currentUserId,
      members: [
        LeagueMember(
          user: currentUser,
          leaguePoints: currentUser.totalPoints,
          leagueRank: 1,
          weeklyChange: 0,
        ),
      ],
    );

    _leagues.add(newLeague);
    print('✅ Mock: League created: $name (Code: $inviteCode)');
    return newLeague;
  }

  @override
  Future<LeagueEntity> joinLeague(String inviteCode) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Find league by invite code
    final league = _leagues.firstWhere(
      (l) => l.inviteCode.toUpperCase() == inviteCode.toUpperCase(),
      orElse: () => throw Exception('Geçersiz davet kodu'),
    );

    // Check if already a member
    if (league.members.any((m) => m.user.id == _currentUserId)) {
      throw Exception('Zaten bu ligin üyesisiniz');
    }

    // Add current user to league
    final currentUser = _allUsers.firstWhere((u) => u.id == _currentUserId);
    final newMember = LeagueMember(
      user: currentUser,
      leaguePoints: currentUser.totalPoints,
      leagueRank: league.members.length + 1,
      weeklyChange: 0,
    );

    // Update league
    final updatedMembers = [...league.members, newMember];
    final updatedLeague = league.copyWith(members: updatedMembers);
    
    // Replace old league
    final index = _leagues.indexWhere((l) => l.id == league.id);
    _leagues[index] = updatedLeague;

    print('✅ Mock: Joined league: ${league.name}');
    return updatedLeague;
  }

  @override
  Future<List<LeagueMember>> getLeagueStandings(String leagueId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final league = _leagues.firstWhere(
      (l) => l.id == leagueId,
      orElse: () => throw Exception('Lig bulunamadı'),
    );

    // Sort by points descending
    final sortedMembers = List<LeagueMember>.from(league.members)
      ..sort((a, b) => b.leaguePoints.compareTo(a.leaguePoints));

    return sortedMembers;
  }

  @override
  Future<List<UserEntity>> getGlobalLeaderboard({int limit = 100}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Sort all users by totalPoints
    final sorted = List<UserEntity>.from(_allUsers)
      ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

    return sorted.take(limit).toList();
  }

  @override
  Future<void> leaveLeague(String leagueId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final league = _leagues.firstWhere(
      (l) => l.id == leagueId,
      orElse: () => throw Exception('Lig bulunamadı'),
    );

    // Remove current user from members
    final updatedMembers = league.members.where((m) => m.user.id != _currentUserId).toList();
    
    if (updatedMembers.isEmpty) {
      // Delete league if no members left
      _leagues.removeWhere((l) => l.id == leagueId);
      print('🗑️ Mock: League deleted (no members left)');
    } else {
      final updatedLeague = league.copyWith(members: updatedMembers);
      final index = _leagues.indexWhere((l) => l.id == leagueId);
      _leagues[index] = updatedLeague;
      print('👋 Mock: Left league: ${league.name}');
    }
  }

  @override
  Future<LeagueEntity> getLeagueById(String leagueId) async {
    await Future.delayed(const Duration(milliseconds: 150));

    return _leagues.firstWhere(
      (l) => l.id == leagueId,
      orElse: () => throw Exception('Lig bulunamadı'),
    );
  }

  @override
  Future<List<UserEntity>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (query.isEmpty) return [];

    return _allUsers.where((user) {
      return user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // ===== League Chat/Feed =====
  final Map<String, List<LeagueMessageEntity>> _leagueMessages = {};

  @override
  Future<List<LeagueMessageEntity>> getLeagueMessages(String leagueId, {int limit = 50}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (!_leagueMessages.containsKey(leagueId)) {
      _initializeLeagueMessages(leagueId);
    }

    return _leagueMessages[leagueId]!.take(limit).toList();
  }

  void _initializeLeagueMessages(String leagueId) {
    _leagueMessages[leagueId] = [
      LeagueMessageEntity(
        id: 'msg_1',
        senderId: 'user_2',
        senderName: 'Ali Yılmaz',
        text: '🔥 Bu hafta beni kimse durduramaz!',
        type: LeagueMessageType.chat,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LeagueMessageEntity(
        id: 'msg_2',
        senderId: 'system',
        senderName: 'Sistem',
        text: '⚡ Ali Yılmaz x2 Çarpan jokerini İngiltere-Fransa maçında kullandı!',
        type: LeagueMessageType.jokerUsed,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      LeagueMessageEntity(
        id: 'msg_3',
        senderId: 'user_3',
        senderName: 'Ayşe Demir',
        text: 'Brezilya kesin kazanır, eminim!',
        type: LeagueMessageType.chat,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      LeagueMessageEntity(
        id: 'msg_4',
        senderId: 'system',
        senderName: 'Sistem',
        text: '⚔️ Bozkurt, Mehmet\'e düello daveti gönderdi!',
        type: LeagueMessageType.duelChallenge,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      LeagueMessageEntity(
        id: 'msg_5',
        senderId: 'user_4',
        senderName: 'Mehmet Kaya',
        text: 'Sıralamada yükselişteyim 📈',
        type: LeagueMessageType.chat,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LeagueMessageEntity(
        id: 'msg_6',
        senderId: 'system',
        senderName: 'Sistem',
        text: '🏆 Ayşe Demir düelloda Fatma\'yı yendi ve 50 puan kazandı!',
        type: LeagueMessageType.duelResult,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ),
      LeagueMessageEntity(
        id: 'msg_7',
        senderId: 'user_1',
        senderName: 'Bozkurt',
        text: 'Zirveye çıkacağım, hazır olun! 💪',
        type: LeagueMessageType.chat,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  @override
  Future<void> sendLeagueMessage(String leagueId, String text) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!_leagueMessages.containsKey(leagueId)) {
      _initializeLeagueMessages(leagueId);
    }

    final currentUser = _allUsers.firstWhere((u) => u.id == _currentUserId);
    final newMessage = LeagueMessageEntity(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _currentUserId,
      senderName: currentUser.username,
      text: text,
      type: LeagueMessageType.chat,
      timestamp: DateTime.now(),
    );

    _leagueMessages[leagueId]!.insert(0, newMessage);
    print('💬 Message sent: $text');
  }

  // ===== 1v1 Duels =====
  final List<DuelEntity> _duels = [];

  @override
  Future<DuelEntity> createDuel({
    required String opponentId,
    required String matchId,
    required int stakeAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final currentUser = _allUsers.firstWhere((u) => u.id == _currentUserId);
    final opponent = _allUsers.firstWhere((u) => u.id == opponentId);

    final duel = DuelEntity(
      id: 'duel_${DateTime.now().millisecondsSinceEpoch}',
      challengerId: _currentUserId,
      challengerName: currentUser.username,
      opponentId: opponentId,
      opponentName: opponent.username,
      matchId: matchId,
      matchName: 'İngiltere vs Fransa', // Mock
      stakeAmount: stakeAmount,
      status: DuelStatus.pending,
      createdAt: DateTime.now(),
    );

    _duels.add(duel);
    print('⚔️ Duel created: ${currentUser.username} vs ${opponent.username}');
    return duel;
  }

  @override
  Future<List<DuelEntity>> getMyDuels() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _duels.where((d) {
      return d.challengerId == _currentUserId || d.opponentId == _currentUserId;
    }).toList();
  }

  // ===== Power-Ups (Jokers) =====
  final Map<String, Map<PowerUpType, bool>> _usedPowerUps = {};

  @override
  Future<void> usePowerUp({
    required String matchId,
    required PowerUpType powerUpType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final currentUser = _allUsers.firstWhere((u) => u.id == _currentUserId);
    final powerUp = currentUser.powerUps.firstWhere(
      (p) => p.type == powerUpType,
      orElse: () => throw Exception('Joker bulunamadı'),
    );

    if (powerUp.count <= 0) {
      throw Exception('Yeterli joker yok');
    }

    // Mark as used for this match
    if (!_usedPowerUps.containsKey(matchId)) {
      _usedPowerUps[matchId] = {};
    }
    _usedPowerUps[matchId]![powerUpType] = true;

    // Decrease count
    final updatedPowerUp = powerUp.copyWith(count: powerUp.count - 1);
    final index = currentUser.powerUps.indexWhere((p) => p.id == powerUp.id);
    currentUser.powerUps[index] = updatedPowerUp;

    print('🃏 Power-up used: ${powerUpType.displayName} on match $matchId');
  }

  @override
  Future<List<PowerUpEntity>> getMyPowerUps() async {
    await Future.delayed(const Duration(milliseconds: 150));

    final currentUser = _allUsers.firstWhere((u) => u.id == _currentUserId);
    return currentUser.powerUps;
  }

  @override
  Future<Map<String, String>> spyOnPredictions(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock predictions data
    return {
      'Ali Yılmaz': '2-1',
      'Ayşe Demir': '1-0',
      'Mehmet Kaya': '3-2',
      'Fatma Şahin': '0-0',
    };
  }
}
