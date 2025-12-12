import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/league_entity.dart';
import '../../data/models/user_entity.dart';
import '../../../../core/service_locator.dart';
import '../../domain/repositories/social_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'league_detail_screen.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<LeagueEntity> _myLeagues = [];
  List<UserEntity> _globalLeaderboard = [];
  UserEntity? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final socialRepo = getSocialRepository();
      final authRepo = getAuthRepository();
      
      final leagues = await socialRepo.getMyLeagues();
      final leaderboard = await socialRepo.getGlobalLeaderboard(limit: 100);
      final user = await authRepo.getCurrentUser();
      
      setState(() {
        _myLeagues = leagues;
        _globalLeaderboard = leaderboard;
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veriler yüklenemedi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ARENAYA GİR',
          style: GoogleFonts.audiowide(
            color: const Color(0xFF00E676),
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00E676),
          labelColor: const Color(0xFF00E676),
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.audiowide(fontSize: 12, letterSpacing: 1),
          tabs: const [
            Tab(text: 'LİGLERİM'),
            Tab(text: 'GENEL SIRALAMAM'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E676)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMyLeaguesTab(),
                _buildGlobalLeaderboardTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateJoinDialog,
        backgroundColor: const Color(0xFF00E676),
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          'OLUŞTUR / KATIL',
          style: GoogleFonts.audiowide(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMyLeaguesTab() {
    if (_myLeagues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.groups_outlined, size: 80, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              'Henüz bir lig yok',
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Yarışmak için bir lig oluştur veya katıl!',
              style: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myLeagues.length,
      itemBuilder: (context, index) {
        return _buildLeagueCard(_myLeagues[index]);
      },
    );
  }

  Widget _buildLeagueCard(LeagueEntity league) {
    final currentUserRank = league.members.firstWhere(
      (m) => m.user.id == _currentUser?.id,
      orElse: () => league.members.first,
    ).leagueRank;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1F3A),
            const Color(0xFF0A0E21),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00E676).withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToLeagueDetail(league),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        league.name,
                        style: GoogleFonts.audiowide(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E676).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF00E676)),
                      ),
                      child: Text(
                        '#$currentUserRank',
                        style: GoogleFonts.audiowide(
                          fontSize: 14,
                          color: const Color(0xFF00E676),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _copyInviteCode(league.inviteCode),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.vpn_key, size: 14, color: Colors.white54),
                        const SizedBox(width: 6),
                        Text(
                          league.inviteCode,
                          style: GoogleFonts.courierPrime(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.copy, size: 14, color: Colors.white54),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildLeagueInfo('👥 Üye', '${league.totalMembers}'),
                    const SizedBox(width: 24),
                    _buildLeagueInfo('👑 Lider', league.members.first.user.username),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeagueInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalLeaderboardTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _globalLeaderboard.length,
      itemBuilder: (context, index) {
        return _buildLeaderboardItem(_globalLeaderboard[index], index + 1);
      },
    );
  }

  Widget _buildLeaderboardItem(UserEntity user, int rank) {
    final isCurrentUser = user.id == _currentUser?.id;
    final isTop3 = rank <= 3;
    final isLastPlace = rank == _globalLeaderboard.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCurrentUser
              ? [const Color(0xFF00E676).withOpacity(0.2), Colors.transparent]
              : [Colors.transparent, Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRankBorderColor(rank),
          width: isTop3 ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 40,
              child: Text(
                _getRankDisplay(rank, isLastPlace),
                style: GoogleFonts.audiowide(
                  fontSize: isTop3 ? 24 : 18,
                  color: _getRankBorderColor(rank),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
            
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _getRankBorderColor(rank).withOpacity(0.5),
                    _getRankBorderColor(rank).withOpacity(0.2),
                  ],
                ),
                border: Border.all(color: _getRankBorderColor(rank), width: 2),
              ),
              child: Center(
                child: Text(
                  user.initials,
                  style: GoogleFonts.audiowide(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${user.correctPredictions}/${user.totalPredictions} doğru',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(user.winRate * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.audiowide(
                          fontSize: 12,
                          color: const Color(0xFF00E676),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Points
            Text(
              '${user.totalPoints}',
              style: GoogleFonts.audiowide(
                fontSize: 20,
                color: const Color(0xFF00E676),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLeagueDetail(LeagueEntity league) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeagueDetailScreen(league: league),
      ),
    );
  }

  void _copyInviteCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invite code copied: $code'),
        backgroundColor: const Color(0xFF00E676),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCreateJoinDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle, color: Color(0xFF00E676)),
              title: Text(
                'Yeni Lig Oluştur',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCreateLeagueDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key, color: Color(0xFF00E676)),
              title: Text(
                'Kodla Katıl',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                _showJoinLeagueDialog();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCreateLeagueDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: Text(
          'Lig Oluştur',
          style: GoogleFonts.audiowide(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Lig adı',
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFF00E676).withOpacity(0.3)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00E676)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: GoogleFonts.inter(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              Navigator.pop(context);
              await _createLeague(controller.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            child: Text('Oluştur', style: GoogleFonts.audiowide(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showJoinLeagueDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: Text(
          'Lige Katıl',
          style: GoogleFonts.audiowide(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: 'Davet kodunu gir',
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFF00E676).withOpacity(0.3)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00E676)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: GoogleFonts.inter(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              Navigator.pop(context);
              await _joinLeague(controller.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            child: Text('Katıl', style: GoogleFonts.audiowide(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _createLeague(String name) async {
    try {
      final socialRepo = getSocialRepository();
      final league = await socialRepo.createLeague(name);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lig oluşturuldu: ${league.inviteCode}'),
            backgroundColor: const Color(0xFF00E676),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _joinLeague(String code) async {
    try {
      final socialRepo = getSocialRepository();
      final league = await socialRepo.joinLeague(code);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Katıldınız: ${league.name}'),
            backgroundColor: const Color(0xFF00E676),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getRankBorderColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return const Color(0xFF00E676).withOpacity(0.3);
  }

  String _getRankDisplay(int rank, bool isLastPlace) {
    if (rank == 1) return '👑';
    if (isLastPlace) return '🤡';
    return '#$rank';
  }
}
