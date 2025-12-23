import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'tournament_model.dart';
import 'tournament_provider.dart';
import 'bracket_painter.dart';

class TournamentScreen extends StatefulWidget {
  final bool showAppBar;

  const TournamentScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  late final TransformationController _transformationController;
  int selectedRoundIndex = 0;
  static const List<String> roundLabels = [
    "Son 32", "Son 16", "Çeyrek", "Yarı", "Final"
  ];

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.value = Matrix4.diagonal3Values(0.8, 0.8, 1.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final provider = Provider.of<TournamentProvider>(context, listen: false);
    provider.setAdminMatchTeams('r32_0', 'Galatasaray', 'Bayern Munih');
    provider.setAdminMatchTeams('r32_1', 'Real Madrid', 'Fenerbahçe');
    provider.setAdminMatchTeams('r32_2', 'Liverpool', 'Milan');
    provider.setAdminMatchTeams('r32_3', 'Arsenal', 'Porto');
    for (int i = 4; i < 16; i++) {
      provider.setAdminMatchTeams('r32_$i', 'Takım A$i', 'Takım B$i');
    }
  }

  void _scrollToRound(int roundIndex) {
    // These must match the layout constants below
    const double matchCardWidth = 180.0;
    const double columnGap = 24.0 + 80.0 + 24.0; // left gap + connector + right gap
    final double x = roundIndex * (matchCardWidth + columnGap);
    // Animate to the calculated offset
    _transformationController.value = Matrix4.diagonal3Values(0.8, 0.8, 1.0)
      ..leftTranslate(-x, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Bracket layout constants
    const double matchCardHeight = 72.0;
    const double matchCardWidth = 180.0;
    const double connectorWidth = 80.0;
    const double columnGap = 24.0 + connectorWidth + 24.0;

    // Round navigation bar
    final roundTabs = Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: roundLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final bool active = selectedRoundIndex == i;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedRoundIndex = i;
              });
              _scrollToRound(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF333333) : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: active ? const Color(0xFF333333) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Text(
                roundLabels[i],
                style: GoogleFonts.lexend(
                  color: active ? Colors.white : const Color(0xFF9cbaa6),
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
    );

    // Bracket content
    final bracketContent = Consumer<TournamentProvider>(
      builder: (context, provider, child) {
        // Group matches by round and sort by roundIndex ascending
        final rounds = <List<TournamentMatch>>[];
        final roundsMap = <int, List<TournamentMatch>>{};
        for (final m in provider.matches) {
          roundsMap.putIfAbsent(m.roundIndex, () => []).add(m);
        }
        final sortedKeys = roundsMap.keys.toList()..sort();
        for (final k in sortedKeys) {
          rounds.add(roundsMap[k]!);
        }

        if (rounds.isEmpty) return const SizedBox.shrink();

        // base matches count (round 0) determines total height
        final baseMatches = rounds.first.length;
        final totalHeight = matchCardHeight * baseMatches;

        // Precompute centers for each round
        final centersPerRound = <List<double>>[];
        for (var r = 0; r < rounds.length; r++) {
          final roundMatches = rounds[r];
          final containerHeight = matchCardHeight * math.pow(2, r);
          final centers = <double>[];
          for (var i = 0; i < roundMatches.length; i++) {
            final top = i * containerHeight;
            centers.add(top + containerHeight / 2 + 12.0); // +12 for vertical padding
          }
          centersPerRound.add(centers);
        }

        return InteractiveViewer(
          constrained: false,
          minScale: 0.25,
          maxScale: 2.0,
          boundaryMargin: const EdgeInsets.all(200),
          transformationController: _transformationController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var r = 0; r < rounds.length; r++) ...[
                    SizedBox(
                      width: matchCardWidth,
                      height: totalHeight,
                      child: Column(
                        children: rounds[r].asMap().entries.map((entry) {
                          final idx = entry.key;
                          final match = entry.value;
                          final containerHeight = matchCardHeight * math.pow(2, r);
                          return Container(
                            height: containerHeight,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: SizedBox(
                                width: matchCardWidth,
                                height: matchCardHeight,
                                child: MatchCard(
                                  match: match,
                                  onTeamSelected: (team) => provider.advanceWinner(match.id, team),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (r < rounds.length - 1) ...[
                      const SizedBox(width: 24),
                      SizedBox(
                        width: connectorWidth,
                        height: totalHeight,
                        child: CustomPaint(
                          painter: BracketPainter(
                            leftCenters: centersPerRound[r],
                            rightCenters: centersPerRound[r + 1],
                            isActive: provider.matches.any((m) => m.roundIndex == r && m.winner != null),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );

    // Main body
    final body = bracketContent;

    if (widget.showAppBar) {
      return Scaffold(
        backgroundColor: const Color(0xFF000000),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000000),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF9cbaa6)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Turnuva Ağacı',
            style: GoogleFonts.lexend(
              color: const Color(0xFF9cbaa6),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Consumer<TournamentProvider>(
              builder: (context, provider, child) => TextButton(
                onPressed: provider.reset,
                child: Text(
                  'Reset',
                  style: GoogleFonts.lexend(
                    color: const Color(0xFF0df259),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: roundTabs,
          ),
        ),
        body: Container(
          color: const Color(0xFF000000),
          child: Column(
            children: [
              // Remove roundTabs from here, already in AppBar
              Expanded(child: bracketContent),
            ],
          ),
        ),
      );
    }

    return Container(color: const Color(0xFF000000), child: body);
  }
}

class MatchCard extends StatelessWidget {
  final TournamentMatch match;
  final Function(String) onTeamSelected;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTeamSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Allow parent SizedBox to control width/height
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF111813),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: match.winner != null ? const Color(0xFF0df259) : Colors.transparent,
          width: 2,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Divide available height between two team rows and a divider
          const double dividerH = 1.0;
          final double rowH = (constraints.maxHeight - dividerH) / 2.0;
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (match.team1 != null) SizedBox(height: rowH, child: _buildTeam(match.team1!, isSelected: match.winner == match.team1)),
              Container(height: dividerH, color: const Color(0xFF333333)),
              if (match.team2 != null) SizedBox(height: rowH, child: _buildTeam(match.team2!, isSelected: match.winner == match.team2)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTeam(String teamName, {required bool isSelected}) {
    return GestureDetector(
      onTap: () => onTeamSelected(teamName),
                  child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0df259).withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                teamName,
                style: GoogleFonts.lexend(
                  color: isSelected ? const Color(0xFF0df259) : const Color(0xFF9cbaa6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF0df259),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}