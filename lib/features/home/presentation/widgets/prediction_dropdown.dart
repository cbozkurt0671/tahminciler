import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/match_model.dart';

/// Tahmin dropdown menüsü widget'ı
/// Kullanıcıların maç tahminlerini yapabildiği interaktif dropdown
class PredictionDropdown extends StatefulWidget {
  final MatchModel match;

  const PredictionDropdown({
    super.key,
    required this.match,
  });

  @override
  State<PredictionDropdown> createState() => _PredictionDropdownState();
}

class _PredictionDropdownState extends State<PredictionDropdown> {
  bool _isExpanded = false;
  String? _matchResult;
  String? _bothTeamsScore;
  String? _firstHalfResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.white.withOpacity(0.05),
        ),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gradientBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _isExpanded ? Icons.sports_soccer : Icons.sports_soccer_outlined,
              color: AppColors.gradientBlue,
              size: 20,
            ),
          ),
          title: Text(
            'Tahminlerini Yap 🏆',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: !_isExpanded
              ? Text(
                  'Dokunarak tahmin seçeneklerini gör',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                )
              : null,
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white.withOpacity(0.7),
          ),
          children: [
            // Maç Sonucu
            _buildPredictionQuestion(
              title: '⚽ Maç Sonucu',
              currentValue: _matchResult,
              options: const [
                {'value': 'home', 'label': 'Ev Sahibi'},
                {'value': 'draw', 'label': 'Beraberlik'},
                {'value': 'away', 'label': 'Deplasman'},
              ],
              onChanged: (value) {
                setState(() {
                  _matchResult = value;
                });
                debugPrint('✅ Seçim yapıldı: Maç Sonucu - ${_getLabel(value, [
                  {'value': 'home', 'label': 'Ev Sahibi'},
                  {'value': 'draw', 'label': 'Beraberlik'},
                  {'value': 'away', 'label': 'Deplasman'},
                ])}');
              },
            ),
            const SizedBox(height: 12),

            // Karşılıklı Gol
            _buildPredictionQuestion(
              title: '🎯 Karşılıklı Gol?',
              currentValue: _bothTeamsScore,
              options: const [
                {'value': 'yes', 'label': 'Var'},
                {'value': 'no', 'label': 'Yok'},
              ],
              onChanged: (value) {
                setState(() {
                  _bothTeamsScore = value;
                });
                debugPrint('✅ Seçim yapıldı: Karşılıklı Gol - ${_getLabel(value, [
                  {'value': 'yes', 'label': 'Var'},
                  {'value': 'no', 'label': 'Yok'},
                ])}');
              },
            ),
            const SizedBox(height: 12),

            // İlk Yarı Sonucu
            _buildPredictionQuestion(
              title: '⏱️ İlk Yarı Sonucu',
              currentValue: _firstHalfResult,
              options: const [
                {'value': '1', 'label': '1'},
                {'value': 'X', 'label': 'X'},
                {'value': '2', 'label': '2'},
              ],
              onChanged: (value) {
                setState(() {
                  _firstHalfResult = value;
                });
                debugPrint('✅ Seçim yapıldı: İlk Yarı Sonucu - ${_getLabel(value, [
                  {'value': '1', 'label': '1'},
                  {'value': 'X', 'label': 'X'},
                  {'value': '2', 'label': '2'},
                ])}');
              },
            ),

            const SizedBox(height: 16),

            // Kaydet Butonu
            if (_matchResult != null ||
                _bothTeamsScore != null ||
                _firstHalfResult != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _savePredictions();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gradientBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.save_outlined, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Tahminleri Kaydet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionQuestion({
    required String title,
    required String? currentValue,
    required List<Map<String, String>> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final value = option['value']!;
            final label = option['label']!;
            final isSelected = currentValue == value;

            return InkWell(
              onTap: () => onChanged(value),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.gradientBlue.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.gradientBlue
                        : Colors.white.withOpacity(0.1),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.gradientBlue
                        : Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getLabel(String? value, List<Map<String, String>> options) {
    if (value == null) return '';
    return options.firstWhere(
      (opt) => opt['value'] == value,
      orElse: () => {'label': value},
    )['label']!;
  }

  void _savePredictions() {
    final predictions = <String, String>{};
    if (_matchResult != null) predictions['Maç Sonucu'] = _matchResult!;
    if (_bothTeamsScore != null) predictions['Karşılıklı Gol'] = _bothTeamsScore!;
    if (_firstHalfResult != null) predictions['İlk Yarı Sonucu'] = _firstHalfResult!;

    debugPrint('💾 Tahminler Kaydedildi:');
    predictions.forEach((key, value) {
      debugPrint('   $key: $value');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${predictions.length} tahmin kaydedildi!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.gradientBlue,
      ),
    );
  }
}
