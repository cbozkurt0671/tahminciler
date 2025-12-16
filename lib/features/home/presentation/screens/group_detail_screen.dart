import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_cup_app/features/home/data/group_repository_impl.dart';
import 'package:world_cup_app/features/home/domain/entities/group.dart';
import 'package:world_cup_app/features/home/domain/entities/member.dart';
import 'package:world_cup_app/core/widgets/beta_avatar.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupName;
  final String? groupId;
  const GroupDetailScreen({Key? key, required this.groupName, this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = GroupRepositoryImpl();
    final future = groupId != null ? repo.fetchGroupById(groupId!) : repo.fetchGroupByName(groupName);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(
        children: [
          // Background FX: Blurred blobs
          Positioned(
            top: -100,
            left: MediaQuery.of(context).size.width / 2 - 180,
            child: _BlurredBlob(
              diameter: 360,
              color: const Color(0xFF0df259).withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _BlurredBlob(
              diameter: 220,
              color: const Color(0xFF0df259).withOpacity(0.12),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                _CustomAppBar(groupName: groupName),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (_) => false,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: FutureBuilder<Group>(
                          future: future,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            }
                            final group = snapshot.data ?? Group.dummy(groupName);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 8),
                                _HeroSection(group: group),
                                const SizedBox(height: 28),
                                _StatsGrid(group: group),
                                const SizedBox(height: 32),
                                _LeaderboardList(leaderboard: group.leaderboard),
                                const SizedBox(height: 120), // For bottom bar spacing
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Bottom Bar
          _FloatingBottomBar(),
        ],
      ),
    );
  }
}

// --- Blurred Blob Widget ---
class _BlurredBlob extends StatelessWidget {
  final double diameter;
  final Color color;
  const _BlurredBlob({required this.diameter, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: const SizedBox(),
      ),
    );
  }
}

// --- Custom AppBar ---
class _CustomAppBar extends StatelessWidget {
  final String groupName;
  const _CustomAppBar({required this.groupName});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Center(
              child: AnimatedOpacity(
                opacity: 1.0, // TODO: Fade in on scroll
                duration: const Duration(milliseconds: 400),
                child: Text(
                  groupName,
                  style: GoogleFonts.lexend(
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// --- Hero Section ---
class _HeroSection extends StatelessWidget {
  final Group? group;
  const _HeroSection({this.group});
  @override
  Widget build(BuildContext context) {
    final displayName = group?.name ?? 'Tahminciler Grubu';
    final admin = group?.adminName ?? 'Burak';
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.13), width: 2),
                color: const Color(0xFF111111),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0df259).withOpacity(0.18),
                    blurRadius: 32,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: BetaAvatar(
                imagePath: 'assets/images/league_logos/group_logo.png',
                name: displayName,
                size: 96,
                borderWidth: 0,
                verified: true,
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: const Icon(Icons.verified, color: Color(0xFF0df259), size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          displayName,
          style: GoogleFonts.lexend(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.13), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, color: Color(0xFF0df259), size: 16),
              const SizedBox(width: 6),
              Text(
                'Admin: $admin',
                style: GoogleFonts.lexend(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _OverlappingAvatars(members: group?.members),
            const SizedBox(width: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0df259), width: 1.5),
                foregroundColor: const Color(0xFF0df259),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                textStyle: GoogleFonts.lexend(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              onPressed: () {},
              child: const Text('Invite'),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Overlapping Avatars ---
class _OverlappingAvatars extends StatelessWidget {
  final List<Member>? members;
  const _OverlappingAvatars({this.members});
  @override
  Widget build(BuildContext context) {
    final List<Member> shown = members != null && members!.isNotEmpty
        ? members!.take(4).toList()
        : [
            Member(id: 'd1', name: 'Ali', avatarUrl: ''),
            Member(id: 'd2', name: 'Ayşe', avatarUrl: ''),
            Member(id: 'd3', name: 'Can', avatarUrl: ''),
            Member(id: 'd4', name: 'Deniz', avatarUrl: ''),
          ];

    return SizedBox(
      width: 80,
      height: 36,
      child: Stack(
        children: List.generate(shown.length, (i) {
          final m = shown[i];
          return Positioned(
            left: i * 22.0,
            child: BetaAvatar(
              imagePath: m.avatarUrl,
              name: m.name,
              size: 36,
              borderWidth: 0,
            ),
          );
        }),
      ),
    );
  }
}

// --- Stats Grid ---
class _StatsGrid extends StatelessWidget {
  final Group? group;
  const _StatsGrid({this.group});
  @override
  Widget build(BuildContext context) {
    final stats = group?.stats ?? {'points': '1,240', 'accuracy': '78%', 'members': '17'};
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total Points',
            value: stats['points'] ?? '—',
            icon: Icons.emoji_events_outlined,
            accent: Colors.white,
          ),
        ),
        Expanded(
          child: _StatCard(
            label: 'Active Members',
            value: stats['members'] ?? '—',
            icon: Icons.group_outlined,
            accent: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color accent;
  final bool neon;
  const _StatCard({required this.label, required this.value, required this.icon, required this.accent, this.neon = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: neon
            ? [
                BoxShadow(
                  color: accent.withOpacity(0.38),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lexend(
              color: accent,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              shadows: neon
                  ? [
                      Shadow(
                        color: accent.withOpacity(0.7),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lexend(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Podium Section ---
class _PodiumSection extends StatelessWidget {
  final List<Member>? podium;
  const _PodiumSection({this.podium});
  @override
  Widget build(BuildContext context) {
    final p = podium != null && podium!.length >= 3
        ? podium!
        : [
            Member(id: 'u2', name: 'Ayşe', avatarUrl: 'assets/images/team_logos/user2.png', points: 1120),
            Member(id: 'u1', name: 'Burak', avatarUrl: 'assets/images/team_logos/user1.png', points: 1240),
            Member(id: 'u3', name: 'Mehmet', avatarUrl: 'assets/images/team_logos/user3.png', points: 1080),
          ];
    final podiumUsers = [
      _PodiumUser(rank: 2, name: p[0].name, points: p[0].points, avatar: p[0].avatarUrl),
      _PodiumUser(rank: 1, name: p[1].name, points: p[1].points, avatar: p[1].avatarUrl),
      _PodiumUser(rank: 3, name: p[2].name, points: p[2].points, avatar: p[2].avatarUrl),
    ];
    return SizedBox(
      height: 120,
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Podium bases
            Positioned(
              left: 0,
              bottom: 0,
              child: _PodiumBase(height: 54, color: Colors.white.withOpacity(0.08)),
            ),
            Positioned(
              left: 80,
              bottom: 0,
              child: _PodiumBase(height: 80, color: const Color(0xFF0df259).withOpacity(0.13)),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _PodiumBase(height: 40, color: Colors.white.withOpacity(0.08)),
            ),
            // Avatars
            Positioned(
              left: 0,
              bottom: 54,
              child: _PodiumAvatar(user: podiumUsers[0], size: 54),
            ),
            Positioned(
              left: 80,
              bottom: 80,
              child: _PodiumAvatar(user: podiumUsers[1], size: 72, crown: true),
            ),
            Positioned(
              right: 0,
              bottom: 40,
              child: _PodiumAvatar(user: podiumUsers[2], size: 48),
            ),
          ],
        ),
      ),
    );
  }
}

class _PodiumUser {
  final int rank;
  final String name;
  final int points;
  final String avatar;
  _PodiumUser({required this.rank, required this.name, required this.points, required this.avatar});
}

class _PodiumBase extends StatelessWidget {
  final double height;
  final Color color;
  const _PodiumBase({required this.height, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _PodiumAvatar extends StatelessWidget {
  final _PodiumUser user;
  final double size;
  final bool crown;
  const _PodiumAvatar({required this.user, required this.size, this.crown = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (crown)
          Icon(Icons.emoji_events, color: const Color(0xFF0df259), size: 28, shadows: [
            Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
          ]),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: crown ? const Color(0xFF0df259) : Colors.white.withOpacity(0.13),
              width: crown ? 3 : 2,
            ),
            boxShadow: crown
                ? [
                    BoxShadow(
                      color: const Color(0xFF0df259).withOpacity(0.22),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: BetaAvatar(
            imagePath: user.avatar,
            name: user.name,
            size: size,
            borderWidth: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.name,
          style: GoogleFonts.lexend(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Text(
          '${user.points} pts',
          style: GoogleFonts.lexend(
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// --- Leaderboard List ---
class _LeaderboardList extends StatelessWidget {
  final List<Member>? leaderboard;
  const _LeaderboardList({this.leaderboard});
  @override
  Widget build(BuildContext context) {
    final list = leaderboard != null && leaderboard!.isNotEmpty
        ? leaderboard!
        : [
            Member(id: 'u4', name: 'Zeynep', avatarUrl: 'assets/images/team_logos/user4.png', points: 1050),
            Member(id: 'u5', name: 'Sen', avatarUrl: 'assets/images/team_logos/user5.png', points: 1020),
            Member(id: 'u6', name: 'Ali', avatarUrl: 'assets/images/team_logos/user6.png', points: 990),
          ];
    return Column(
      children: list.asMap().entries.map((e) {
        final idx = e.key + 1;
        final m = e.value;
        return _LeaderboardRowFromMember(member: m, rank: idx, isYou: m.name == 'Sen');
      }).toList(),
    );
  }
}

class _LeaderboardRowFromMember extends StatelessWidget {
  final Member member;
  final int rank;
  final bool isYou;
  const _LeaderboardRowFromMember({required this.member, required this.rank, this.isYou = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isYou ? const Color(0xFF0df259).withOpacity(0.08) : const Color(0xFF111111),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isYou ? const Color(0xFF0df259) : Colors.white.withOpacity(0.08),
          width: isYou ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            rank.toString(),
            style: GoogleFonts.lexend(
              color: isYou ? const Color(0xFF0df259) : Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: BetaAvatar(
              imagePath: member.avatarUrl,
              name: member.name,
              size: 36,
              borderWidth: 0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: GoogleFonts.lexend(
                        color: isYou ? const Color(0xFF0df259) : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (isYou)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0df259),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'You',
                          style: GoogleFonts.lexend(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    // small form indicators - random for now
                    Container(margin: const EdgeInsets.only(right: 3), width: 7, height: 7, decoration: BoxDecoration(color: const Color(0xFF0df259), shape: BoxShape.circle)),
                    Container(margin: const EdgeInsets.only(right: 3), width: 7, height: 7, decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                    Container(margin: const EdgeInsets.only(right: 3), width: 7, height: 7, decoration: BoxDecoration(color: const Color(0xFF0df259), shape: BoxShape.circle)),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${member.points} pts',
            style: GoogleFonts.lexend(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardUser {
  final int rank;
  final String name;
  final int points;
  final String avatar;
  final bool isYou;
  final List<bool> form; // true: win, false: loss
  _LeaderboardUser({required this.rank, required this.name, required this.points, required this.avatar, required this.isYou, required this.form});
}

class _LeaderboardRow extends StatelessWidget {
  final _LeaderboardUser user;
  const _LeaderboardRow({required this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: user.isYou ? const Color(0xFF0df259).withOpacity(0.08) : const Color(0xFF111111),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: user.isYou ? const Color(0xFF0df259) : Colors.white.withOpacity(0.08),
          width: user.isYou ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            user.rank.toString(),
            style: GoogleFonts.lexend(
              color: user.isYou ? const Color(0xFF0df259) : Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: BetaAvatar(
              imagePath: user.avatar,
              size: 36,
              borderWidth: 0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.lexend(
                        color: user.isYou ? const Color(0xFF0df259) : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (user.isYou)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0df259),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'You',
                          style: GoogleFonts.lexend(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    ...user.form.map((win) => Container(
                          margin: const EdgeInsets.only(right: 3),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: win ? const Color(0xFF0df259) : Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${user.points} pts',
            style: GoogleFonts.lexend(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Floating Bottom Bar ---
class _FloatingBottomBar extends StatelessWidget {
  final String? recentMessage;
  const _FloatingBottomBar({this.recentMessage});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.only(top: 18, bottom: 12, left: 18, right: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF111111).withOpacity(0.98),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification Pill
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
                    ),
                    child: Text(
                      recentMessage ?? 'Burak sent a message...',
                      style: GoogleFonts.lexend(
                        color: Colors.white.withOpacity(0.92),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // Main Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0df259),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: GoogleFonts.lexend(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 38,
                              height: 24,
                              child: _TypingAvatars(),
                            ),
                            const SizedBox(width: 12),
                            const Text('OPEN CHAT'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingAvatars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatars = [
      'assets/images/team_logos/user2.png',
      'assets/images/team_logos/user3.png',
    ];
    return SizedBox(
      width: 38,
      height: 24,
      child: Stack(
        children: List.generate(avatars.length, (i) {
          return Positioned(
            left: i * 16.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: ClipOval(
                child: Image.asset(
                  avatars[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
