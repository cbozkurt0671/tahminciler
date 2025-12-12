import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../data/models/match_model.dart';
import '../../data/models/group_standing.dart';

/// Group detail screen showing standings and user performance
class GroupDetailScreen extends StatelessWidget {
  final String groupName;
  final List<MatchModel> matches;

  const GroupDetailScreen({
    super.key,
    required this.groupName,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    final standings = DummyMatchData.getStandingsForGroup(groupName);
    final userPerformance = _calculateUserPerformance();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '$groupName Detayı',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Performance Card
            _buildUserPerformanceCard(userPerformance),
            
            const SizedBox(height: 24),
            
            // Standings Section
            _buildStandingsSection(standings),
          ],
        ),
      ),
    );
  }

  Map<String, int> _calculateUserPerformance() {
    // Mock calculation - in real app, would check user's actual predictions
    int totalPoints = 0;
    int pointsAtRisk = 0;
    int correctPredictions = 0;
    int wrongPredictions = 0;

    for (final match in matches) {
      // Mock: assume user made predictions on some matches
      // In reality, check against stored user predictions
      if (match.isLive || match.homeScore != null) {
        // Match has a result - calculate points
        final mockCorrect = (match.id.hashCode % 3) == 0; // Mock logic
        if (mockCorrect) {
          totalPoints += 25; // Mock points for correct prediction
          correctPredictions++;
        } else {
          wrongPredictions++;
        }
      } else {
        // Upcoming match - points at risk
        pointsAtRisk += 25; // Mock points
      }
    }

    return {
      'totalPoints': totalPoints,
      'pointsAtRisk': pointsAtRisk,
      'correct': correctPredictions,
      'wrong': wrongPredictions,
    };
  }

  Widget _buildUserPerformanceCard(Map<String, int> performance) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00E676).withOpacity(0.15),
            const Color(0xFF00B8D4).withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00E676).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFF00E676),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Bu Gruptaki Skorun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Points Display
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kazanılan',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${performance['totalPoints']} Puan',
                      style: const TextStyle(
                        color: Color(0xFF00E676),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.1),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beklemede',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${performance['pointsAtRisk']} Puan',
                      style: TextStyle(
                        color: Colors.orange[400],
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Doğru',
                  performance['correct']!,
                  const Color(0xFF00E676),
                ),
                _buildStatItem(
                  'Yanlış',
                  performance['wrong']!,
                  Colors.red[400]!,
                ),
                _buildStatItem(
                  'Oran',
                  performance['correct']! + performance['wrong']! > 0
                      ? ((performance['correct']! / (performance['correct']! + performance['wrong']!)) * 100).round()
                      : 0,
                  Colors.blue[400]!,
                  suffix: '%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color, {String suffix = ''}) {
    return Column(
      children: [
        Text(
          '$value$suffix',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStandingsSection(List<GroupStanding> standings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(
              Icons.leaderboard,
              color: Color(0xFF00E676),
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Puan Durumu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '#',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Text(
                  'Takım',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'O',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'G',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'A',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 45,
                child: Text(
                  'P',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Table Rows
        ...standings.asMap().entries.map((entry) {
          final index = entry.key;
          final standing = entry.value;
          final isQualified = index < 2; // Top 2 qualify
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: index.isEven
                  ? AppColors.cardSurface
                  : AppColors.cardSurface.withOpacity(0.5),
              border: Border(
                left: BorderSide(
                  color: isQualified
                      ? const Color(0xFF00E676)
                      : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                // Position
                SizedBox(
                  width: 30,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isQualified
                          ? const Color(0xFF00E676)
                          : Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                
                // Team
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          standing.flagUrl,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 24,
                              height: 24,
                              color: Colors.white.withOpacity(0.1),
                              child: const Icon(
                                Icons.flag,
                                size: 12,
                                color: Colors.white54,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          standing.teamName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Played
                SizedBox(
                  width: 35,
                  child: Text(
                    '${standing.played}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                // Won
                SizedBox(
                  width: 35,
                  child: Text(
                    '${standing.won}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                // Goal Difference
                SizedBox(
                  width: 35,
                  child: Text(
                    standing.goalDifference > 0
                        ? '+${standing.goalDifference}'
                        : '${standing.goalDifference}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: standing.goalDifference > 0
                          ? const Color(0xFF00E676)
                          : standing.goalDifference < 0
                              ? Colors.red[400]
                              : Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Points
                SizedBox(
                  width: 45,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${standing.points}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF00E676),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        
        // Legend at bottom
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF00E676),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Üst Tura Çıkan Takımlar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
