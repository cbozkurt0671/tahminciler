import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_cup_app/core/widgets/beta_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color kBackground = Color(0xFF000000);
  static const Color kSurface = Color(0xFF121212);
  static const Color kAccent = Color(0xFF0df259);
  static const Color kSubtitle = Color(0xFF9ca3af);

  final List<_Activity> _activities = [
    _Activity(
      league: 'Süper Lig',
      match: 'Galatasaray vs Fenerbahçe',
      homeLogo: 'assets/images/team_logos/user1.png',
      awayLogo: 'assets/images/team_logos/user2.png',
      prediction: 'Ev Sahibi (2-1)',
      result: '2-1',
      points: 15,
      won: true,
    ),
    _Activity(
      league: 'Premier League',
      match: 'Liverpool vs Chelsea',
      homeLogo: 'assets/images/team_logos/user3.png',
      awayLogo: 'assets/images/team_logos/user4.png',
      prediction: 'Beraberlik (1-1)',
      result: '0-1',
      points: 0,
      won: false,
    ),
    _Activity(
      league: 'LaLiga',
      match: 'Real Madrid vs Barcelona',
      homeLogo: 'assets/images/team_logos/user5.png',
      awayLogo: 'assets/images/team_logos/user6.png',
      prediction: 'Deplasman (0-2)',
      result: '0-2',
      points: 20,
      won: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroSection(),
                    const SizedBox(height: 18),
                    _buildStatsRow(),
                    const SizedBox(height: 18),
                    _buildActivitySection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.transparent,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: SizedBox()),
          Text(
            'Profil',
            style: GoogleFonts.lexend(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kAccent, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: kAccent.withOpacity(0.22),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: BetaAvatar(
                    imagePath: 'assets/images/team_logos/user1.png',
                    name: 'Striker99',
                    size: 96,
                    borderWidth: 0,
                    verified: true,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Striker99',
                      style: GoogleFonts.lexend(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          textStyle: GoogleFonts.lexend(fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Profili Düzenle'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(icon: Icons.emoji_events_outlined, value: '1250', label: 'Puan'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(icon: Icons.leaderboard, value: '#42', label: 'Sıralama'),
        ),
      ],
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Son Aktiviteler',
          style: GoogleFonts.lexend(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: _activities.map((a) => _ActivityCard(activity: a)).toList(),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    // Return the card container itself. Callers who need flexible layout
    // (e.g. placing cards in a Row with equal spacing) should wrap this
    // widget with Expanded or Flexible. This avoids nested Expanded widgets
    // causing ParentDataWidget conflicts.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lexend(color: const Color(0xFF9ca3af), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Activity {
  final String league;
  final String match;
  final String homeLogo;
  final String awayLogo;
  final String prediction;
  final String result;
  final int points;
  final bool won;

  _Activity({required this.league, required this.match, required this.homeLogo, required this.awayLogo, required this.prediction, required this.result, required this.points, required this.won});
}

class _ActivityCard extends StatelessWidget {
  final _Activity activity;
  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    final Color kAccent = const Color(0xFF0df259);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          // Decorative blob top-right
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [kAccent.withOpacity(0.14), Colors.transparent]),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  // overlapping logos
                  SizedBox(
                    width: 56,
                    height: 36,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: BetaAvatar(
                            imagePath: activity.homeLogo,
                            name: activity.league, // use league as label for team logos fallback
                            size: 36,
                            borderWidth: 0,
                          ),
                        ),
                        Positioned(
                          left: 22,
                          child: BetaAvatar(
                            imagePath: activity.awayLogo,
                            name: activity.league,
                            size: 36,
                            borderWidth: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.league, style: GoogleFonts.lexend(color: const Color(0xFF9ca3af), fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(activity.match, style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(won: activity.won),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tahmin: ${activity.prediction}', style: GoogleFonts.lexend(color: const Color(0xFF9ca3af), fontSize: 13)),
                        const SizedBox(height: 6),
                        Text('Skor: ${activity.result}', style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: activity.won ? kAccent : Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      activity.won ? '+${activity.points} Puan' : '0 Puan',
                      style: GoogleFonts.lexend(color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool won;
  const _StatusBadge({required this.won});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: won ? const Color(0xFF0df259) : Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        won ? 'KAZANDI' : 'KAYBETTİ',
        style: GoogleFonts.lexend(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}
