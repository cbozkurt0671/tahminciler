import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_cup_app/models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final Function(Team) onTeamSelected;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTeamSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111813),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: match.winner != null ? const Color(0xFF0df259) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (match.team1 != null) _buildTeam(match.team1!, isSelected: match.winner == match.team1),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: const Color(0xFF333333),
          ),
          const SizedBox(height: 8),
          if (match.team2 != null) _buildTeam(match.team2!, isSelected: match.winner == match.team2),
        ],
      ),
    );
  }

  Widget _buildTeam(Team team, {required bool isSelected}) {
    return GestureDetector(
      onTap: () => onTeamSelected(team),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0df259).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(team.logoUrl),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                team.name,
                style: GoogleFonts.lexend(
                  color: isSelected ? const Color(0xFF0df259) : const Color(0xFF9cbaa6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF0df259),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}