import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:world_cup_app/features/tournament/presentation/providers/tournament_provider.dart';
import 'package:world_cup_app/features/tournament/presentation/widgets/bracket_connector.dart';
import 'package:world_cup_app/features/tournament/presentation/widgets/match_card.dart';
import 'package:world_cup_app/models/match.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TournamentProvider(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF9cbaa6)),
            onPressed: () => Navigator.of(context).pop(),
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
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<TournamentProvider>(
                builder: (context, provider, child) => InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 2.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRound(provider.matches.where((m) => m.roundIndex == 0).toList(), provider),
                          const SizedBox(width: 50),
                          BracketConnector(isActive: provider.matches.any((m) => m.roundIndex == 0 && m.winner != null)),
                          const SizedBox(width: 50),
                          _buildRound(provider.matches.where((m) => m.roundIndex == 1).toList(), provider),
                          const SizedBox(width: 50),
                          BracketConnector(isActive: provider.matches.any((m) => m.roundIndex == 1 && m.winner != null)),
                          const SizedBox(width: 50),
                          _buildRound(provider.matches.where((m) => m.roundIndex == 2).toList(), provider),
                          const SizedBox(width: 50),
                          BracketConnector(isActive: provider.matches.any((m) => m.roundIndex == 2 && m.winner != null)),
                          const SizedBox(width: 50),
                          _buildRound(provider.matches.where((m) => m.roundIndex == 3).toList(), provider),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF111813),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement save predictions
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tahminler kaydedildi!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0df259),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Tahminleri Kaydet',
                    style: GoogleFonts.lexend(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                // TODO: Implement zoom in
              },
              backgroundColor: const Color(0xFF0df259),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                // TODO: Implement zoom out
              },
              backgroundColor: const Color(0xFF0df259),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRound(List<Match> roundMatches, TournamentProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: roundMatches.map((match) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: MatchCard(
          match: match,
          onTeamSelected: (team) => provider.selectWinner(match, team),
        ),
      )).toList(),
    );
  }
}