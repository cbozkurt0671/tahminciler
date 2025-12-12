# Core Theme System

This directory contains the design system implementation for the World Cup Prediction App.

## Files Structure

```
lib/core/theme/
├── app_colors.dart      # Color palette and design tokens
├── app_theme.dart       # Master ThemeData configuration
└── theme_example.dart   # Usage examples

lib/core/widgets/
└── app_widgets.dart     # Reusable styled components
```

## Design Specifications

### Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `AppColors.background` | `#181928` | Deep Navy - Main background |
| `AppColors.cardSurface` | `#222232` | Soft Dark Blue - Cards |
| `AppColors.gradientBlue` | `#4568DC` | Primary gradient start |
| `AppColors.gradientPurple` | `#B06AB3` | Primary gradient end |
| `AppColors.textPrimary` | `#FFFFFF` | Primary text (White) |
| `AppColors.textSecondary` | `#D2B5FF` | Secondary text (Lavender) |

### Typography

**Font Family:** Poppins (via Google Fonts)

All text styles are predefined in the theme and accessible via:
```dart
Theme.of(context).textTheme.headlineLarge
Theme.of(context).textTheme.titleMedium
Theme.of(context).textTheme.bodyMedium
// ... etc
```

### Border Radius

- **Main Cards:** `15px` (`AppColors.cardRadius`)
- **Screen Corners:** `28px` (`AppColors.screenRadius`)

### Shadows

Standard card shadow is predefined:
```dart
boxShadow: AppColors.cardShadow
```
Equivalent to: `box-shadow: 10px 5px 34px rgba(0, 0, 0, 0.65)`

## Usage

### 1. Apply Theme in MaterialApp

```dart
import 'core/theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.darkTheme,
  // ...
)
```

### 2. Use Color Tokens

```dart
Container(
  color: AppColors.background,
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)
```

### 3. Use Reusable Components

#### Standard Card
```dart
AppCard(
  child: YourContent(),
  onTap: () {}, // Optional
)
```

#### Hero Card (for featured match)
```dart
HeroCard(
  child: YourContent(),
)
```

#### Gradient Button
```dart
GradientButton(
  text: 'Submit',
  onPressed: () {},
  isLoading: false, // Optional
)
```

#### Gradient Text
```dart
GradientText(
  text: 'Hero Title',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### 4. Text Styles

Always use theme text styles instead of hardcoding:

```dart
// ✅ GOOD
Text(
  'Title',
  style: Theme.of(context).textTheme.titleLarge,
)

// ❌ BAD
Text(
  'Title',
  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
)
```

### 5. Input Fields

Text fields automatically use the theme's input decoration:

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Score',
  ),
)
```

## Key Principles

1. **Never hardcode colors** - Always use `AppColors.*`
2. **Never hardcode text styles** - Always use `Theme.of(context).textTheme.*`
3. **Use component widgets** - Prefer `AppCard`, `GradientButton`, etc.
4. **Maintain consistency** - Stick to the design tokens
5. **DRY (Don't Repeat Yourself)** - Reuse styles through the theme system

## Example Screen

See `theme_example.dart` for a complete demonstration of all theme components.

## Adding New Components

When creating new reusable components:

1. Add them to `lib/core/widgets/app_widgets.dart`
2. Ensure they use `AppColors` and theme text styles
3. Apply standard shadows and border radius where appropriate
4. Document usage in this README

## Customization

To modify the design system:

1. **Colors:** Update values in `app_colors.dart`
2. **Typography:** Modify text styles in `app_theme.dart`
3. **Component styles:** Edit `app_widgets.dart`

All changes will automatically propagate throughout the app.
