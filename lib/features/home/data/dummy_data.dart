import 'models/match_model.dart';
import 'models/prediction_question.dart';
import 'models/group_standing.dart';

/// Dummy data for World Cup 2026 matches (USA, Canada, Mexico)
/// Expanded to 20+ matches across 4 days
class DummyMatchData {
  static List<MatchModel> getMatches() {
    return [
      // ============================================
      // DAY 1: June 12, 2026 (Opening Day)
      // ============================================
      
      // Live Match 1 - Manchester City vs Liverpool (HERO)
      MatchModel(
        id: '1',
        homeTeam: 'Manchester City',
        awayTeam: 'Liverpool',
        homeTeamId: 17,  // Man City
        awayTeamId: 20,  // Liverpool
        homeFlagUrl: 'https://flagcdn.com/h80/us.png',
        awayFlagUrl: 'https://flagcdn.com/h80/mx.png',
        matchTime: '45:00',
        matchDate: '12 Haz, 2026',
        city: 'Manchester',
        stadium: 'Etihad Stadium',
        group: 'Premier League',
        category: 'Premier League',
        isLive: true,
        liveMatchTime: "67'", // Changed to actual minute
        status: 'inprogress',
        isFavorite: true,
        isHero: true,
        homeScore: 2,
        awayScore: 1,
        homeScorers: ['Pulisic 23\'', 'Reyna 38\''],
        awayScorers: ['Lozano 15\''],
        userPredictions: {
          '1_goals': 'EVET',
          '1_btts': 'EVET',
        },
        questions: [
          const PredictionQuestion(
            id: 'q_var_check',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_bicycle_kick',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_late_goal',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_coach_yellow',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_post_hit',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
        ],
      ),
      
      // Match 2 - June 12
      MatchModel(
        id: '2',
        homeTeam: 'Arsenal',
        awayTeam: 'Chelsea',
        homeTeamId: 21,  // Arsenal
        awayTeamId: 19,  // Chelsea
        homeFlagUrl: 'https://flagcdn.com/h80/ca.png',
        awayFlagUrl: 'https://flagcdn.com/h80/ie.png',
        matchTime: '16:00',
        matchDate: '12 Haz, 2026',
        city: 'London',
        stadium: 'Emirates Stadium',
        group: 'Premier League',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_possession_70',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_pitch_invader',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_goalkeeper_adventure',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_jersey_rip',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_var_check_2',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
        ],
      ),

      // Match 3 - June 12 (HERO - Live)
      MatchModel(
        id: '3',
        homeTeam: 'Barcelona',
        awayTeam: 'Real Madrid',
        homeTeamId: 2829,  // Barcelona
        awayTeamId: 2817,  // Real Madrid
        homeFlagUrl: 'https://flagcdn.com/h80/br.png',
        awayFlagUrl: 'https://flagcdn.com/h80/jp.png',
        matchTime: '68:30',
        matchDate: '12 Haz, 2026',
        city: 'Barcelona',
        stadium: 'Camp Nou',
        group: 'La Liga',
        isLive: true,
        isFavorite: false,
        isHero: true,
        homeScore: 3,
        awayScore: 1,
        homeScorers: ['Neymar 22\'', 'Vinicius 45\'', 'Richarlison 68\''],
        awayScorers: ['Kubo 55\''],
        questions: [
          const PredictionQuestion(
            id: 'q_coach_yellow_3',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_post_hit_3',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_bicycle_kick_3',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_late_drama',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_jersey_rip_3',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
        ],
      ),

      // Match 4 - June 12
      MatchModel(
        id: '4',
        homeTeam: 'Bayern Munich',
        awayTeam: 'Borussia Dortmund',
        homeTeamId: 2672,  // Bayern
        awayTeamId: 2673,  // Dortmund
        homeFlagUrl: 'https://flagcdn.com/h80/fr.png',
        awayFlagUrl: 'https://flagcdn.com/h80/au.png',
        matchTime: '19:00',
        matchDate: '12 Haz, 2026',
        city: 'Munich',
        stadium: 'AT&T Stadium',
        group: 'D Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_pitch_invader_4',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_var_drama',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_possession_70_4',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_goalkeeper_run',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_post_crossbar',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
        ],
      ),

      // Match 5 - June 12
      MatchModel(
        id: '5',
        homeTeam: 'Juventus',
        awayTeam: 'Inter Milan',
        homeTeamId: 2697,  // Juventus
        awayTeamId: 2692,  // Inter
        homeFlagUrl: 'https://flagcdn.com/h80/es.png',
        awayFlagUrl: 'https://flagcdn.com/h80/cr.png',
        matchTime: '22:00',
        matchDate: '12 Haz, 2026',
        city: 'Turin',
        stadium: 'NRG Stadium',
        group: 'E Grubu',
        isLive: false,
        isFavorite: true,
        questions: [
          const PredictionQuestion(
            id: 'q_bicycle_attempt',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_coach_yellow_5',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_stoppage_goal',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_torn_kit',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_post_drama',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
        ],
      ),

      // ============================================
      // DAY 2: June 13, 2026
      // ============================================
      
      // Match 6 - June 13 (HERO - Live)
      MatchModel(
        id: '6',
        homeTeam: 'PSG',
        awayTeam: 'Manchester United',
        homeTeamId: 1644,  // PSG
        awayTeamId: 18,    // Man United
        homeFlagUrl: 'https://flagcdn.com/h80/ar.png',
        awayFlagUrl: 'https://flagcdn.com/h80/kr.png',
        matchTime: '22:15',
        matchDate: '13 Haz, 2026',
        city: 'Atlanta',
        stadium: 'Mercedes-Benz Stadium',
        group: 'F Grubu',
        isLive: true,
        isFavorite: true,
        isHero: true,
        homeScore: 1,
        awayScore: 1,
        homeScorers: ['Messi 35\''],
        awayScorers: ['Son 67\''],
        questions: [
          const PredictionQuestion(
            id: 'q_var_review',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_possession_control',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_fan_invades',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_keeper_rush',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_woodwork_hit',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
        ],
      ),

      // Match 7 - June 13
      MatchModel(
        id: '7',
        homeTeam: 'Almanya',
        awayTeam: 'Fas',
        homeFlagUrl: 'https://flagcdn.com/h80/de.png',
        awayFlagUrl: 'https://flagcdn.com/h80/ma.png',
        matchTime: '13:00',
        matchDate: '13 Haz, 2026',
        city: 'Kansas City',
        stadium: 'Arrowhead Stadium',
        group: 'A Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_acrobatic_try',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_manager_booking',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_injury_time_drama',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_kit_damage',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_pitch_invasion_7',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
        ],
      ),

      // Match 8 - June 13
      MatchModel(
        id: '8',
        homeTeam: 'Hollanda',
        awayTeam: 'Ekvador',
        homeFlagUrl: 'https://flagcdn.com/h80/nl.png',
        awayFlagUrl: 'https://flagcdn.com/h80/ec.png',
        matchTime: '16:00',
        matchDate: '13 Haz, 2026',
        city: 'Seattle',
        stadium: 'Lumen Field',
        group: 'B Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_var_check_8',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_ball_possession',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_crossbar_bounce',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_gk_adventure',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_overhead_kick',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
        ],
      ),

      // Match 9 - June 13
      MatchModel(
        id: '9',
        homeTeam: 'İngiltere',
        awayTeam: 'İran',
        homeFlagUrl: 'https://flagcdn.com/h80/gb-eng.png',
        awayFlagUrl: 'https://flagcdn.com/h80/ir.png',
        matchTime: '19:00',
        matchDate: '13 Haz, 2026',
        city: 'Boston',
        stadium: 'Gillette Stadium',
        group: 'C Grubu',
        isLive: false,
        isFavorite: true,
        questions: [
          const PredictionQuestion(
            id: 'q_var_9',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_post_9',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_bicycle_9',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_coach_9',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_jersey_9',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
        ],
      ),

      // Match 10 - June 13
      MatchModel(
        id: '10',
        homeTeam: 'Belçika',
        awayTeam: 'Kanada',
        homeFlagUrl: 'https://flagcdn.com/h80/be.png',
        awayFlagUrl: 'https://flagcdn.com/h80/ca.png',
        matchTime: '22:00',
        matchDate: '13 Haz, 2026',
        city: 'Philadelphia',
        stadium: 'Lincoln Financial Field',
        group: 'D Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_possession_10',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_invader_10',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_keeper_10',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_late_10',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_var_10',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
        ],
      ),

      // ============================================
      // DAY 3: June 14, 2026
      // ============================================
      
      // Match 11 - June 14 (HERO)
      MatchModel(
        id: '11',
        homeTeam: 'Meksika',
        awayTeam: 'Polonya',
        homeFlagUrl: 'https://flagcdn.com/h80/mx.png',
        awayFlagUrl: 'https://flagcdn.com/h80/pl.png',
        matchTime: '19:00',
        matchDate: '14 Haz, 2026',
        city: 'Mexico City',
        stadium: 'Estadio Azteca',
        group: 'E Grubu',
        isLive: false,
        isFavorite: true,
        isHero: true,
        questions: [
          const PredictionQuestion(
            id: 'q_bicycle_11',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_coach_11',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_late_11',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_post_11',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_invader_11',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
        ],
      ),

      // Match 12 - June 14
      MatchModel(
        id: '12',
        homeTeam: 'Portekiz',
        awayTeam: 'Gana',
        homeFlagUrl: 'https://flagcdn.com/h80/pt.png',
        awayFlagUrl: 'https://flagcdn.com/h80/gh.png',
        matchTime: '13:00',
        matchDate: '14 Haz, 2026',
        city: 'San Francisco',
        stadium: 'Levi\'s Stadium',
        group: 'F Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_var_12',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_possession_12',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_jersey_12',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_keeper_12',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_post_12',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
        ],
      ),

      // Match 13 - June 14
      MatchModel(
        id: '13',
        homeTeam: 'Uruguay',
        awayTeam: 'Güney Kore',
        homeFlagUrl: 'https://flagcdn.com/h80/uy.png',
        awayFlagUrl: 'https://flagcdn.com/h80/kr.png',
        matchTime: '16:00',
        matchDate: '14 Haz, 2026',
        city: 'Denver',
        stadium: 'Empower Field',
        group: 'A Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_bicycle_13',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_coach_13',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_late_13',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_invader_13',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_var_13',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
        ],
      ),

      // Match 14 - June 14
      MatchModel(
        id: '14',
        homeTeam: 'İsviçre',
        awayTeam: 'Kamerun',
        homeFlagUrl: 'https://flagcdn.com/h80/ch.png',
        awayFlagUrl: 'https://flagcdn.com/h80/cm.png',
        matchTime: '19:00',
        matchDate: '14 Haz, 2026',
        city: 'Vancouver',
        stadium: 'BC Place',
        group: 'B Grubu',
        isLive: false,
        isFavorite: true,
        questions: [
          const PredictionQuestion(
            id: 'q_possession_14',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_post_14',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_keeper_14',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_jersey_14',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_var_14',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
        ],
      ),

      // Match 15 - June 14
      MatchModel(
        id: '15',
        homeTeam: 'Hırvatistan',
        awayTeam: 'Senegal',
        homeFlagUrl: 'https://flagcdn.com/h80/hr.png',
        awayFlagUrl: 'https://flagcdn.com/h80/sn.png',
        matchTime: '22:00',
        matchDate: '14 Haz, 2026',
        city: 'Guadalajara',
        stadium: 'Estadio Akron',
        group: 'C Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_bicycle_15',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_coach_15',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_late_15',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_post_15',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_invader_15',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
        ],
      ),

      // ============================================
      // DAY 4: June 15, 2026
      // ============================================
      
      // Match 16 - June 15
      MatchModel(
        id: '16',
        homeTeam: 'Danimarka',
        awayTeam: 'Tunus',
        homeFlagUrl: 'https://flagcdn.com/h80/dk.png',
        awayFlagUrl: 'https://flagcdn.com/h80/tn.png',
        matchTime: '13:00',
        matchDate: '15 Haz, 2026',
        city: 'Montreal',
        stadium: 'Olympic Stadium',
        group: 'D Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_var_16',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_possession_16',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_jersey_16',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_keeper_16',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_post_16',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
        ],
      ),

      // Match 17 - June 15
      MatchModel(
        id: '17',
        homeTeam: 'ABD',
        awayTeam: 'Galler',
        homeFlagUrl: 'https://flagcdn.com/h80/us.png',
        awayFlagUrl: 'https://flagcdn.com/h80/gb-wls.png',
        matchTime: '16:00',
        matchDate: '15 Haz, 2026',
        city: 'New York',
        stadium: 'MetLife Stadium',
        group: 'E Grubu',
        isLive: false,
        isFavorite: true,
        questions: [
          const PredictionQuestion(
            id: 'q_bicycle_17',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_coach_17',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_late_17',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_invader_17',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_var_17',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
        ],
      ),

      // Match 18 - June 15
      MatchModel(
        id: '18',
        homeTeam: 'İtalya',
        awayTeam: 'Arjantin',
        homeFlagUrl: 'https://flagcdn.com/h80/it.png',
        awayFlagUrl: 'https://flagcdn.com/h80/ar.png',
        matchTime: '19:00',
        matchDate: '15 Haz, 2026',
        city: 'Chicago',
        stadium: 'Soldier Field',
        group: 'F Grubu',
        isLive: false,
        isFavorite: true,
        questions: [
          const PredictionQuestion(
            id: 'q_possession_18',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_post_18',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_keeper_18',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_jersey_18',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_var_18',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
        ],
      ),

      // Match 19 - June 15
      MatchModel(
        id: '19',
        homeTeam: 'Brezilya',
        awayTeam: 'İsviçre',
        homeFlagUrl: 'https://flagcdn.com/h80/br.png',
        awayFlagUrl: 'https://flagcdn.com/h80/ch.png',
        matchTime: '22:00',
        matchDate: '15 Haz, 2026',
        city: 'Monterrey',
        stadium: 'Estadio BBVA',
        group: 'A Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_bicycle_19',
            text: 'Rövaşata denemesi olur mu?',
            yesPoints: 60,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_coach_19',
            text: 'Teknik direktör sarı kart görür mü?',
            yesPoints: 75,
            noPoints: 12,
          ),
          const PredictionQuestion(
            id: 'q_late_19',
            text: '90+5\'ten sonra gol olur mu?',
            yesPoints: 100,
            noPoints: 5,
          ),
          const PredictionQuestion(
            id: 'q_post_19',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_invader_19',
            text: 'Sahaya seyirci girer mi?',
            yesPoints: 200,
            noPoints: 5,
          ),
        ],
      ),

      // Match 20 - June 15
      MatchModel(
        id: '20',
        homeTeam: 'Fransa',
        awayTeam: 'Danimarka',
        homeFlagUrl: 'https://flagcdn.com/h80/fr.png',
        awayFlagUrl: 'https://flagcdn.com/h80/dk.png',
        matchTime: '22:00',
        matchDate: '15 Haz, 2026',
        city: 'Toronto',
        stadium: 'BMO Field',
        group: 'B Grubu',
        isLive: false,
        isFavorite: false,
        questions: [
          const PredictionQuestion(
            id: 'q_var_20',
            text: 'Hakem VAR monitörünü izler mi?',
            yesPoints: 40,
            noPoints: 15,
          ),
          const PredictionQuestion(
            id: 'q_possession_20',
            text: 'Topla oynama %70\'i geçer mi?',
            yesPoints: 30,
            noPoints: 18,
          ),
          const PredictionQuestion(
            id: 'q_jersey_20',
            text: 'Bir futbolcunun forması yırtılır mı?',
            yesPoints: 150,
            noPoints: 8,
          ),
          const PredictionQuestion(
            id: 'q_keeper_20',
            text: 'Kaleci kalesini terk edip orta sahayı geçer mi?',
            yesPoints: 80,
            noPoints: 10,
          ),
          const PredictionQuestion(
            id: 'q_post_20',
            text: 'Top direkten döner mi?',
            yesPoints: 50,
            noPoints: 15,
          ),
        ],
      ),
    ];
  }
  
  /// Get standings for a specific group
  static List<GroupStanding> getStandingsForGroup(String groupName) {
    switch (groupName) {
      case 'A Grubu':
        return [
          const GroupStanding(
            teamName: 'ABD',
            flagUrl: 'https://flagcdn.com/h80/us.png',
            played: 2,
            won: 2,
            drawn: 0,
            lost: 0,
            goalsFor: 5,
            goalsAgainst: 2,
            points: 6,
          ),
          const GroupStanding(
            teamName: 'Almanya',
            flagUrl: 'https://flagcdn.com/h80/de.png',
            played: 2,
            won: 1,
            drawn: 1,
            lost: 0,
            goalsFor: 4,
            goalsAgainst: 2,
            points: 4,
          ),
          const GroupStanding(
            teamName: 'Uruguay',
            flagUrl: 'https://flagcdn.com/h80/uy.png',
            played: 2,
            won: 0,
            drawn: 1,
            lost: 1,
            goalsFor: 2,
            goalsAgainst: 4,
            points: 1,
          ),
          const GroupStanding(
            teamName: 'Brezilya',
            flagUrl: 'https://flagcdn.com/h80/br.png',
            played: 2,
            won: 0,
            drawn: 0,
            lost: 2,
            goalsFor: 1,
            goalsAgainst: 4,
            points: 0,
          ),
        ];
        
      case 'B Grubu':
        return [
          const GroupStanding(
            teamName: 'Kanada',
            flagUrl: 'https://flagcdn.com/h80/ca.png',
            played: 2,
            won: 1,
            drawn: 1,
            lost: 0,
            goalsFor: 4,
            goalsAgainst: 2,
            points: 4,
          ),
          const GroupStanding(
            teamName: 'Hollanda',
            flagUrl: 'https://flagcdn.com/h80/nl.png',
            played: 2,
            won: 1,
            drawn: 1,
            lost: 0,
            goalsFor: 3,
            goalsAgainst: 2,
            points: 4,
          ),
          const GroupStanding(
            teamName: 'İsviçre',
            flagUrl: 'https://flagcdn.com/h80/ch.png',
            played: 2,
            won: 1,
            drawn: 0,
            lost: 1,
            goalsFor: 3,
            goalsAgainst: 3,
            points: 3,
          ),
          const GroupStanding(
            teamName: 'Fransa',
            flagUrl: 'https://flagcdn.com/h80/fr.png',
            played: 2,
            won: 0,
            drawn: 0,
            lost: 2,
            goalsFor: 2,
            goalsAgainst: 5,
            points: 0,
          ),
        ];
        
      case 'C Grubu':
        return [
          const GroupStanding(
            teamName: 'Brezilya',
            flagUrl: 'https://flagcdn.com/h80/br.png',
            played: 2,
            won: 2,
            drawn: 0,
            lost: 0,
            goalsFor: 6,
            goalsAgainst: 2,
            points: 6,
          ),
          const GroupStanding(
            teamName: 'İngiltere',
            flagUrl: 'https://flagcdn.com/h80/gb-eng.png',
            played: 2,
            won: 1,
            drawn: 0,
            lost: 1,
            goalsFor: 4,
            goalsAgainst: 3,
            points: 3,
          ),
          const GroupStanding(
            teamName: 'Hırvatistan',
            flagUrl: 'https://flagcdn.com/h80/hr.png',
            played: 2,
            won: 1,
            drawn: 0,
            lost: 1,
            goalsFor: 3,
            goalsAgainst: 4,
            points: 3,
          ),
          const GroupStanding(
            teamName: 'Japonya',
            flagUrl: 'https://flagcdn.com/h80/jp.png',
            played: 2,
            won: 0,
            drawn: 0,
            lost: 2,
            goalsFor: 2,
            goalsAgainst: 6,
            points: 0,
          ),
        ];
        
      case 'D Grubu':
        return [
          const GroupStanding(
            teamName: 'Fransa',
            flagUrl: 'https://flagcdn.com/h80/fr.png',
            played: 2,
            won: 1,
            drawn: 1,
            lost: 0,
            goalsFor: 4,
            goalsAgainst: 2,
            points: 4,
          ),
          const GroupStanding(
            teamName: 'Belçika',
            flagUrl: 'https://flagcdn.com/h80/be.png',
            played: 2,
            won: 1,
            drawn: 0,
            lost: 1,
            goalsFor: 3,
            goalsAgainst: 3,
            points: 3,
          ),
          const GroupStanding(
            teamName: 'Danimarka',
            flagUrl: 'https://flagcdn.com/h80/dk.png',
            played: 2,
            won: 0,
            drawn: 2,
            lost: 0,
            goalsFor: 2,
            goalsAgainst: 2,
            points: 2,
          ),
          const GroupStanding(
            teamName: 'Avustralya',
            flagUrl: 'https://flagcdn.com/h80/au.png',
            played: 2,
            won: 0,
            drawn: 1,
            lost: 1,
            goalsFor: 2,
            goalsAgainst: 4,
            points: 1,
          ),
        ];
        
      case 'E Grubu':
        return [
          const GroupStanding(
            teamName: 'İspanya',
            flagUrl: 'https://flagcdn.com/h80/es.png',
            played: 2,
            won: 2,
            drawn: 0,
            lost: 0,
            goalsFor: 5,
            goalsAgainst: 1,
            points: 6,
          ),
          const GroupStanding(
            teamName: 'Meksika',
            flagUrl: 'https://flagcdn.com/h80/mx.png',
            played: 2,
            won: 1,
            drawn: 0,
            lost: 1,
            goalsFor: 3,
            goalsAgainst: 3,
            points: 3,
          ),
          const GroupStanding(
            teamName: 'ABD',
            flagUrl: 'https://flagcdn.com/h80/us.png',
            played: 2,
            won: 1,
            drawn: 0,
            lost: 1,
            goalsFor: 3,
            goalsAgainst: 4,
            points: 3,
          ),
          const GroupStanding(
            teamName: 'Polonya',
            flagUrl: 'https://flagcdn.com/h80/pl.png',
            played: 2,
            won: 0,
            drawn: 0,
            lost: 2,
            goalsFor: 2,
            goalsAgainst: 5,
            points: 0,
          ),
        ];
        
      case 'F Grubu':
        return [
          const GroupStanding(
            teamName: 'Arjantin',
            flagUrl: 'https://flagcdn.com/h80/ar.png',
            played: 2,
            won: 1,
            drawn: 1,
            lost: 0,
            goalsFor: 4,
            goalsAgainst: 2,
            points: 4,
          ),
          const GroupStanding(
            teamName: 'Portekiz',
            flagUrl: 'https://flagcdn.com/h80/pt.png',
            played: 2,
            won: 1,
            drawn: 1,
            lost: 0,
            goalsFor: 3,
            goalsAgainst: 2,
            points: 4,
          ),
          const GroupStanding(
            teamName: 'Güney Kore',
            flagUrl: 'https://flagcdn.com/h80/kr.png',
            played: 2,
            won: 0,
            drawn: 1,
            lost: 1,
            goalsFor: 2,
            goalsAgainst: 3,
            points: 1,
          ),
          const GroupStanding(
            teamName: 'Gana',
            flagUrl: 'https://flagcdn.com/h80/gh.png',
            played: 2,
            won: 0,
            drawn: 1,
            lost: 1,
            goalsFor: 2,
            goalsAgainst: 4,
            points: 1,
          ),
        ];
        
      default:
        return [];
    }
  }
}
