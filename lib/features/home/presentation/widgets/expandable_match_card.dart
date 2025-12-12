import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/match_model.dart';
import '../../data/models/prediction_question.dart';

/// Expandable match card with accordion-style dropdown
/// Shows score prediction inputs and animated additional prediction options when expanded
/// Includes dynamic scoring system with XP tracking
class ExpandableMatchCard extends StatefulWidget {
  final MatchModel match;
  final Function(int homeScore, int awayScore)? onScoreChanged;
  final Function(String questionId, bool answer)? onExtraPredictionChanged;
  final Function(bool isFavorite)? onFavoriteToggled;

  const ExpandableMatchCard({
    super.key,
    required this.match,
    this.onScoreChanged,
    this.onExtraPredictionChanged,
    this.onFavoriteToggled,
  });

  @override
  State<ExpandableMatchCard> createState() => _ExpandableMatchCardState();
}

class _ExpandableMatchCardState extends State<ExpandableMatchCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  final TextEditingController _homeScoreController = TextEditingController();
  final TextEditingController _awayScoreController = TextEditingController();
  final FocusNode _homeFocusNode = FocusNode();
  final FocusNode _awayFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  // Dynamic predictions state - Maps question ID to answer (true/false/null)
  final Map<String, bool?> _selectedAnswers = {};

  // XP Calculation
  int _totalPotentialXP = 0;
  final int _scoreCorrectXP = 100; // Bonus XP for score prediction (increased from 25)

  // Neon green color for selected state
  static const Color neonGreen = Color(0xFF00E676);
  static const Color neonPink = Color(0xFFFF4081);
  static const Color neonBlue = Color(0xFF00B8D4);
  static const Color darkGrey = Color(0xFF2A2A3A);

  @override
  void initState() {
    super.initState();
    
    if (widget.match.homeScore != null) {
      _homeScoreController.text = widget.match.homeScore.toString();
    }
    if (widget.match.awayScore != null) {
      _awayScoreController.text = widget.match.awayScore.toString();
    }

    // NOTE: Controller listeners removed - using onChanged callbacks instead
    // This prevents multiple setState calls on single input change
    // _homeScoreController.addListener(_onScoreChanged);
    // _awayScoreController.addListener(_onScoreChanged);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _calculateTotalXP();
  }

  @override
  void didUpdateWidget(ExpandableMatchCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // CRITICAL: Don't reset controllers if user has entered data
    // Only update from match data if controllers are empty
    if (_homeScoreController.text.isEmpty && widget.match.homeScore != null) {
      _homeScoreController.text = widget.match.homeScore.toString();
    }
    if (_awayScoreController.text.isEmpty && widget.match.awayScore != null) {
      _awayScoreController.text = widget.match.awayScore.toString();
    }
    
    print('🔄 didUpdateWidget çağrıldı - Controller korundu: Home="${_homeScoreController.text}" Away="${_awayScoreController.text}"');
  }

  void _calculateTotalXP() {
    int total = 0;

    // Add score prediction XP if both scores are entered
    if (_homeScoreController.text.isNotEmpty && _awayScoreController.text.isNotEmpty) {
      total += _scoreCorrectXP;
      print('✅ SKOR GİRİŞİ TESPİT EDİLDİ: ${_homeScoreController.text} - ${_awayScoreController.text} | +$_scoreCorrectXP XP');
      
      // Notify parent widget about score change
      final homeScore = int.tryParse(_homeScoreController.text);
      final awayScore = int.tryParse(_awayScoreController.text);
      if (homeScore != null && awayScore != null) {
        widget.onScoreChanged?.call(homeScore, awayScore);
      }
    } else {
      print('⚠️ SKOR EKSİK: Home="${_homeScoreController.text}" Away="${_awayScoreController.text}"');
    }

    // Calculate XP from dynamic predictions
    for (var question in widget.match.questions) {
      final answer = _selectedAnswers[question.id];
      if (answer != null) {
        total += answer ? question.yesPoints : question.noPoints;
      }
    }

    print('📊 TOPLAM XP: $total (Önceki: $_totalPotentialXP)');
    
    setState(() {
      _totalPotentialXP = total;
    });
    
    print('🔄 setState() ÇAĞRILDI - UI güncellenecek');
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    _homeFocusNode.dispose();
    _awayFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1D29), // Deep dark blue
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header (Always Visible) - SofaScore Style
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LEFT: Time/Status Column (Fixed Width)
                  Container(
                    width: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.match.matchTime,
                          style: const TextStyle(
                            color: Color(0xFF8E92A2),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        // City badge below time
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2D3A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.match.city.split(',')[0], // First part of city name
                            style: const TextStyle(
                              color: Color(0xFF8E92A2),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Vertical Divider
                  Container(
                    width: 1,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF8E92A2).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  
                  // RIGHT: Match Content (Teams Stacked Vertically)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HOME TEAM ROW
                        _buildTeamRow(
                          flagUrl: widget.match.homeFlagUrl,
                          teamName: widget.match.homeTeam,
                          scoreController: _homeScoreController,
                          focusNode: _homeFocusNode,
                          isHome: true,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // AWAY TEAM ROW
                        _buildTeamRow(
                          flagUrl: widget.match.awayFlagUrl,
                          teamName: widget.match.awayTeam,
                          scoreController: _awayScoreController,
                          focusNode: _awayFocusNode,
                          isHome: false,
                        ),
                      ],
                    ),
                  ),
                  
                  // Favorite icon on far right
                  const SizedBox(width: 8),
                  _buildFavoriteIcon(),
                ],
              ),
            ),
          ),
          
          // Expandable Content (Dropdown)
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: _buildExpandedContent(),
          ),
        ],
      ),
    );
  }

  // Build a single team row (SofaScore style)
  Widget _buildTeamRow({
    required String flagUrl,
    required String teamName,
    required TextEditingController scoreController,
    required FocusNode focusNode,
    required bool isHome,
  }) {
    return Row(
      children: [
        // 1. Flag (Small, circular)
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF2A2D3A),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              flagUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2A2D3A),
                  child: const Icon(
                    Icons.flag,
                    size: 12,
                    color: Color(0xFF8E92A2),
                  ),
                );
              },
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 2. Team Name (Expanded to prevent cutoff)
        Expanded(
          child: Text(
            teamName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 3. Score Input (Fixed width, right-aligned)
        GestureDetector(
          onTap: () {}, // Prevent expansion when tapping input
          child: Container(
            width: 40,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2D3A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: focusNode.hasFocus
                    ? const Color(0xFF00E676)
                    : const Color(0xFF3A3D4A),
                width: 1.5,
              ),
            ),
            child: Center(
              child: TextField(
                controller: scoreController,
                focusNode: focusNode,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onChanged: (value) {
                  print('🎯 Score değişti: $value');
                  _calculateTotalXP();
                  
                  // Notify parent
                  final homeScore = int.tryParse(_homeScoreController.text);
                  final awayScore = int.tryParse(_awayScoreController.text);
                  
                  if (homeScore != null && awayScore != null) {
                    widget.onScoreChanged?.call(homeScore, awayScore);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteIcon() {
    return GestureDetector(
      onTap: () {
        widget.onFavoriteToggled?.call(!widget.match.isFavorite);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: widget.match.isFavorite
              ? const Color(0xFF00E676).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          widget.match.isFavorite ? Icons.star : Icons.star_border,
          color: widget.match.isFavorite
              ? const Color(0xFF00E676)
              : const Color(0xFF8E92A2),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF2A2D3A).withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total XP Indicator
            if (_totalPotentialXP > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, size: 14, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      '+$_totalPotentialXP XP',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            Divider(
              height: 1,
              color: const Color(0xFF2A2D3A).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            
            // Section Title
            Text(
              'Ek Tahminler',
              style: const TextStyle(
                color: Color(0xFF8E92A2),
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Questions
            ...widget.match.questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final currentValue = _selectedAnswers[question.id];
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedQuestion(
                    index,
                    question,
                    currentValue,
                    (value) {
                      setState(() {
                        _selectedAnswers[question.id] = value;
                        _calculateTotalXP();
                        if (value != null) {
                          widget.onExtraPredictionChanged?.call(question.id, value);
                        }
                      });
                    },
                  ),
                  if (index < widget.match.questions.length - 1)
                    const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedQuestion(
    int index,
    PredictionQuestion question,
    bool? currentValue,
    Function(bool?) onChanged,
  ) {
    // Create staggered animation delay
    final delay = index * 0.1;
    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          delay,
          delay + 0.5,
          curve: Curves.easeOut,
        ),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              delay,
              delay + 0.5,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text - Minimal styling
            Text(
              question.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    color: AppColors.textPrimary.withOpacity(0.9),
                  ),
            ),
            const SizedBox(height: 10),
            // Toggle buttons with XP badges
            Row(
              children: [
                // Yes Button with XP Badge
                Expanded(
                  child: _ToggleButtonWithXP(
                    label: 'Evet',
                    xp: question.yesPoints,
                    isSelected: currentValue == true,
                    onTap: () {
                      // Toggle off if already selected, otherwise select Yes
                      onChanged(currentValue == true ? null : true);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // No Button with XP Badge
                Expanded(
                  child: _ToggleButtonWithXP(
                    label: 'Hayır',
                    xp: question.noPoints,
                    isSelected: currentValue == false,
                    onTap: () {
                      // Toggle off if already selected, otherwise select No
                      onChanged(currentValue == false ? null : false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Isolated Score Input Row Widget
/// This widget prevents tap events from propagating to parent card expansion logic
class _ScoreInputRow extends StatelessWidget {
  final TextEditingController homeController;
  final TextEditingController awayController;
  final FocusNode homeFocusNode;
  final FocusNode awayFocusNode;
  final VoidCallback? onScoreChanged;

  const _ScoreInputRow({
    required this.homeController,
    required this.awayController,
    required this.homeFocusNode,
    required this.awayFocusNode,
    this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    // CRITICAL: This GestureDetector with opaque behavior prevents taps
    // from bubbling up to the parent card's expansion gesture
    return GestureDetector(
      onTap: () {
        // Empty callback - absorbs tap events
        // Combined with opaque behavior, this completely isolates
        // the score input area from parent gestures
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Home Score Input
          _MinimalScoreInput(
            controller: homeController,
            focusNode: homeFocusNode,
            nextFocusNode: awayFocusNode,
            onChanged: (value) {
              // Force immediate UI update
              print('🏠 Home Score onChanged: "$value"');
              onScoreChanged?.call();
            },
          ),

          // VS separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              'vs',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.4),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Away Score Input
          _MinimalScoreInput(
            controller: awayController,
            focusNode: awayFocusNode,
            isLastInput: true,
            onChanged: (value) {
              // Force immediate UI update
              print('✈️ Away Score onChanged: "$value"');
              onScoreChanged?.call();
            },
          ),
        ],
      ),
    );
  }
}

/// Minimal score input field widget with border highlight on focus
class _MinimalScoreInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final bool isLastInput;
  final Function(String)? onChanged;

  const _MinimalScoreInput({
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.isLastInput = false,
    this.onChanged,
  });

  @override
  State<_MinimalScoreInput> createState() => _MinimalScoreInputState();
}

class _MinimalScoreInputState extends State<_MinimalScoreInput> {
  @override
  void initState() {
    super.initState();
    // Listen to focus changes to rebuild for visual feedback
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Rebuild to show/hide focus border
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 40,
      decoration: BoxDecoration(
        color: widget.focusNode.hasFocus 
            ? const Color(0xFF1A1A24).withOpacity(0.8)
            : const Color(0xFF1A1A24).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.focusNode.hasFocus
              ? AppColors.gradientBlue.withOpacity(0.8)
              : Colors.white.withOpacity(0.15),
          width: widget.focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: widget.isLastInput ? TextInputAction.done : TextInputAction.next,
        maxLength: 1,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          // CRITICAL: Trigger immediate parent state update
          print('⌨️ TextField onChanged: "$value"');
          widget.onChanged?.call(value);
          // Also trigger local rebuild to ensure text is visible
          setState(() {});
        },
        onSubmitted: (_) {
          if (!widget.isLastInput && widget.nextFocusNode != null) {
            widget.nextFocusNode!.requestFocus();
          } else {
            widget.focusNode.unfocus();
          }
        },
      ),
    );
  }
}

/// Old score input (kept for reference, can be removed)
class _ScoreInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _ScoreInput({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF121219),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: focusNode.hasFocus
              ? AppColors.gradientBlue
              : AppColors.textSecondary.withOpacity(0.2),
          width: focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

/// Circular flag/logo widget with minimalist styling
class _CircularFlag extends StatelessWidget {
  final String flagUrl;

  const _CircularFlag({
    required this.flagUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A1A24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          flagUrl,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.flag,
                size: 18,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// XP Badge showing potential or earned points - Minimal pill design
class _XPBadge extends StatelessWidget {
  final int xp;
  final bool isPotential;

  const _XPBadge({
    required this.xp,
    this.isPotential = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = xp >= 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive
              ? [const Color(0xFF00B8D4).withOpacity(0.8), const Color(0xFF0097A7).withOpacity(0.8)]
              : [const Color(0xFF424242).withOpacity(0.6), const Color(0xFF303030).withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20), // More pill-shaped
        boxShadow: isPositive && xp > 0
            ? [
                BoxShadow(
                  color: const Color(0xFF00B8D4).withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPotential)
            Icon(
              Icons.bolt,
              size: 11,
              color: Colors.white.withOpacity(0.95),
            ),
          if (isPotential) const SizedBox(width: 3),
          Text(
            xp > 0 ? '+$xp XP' : '${xp} XP',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                  letterSpacing: 0.3,
                ),
          ),
        ],
      ),
    );
  }
}

/// Toggle button with integrated XP badge and pulse animation
class _ToggleButtonWithXP extends StatefulWidget {
  final String label;
  final int xp;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButtonWithXP({
    required this.label,
    required this.xp,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ToggleButtonWithXP> createState() => _ToggleButtonWithXPState();
}

class _ToggleButtonWithXPState extends State<_ToggleButtonWithXP>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const Color neonGreen = Color(0xFF00E676);
  static const Color darkGrey = Color(0xFF2A2A3A);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Trigger pulse animation
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.xp >= 0;
    
    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: widget.isSelected ? neonGreen.withOpacity(0.15) : darkGrey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.isSelected ? neonGreen.withOpacity(0.6) : Colors.white.withOpacity(0.05),
            width: 1.5,
          ),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: neonGreen.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Label
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: widget.isSelected
                        ? neonGreen
                        : AppColors.textSecondary.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
            ),
            const SizedBox(height: 5),
            // XP Badge with pulse animation - More minimal
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPositive
                        ? [const Color(0xFF4CAF50).withOpacity(0.8), const Color(0xFF388E3C).withOpacity(0.8)]
                        : [const Color(0xFFFF6B6B).withOpacity(0.8), const Color(0xFFE85D5D).withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isPositive ? const Color(0xFF4CAF50) : const Color(0xFFFF6B6B))
                          .withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 9,
                      color: Colors.white.withOpacity(0.95),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      isPositive ? '+${widget.xp}' : '${widget.xp}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Text(
                      ' XP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
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
}

// ===========================
// Location Badge Widget - WC 2026 Host City Indicator
// ===========================
class _LocationBadge extends StatelessWidget {
  final String city;

  const _LocationBadge({
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 12,
            color: AppColors.textSecondary.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Text(
            city.toUpperCase(),
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.9),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
