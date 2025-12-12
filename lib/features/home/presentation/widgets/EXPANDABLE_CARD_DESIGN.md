# Expandable Match Card Design

## Overview

Single-page accordion-style experience for match predictions with expandable cards.

## Key Changes from Previous Design

### Before
- Tapping card → Navigate to new screen
- Score inputs only
- Overflow issues with keyboard

### After
- Tapping card → Expands accordion dropdown
- Score inputs + 5 extra predictions
- Fixed keyboard handling and overflow
- GestureDetector dismisses keyboard on tap outside
- SafeArea + proper padding for keyboard insets

## Features

### 1. Card Header (Always Visible)
- Team flags and names
- Score input boxes (2 fields, centered)
- Match date and time
- Expand/collapse arrow indicator
- Tappable to toggle expansion

### 2. Extra Predictions Section (Expandable)

When expanded, shows 5 Yes/No questions with toggle buttons:

1. **"Will there be a Red Card?"**
2. **"Both Teams to Score?"**
3. **"Penalty Awarded?"**
4. **"Total Goals Over 2.5?"**
5. **"Goal in first 15 mins?"**

### Toggle Button States
- **Selected:** Neon Green `#00E676` background, black text
- **Unselected:** Dark Grey `#2A2A3A` background, lavender text
- Both options have rounded corners (10px)

## Technical Implementation

### State Management
Each `ExpandableMatchCard` manages its own state:
- `_isExpanded` - Card expansion state
- Score controllers for home/away
- 5 boolean states for extra predictions

### Bug Fixes

#### 1. Keyboard Handling
```dart
GestureDetector(
  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
  child: Scaffold(...),
)
```

#### 2. Overflow Prevention
```dart
Expanded(
  child: Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: ListView.builder(...),
  ),
)
```

#### 3. SafeArea Wrapping
```dart
SafeArea(
  child: Column(...),
)
```

## Widget Structure

```
ExpandableMatchCard
├── Card Header (InkWell - Tappable)
│   ├── Teams Row
│   │   ├── Home Team (Flag + Name)
│   │   ├── Score Inputs (Home - Away)
│   │   └── Away Team (Name + Flag)
│   └── Info Row
│       ├── Match Date/Time
│       └── Expand/Collapse Icon
│
└── Expanded Section (Conditional)
    ├── Divider
    ├── "Extra Predictions" Title
    └── 5 Prediction Questions
        ├── Question Text
        └── Yes/No Toggle Buttons
```

## Styling

### Colors
- **Background:** `#181928`
- **Card Surface:** `#222232`
- **Score Input:** `#121219`
- **Neon Green (Selected):** `#00E676`
- **Dark Grey (Unselected):** `#2A2A3A`
- **Text:** White (Poppins)

### Dimensions
- Score Input: 42x42px
- Card Padding: 16px
- Card Margin Bottom: 12px
- Border Radius: 15px (cards), 10px (inputs/buttons)

## Callbacks

### onScoreChanged
```dart
onScoreChanged: (int homeScore, int awayScore) {
  // Handle score prediction
}
```

### onExtraPredictionChanged
```dart
onExtraPredictionChanged: (String question, bool answer) {
  // Handle extra prediction
  // question: 'red_card', 'both_teams_score', etc.
  // answer: true (Yes) or false (No)
}
```

## Usage Example

```dart
ExpandableMatchCard(
  match: matchModel,
  onScoreChanged: (homeScore, awayScore) {
    print('Score: $homeScore - $awayScore');
  },
  onExtraPredictionChanged: (question, answer) {
    print('$question: ${answer ? "Yes" : "No"}');
  },
)
```

## Accordion Behavior

1. **Initial State:** All cards collapsed
2. **Tap Header:** Card expands, shows extra predictions
3. **Tap Again:** Card collapses, keyboard dismissed
4. **Multiple Cards:** Can have multiple expanded simultaneously
5. **Scroll:** ListView handles scrolling with expanded cards

## Keyboard Behavior

- **Focus Input:** Keyboard appears, list adjusts with viewInsets padding
- **Tap Outside:** Keyboard dismisses via GestureDetector
- **Collapse Card:** Keyboard dismisses automatically
- **Switch Cards:** Previous keyboard dismissed when new input focused

## Performance

- Each card maintains its own state (no parent re-renders)
- ListView.builder for efficient rendering
- Input controllers properly disposed
- Focus nodes cleaned up in dispose()

## Next Steps

1. **Persist Predictions:**
   - Save to local storage (Hive/SharedPreferences)
   - Sync with backend API

2. **Add Animations:**
   - Smooth expand/collapse transition
   - Toggle button press animation

3. **Validation:**
   - Require score before expanding
   - Show incomplete predictions indicator

4. **Points System:**
   - Calculate points for correct predictions
   - Show prediction confidence level
