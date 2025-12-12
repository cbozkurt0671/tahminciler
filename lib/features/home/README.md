# Home Feature

World Cup Dashboard with hero match and quick prediction functionality.

## Structure

```
lib/features/home/
├── data/
│   ├── models/
│   │   └── match_model.dart          # Match data model
│   └── dummy_data.dart                # Sample World Cup matches
├── presentation/
│   ├── screens/
│   │   └── home_screen.dart           # Main home screen
│   └── widgets/
│       ├── home_header.dart           # Header with title and icons
│       ├── hero_match_card.dart       # Featured live match card
│       ├── quick_predict_card.dart    # Individual match prediction card
│       └── quick_predict_list.dart    # Scrollable list of matches
└── home.dart                          # Barrel file
```

## Features

### 1. Home Header
- **Title:** "Qatar 2022"
- **Menu Icon:** Left side (iconsax menu icon)
- **Notification Icon:** Right side with badge indicator

### 2. Hero Match Card
- **Gradient Background:** Blue to Purple gradient
- **Live Indicator:** Pulsing white dot + match time
- **Team Display:** Large flag emojis + team codes
- **Score Display:** Large, bold white numbers
- **Scorers:** Bottom section showing goal scorers with times

### 3. Quick Predict List
- **Section Header:** "Matches of the Day" with "See All" link
- **Match Cards:** 
  - Dark surface background (#222232)
  - Team flags and names on both sides
  - Center input fields for score prediction
  - Match date and time at bottom
  - Tap card to view details
  - Tap input to enter prediction

## Usage

```dart
import 'package:world_cup_app/features/home/home.dart';

// In MaterialApp
home: const HomeScreen(),
```

## Key Components

### MatchModel
```dart
MatchModel(
  id: '1',
  homeTeam: 'ARG',
  awayTeam: 'POR',
  homeTeamFlag: '🇦🇷',
  awayTeamFlag: '🇵🇹',
  matchTime: '60:22',
  matchDate: 'Dec 11, 2025',
  homeScore: 2,
  awayScore: 2,
  isLive: true,
  isHero: true,
);
```

### HomeScreen Callbacks
- `onPredictionChanged`: Called when user enters a prediction
- `onMatchTap`: Called when user taps a match card
- `onCardTap`: Opens match detail view (TODO)

## Design Implementation

✅ **Gradient Hero Card:** Uses `AppColors.primaryGradient`  
✅ **Dark Cards:** Uses `AppColors.cardSurface`  
✅ **Score Inputs:** Dark background (#121219) with focus states  
✅ **Typography:** Poppins font from theme  
✅ **Shadows:** Standard card shadows  
✅ **Responsive:** Column/Row layout, no absolute positioning  

## Current Dummy Data

9 World Cup matches including:
- ARG vs POR (Live Hero Match)
- BRA vs GER
- FRA vs ENG
- ESP vs NED
- BEL vs ITA
- URU vs CRO
- SEN vs MAR
- MEX vs USA
- JPN vs KOR

## Next Steps

1. **Add BLoC/State Management:** 
   - Create `HomeCubit` or `HomeBloc`
   - Manage predictions state
   - Handle API calls

2. **Persistence:**
   - Save predictions locally
   - Sync with backend

3. **Navigation:**
   - Match detail screen
   - All matches screen
   - Notifications screen

4. **Enhancements:**
   - Pull to refresh
   - Loading states
   - Error handling
   - Animations
