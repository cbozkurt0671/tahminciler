import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/league_entity.dart';
import '../../data/models/league_message_entity.dart';
import '../../../../core/service_locator.dart';

class LeagueDetailScreen extends StatefulWidget {
  final LeagueEntity league;

  const LeagueDetailScreen({super.key, required this.league});

  @override
  State<LeagueDetailScreen> createState() => _LeagueDetailScreenState();
}

class _LeagueDetailScreenState extends State<LeagueDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LeagueMessageEntity> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMessages();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final socialRepo = getSocialRepository();
      final messages = await socialRepo.getLeagueMessages(widget.league.id);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final authRepo = getAuthRepository();
      final user = await authRepo.getCurrentUser();
      setState(() {
        _currentUserId = user?.id;
      });
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final socialRepo = getSocialRepository();
      await socialRepo.sendLeagueMessage(widget.league.id, _messageController.text.trim());
      _messageController.clear();
      await _loadMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj gönderilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topThree = widget.league.topThree;
    final lastPlace = widget.league.lastPlace;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.league.name.toUpperCase(),
          style: GoogleFonts.audiowide(
            color: const Color(0xFF00E676),
            fontSize: 16,
            letterSpacing: 1.5,
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
            Tab(text: 'SIRALAMAM', icon: Icon(Icons.leaderboard, size: 20)),
            Tab(text: 'DUVAR', icon: Icon(Icons.chat_bubble_outline, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStandingsTab(topThree, lastPlace),
          _buildWallTab(),
        ],
      ),
    );
  }

  Widget _buildStandingsTab(List<LeagueMember> topThree, LeagueMember? lastPlace) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Invite code card
        GestureDetector(
          onTap: () => _copyInviteCode(widget.league.inviteCode),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00E676).withOpacity(0.2),
                  const Color(0xFF00BFA5).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00E676)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.vpn_key, color: Color(0xFF00E676)),
                const SizedBox(width: 12),
                Text(
                  widget.league.inviteCode,
                  style: GoogleFonts.courierPrime(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.copy, color: Color(0xFF00E676), size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kopyalamak için dokun',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white38),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        
        // Standings
        ...widget.league.members.map((member) {
          final isTop3 = topThree.contains(member);
          final isLast = member == lastPlace;
          
          return _buildMemberCard(member, isTop3, isLast);
        }),
      ],
    );
  }

  Widget _buildWallTab() {
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Text(
                    'Henüz mesaj yok\nİlk mesajı sen gönder! 💬',
                    style: GoogleFonts.inter(color: Colors.white38, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageCard(_messages[index]);
                  },
                ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageCard(LeagueMessageEntity message) {
    final isSystemMessage = message.type != LeagueMessageType.chat;
    final isMyMessage = message.senderId == _currentUserId;

    if (isSystemMessage) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _getSystemMessageColor(message.type),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getSystemMessageBorderColor(message.type),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              message.type.icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message.text,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00E676).withOpacity(0.5),
                    const Color(0xFF00E676).withOpacity(0.2),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  message.initials,
                  style: GoogleFonts.audiowide(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMyMessage
                      ? [
                          const Color(0xFF00E676).withOpacity(0.3),
                          const Color(0xFF00BFA5).withOpacity(0.2),
                        ]
                      : [
                          const Color(0xFF1A1F3A),
                          const Color(0xFF0A0E21),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMyMessage
                      ? const Color(0xFF00E676).withOpacity(0.5)
                      : Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMyMessage)
                    Text(
                      message.senderName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF00E676),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (!isMyMessage) const SizedBox(height: 4),
                  Text(
                    message.text,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        border: Border(
          top: BorderSide(color: const Color(0xFF00E676).withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Mesaj yaz...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF0A0E21),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(LeagueMember member, bool isTop3, bool isLast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isTop3
              ? [_getRankBorderColor(member.leagueRank).withOpacity(0.2), Colors.transparent]
              : [Colors.transparent, Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRankBorderColor(member.leagueRank),
          width: isTop3 ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDuelDialog(member),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Rank
                SizedBox(
                  width: 40,
                  child: Text(
                    _getRankDisplay(member.leagueRank, isLast),
                    style: GoogleFonts.audiowide(
                      fontSize: isTop3 ? 24 : 18,
                      color: _getRankBorderColor(member.leagueRank),
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
                        _getRankBorderColor(member.leagueRank).withOpacity(0.5),
                        _getRankBorderColor(member.leagueRank).withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(color: _getRankBorderColor(member.leagueRank), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      member.user.initials,
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
                        member.user.username,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildWeeklyChange(member.weeklyChange),
                    ],
                  ),
                ),
                
                // Points
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${member.leaguePoints}',
                      style: GoogleFonts.audiowide(
                        fontSize: 20,
                        color: const Color(0xFF00E676),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (member.user.id != _currentUserId)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          '⚔️ DÜELLO',
                          style: GoogleFonts.audiowide(
                            fontSize: 9,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyChange(int change) {
    if (change == 0) {
      return Text(
        '—',
        style: GoogleFonts.inter(fontSize: 12, color: Colors.white38),
      );
    }
    
    final isPositive = change > 0;
    return Row(
      children: [
        Text(
          isPositive ? '⬆️' : '⬇️',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}$change',
          style: GoogleFonts.audiowide(
            fontSize: 12,
            color: isPositive ? const Color(0xFF00E676) : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showDuelDialog(LeagueMember member) {
    if (member.user.id == _currentUserId) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: Row(
          children: [
            const Text('⚔️', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Text(
              'DÜELLO',
              style: GoogleFonts.audiowide(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${member.user.username} ile düelloya gir!',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.2),
                    Colors.red.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '💰 ',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        '50 PUAN',
                        style: GoogleFonts.audiowide(
                          color: const Color(0xFF00E676),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Maç: İngiltere vs Fransa',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: GoogleFonts.inter(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _createDuel(member);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'DÜELLOYA DAVET ET',
              style: GoogleFonts.audiowide(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createDuel(LeagueMember member) async {
    try {
      final socialRepo = getSocialRepository();
      await socialRepo.createDuel(
        opponentId: member.user.id,
        matchId: 'match_1', // Mock
        stakeAmount: 50,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚔️ ${member.user.username} düelloya davet edildi!'),
            backgroundColor: Colors.red,
          ),
        );
      }

      await _loadMessages(); // Refresh to show system message
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _copyInviteCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Davet kodu kopyalandı: $code'),
        backgroundColor: const Color(0xFF00E676),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  Color _getSystemMessageColor(LeagueMessageType type) {
    switch (type) {
      case LeagueMessageType.jokerUsed:
        return const Color(0xFFFFD700).withOpacity(0.1);
      case LeagueMessageType.duelChallenge:
        return Colors.red.withOpacity(0.1);
      case LeagueMessageType.duelResult:
        return const Color(0xFF00E676).withOpacity(0.1);
      default:
        return Colors.blue.withOpacity(0.1);
    }
  }

  Color _getSystemMessageBorderColor(LeagueMessageType type) {
    switch (type) {
      case LeagueMessageType.jokerUsed:
        return const Color(0xFFFFD700);
      case LeagueMessageType.duelChallenge:
        return Colors.red;
      case LeagueMessageType.duelResult:
        return const Color(0xFF00E676);
      default:
        return Colors.blue;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Şimdi';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}dk önce';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}s önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}g önce';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }
}
