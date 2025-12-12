import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../widgets/app_widgets.dart';

/// Example usage of the theme system
/// This file demonstrates how to use the design system components
class ThemeExampleScreen extends StatelessWidget {
  const ThemeExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Card Example
            const HeroCard(
              child: Column(
                children: [
                  GradientText(
                    text: 'Hero Match',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('This is a hero card example'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Standard Card Example
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Match Card',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Text('3 - 2'),
                ],
              ),
              onTap: () {
                // Handle tap
              },
            ),
            
            const SizedBox(height: 24),
            
            // Gradient Button Example
            GradientButton(
              text: 'Submit Prediction',
              onPressed: () {
                // Handle button press
              },
            ),
            
            const SizedBox(height: 24),
            
            // Text Styles Example
            Text(
              'Headline Large',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Title Medium',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Body Medium',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Secondary Text',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            const SizedBox(height: 24),
            
            // Input Field Example
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter score',
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Color Palette Display
            Text(
              'Color Palette',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _ColorBox(
              color: AppColors.background,
              label: 'Background\n#181928',
            ),
            const SizedBox(height: 8),
            _ColorBox(
              color: AppColors.cardSurface,
              label: 'Card Surface\n#222232',
            ),
            const SizedBox(height: 8),
            _ColorBox(
              color: AppColors.gradientBlue,
              label: 'Gradient Blue\n#4568DC',
            ),
            const SizedBox(height: 8),
            _ColorBox(
              color: AppColors.gradientPurple,
              label: 'Gradient Purple\n#B06AB3',
            ),
            const SizedBox(height: 8),
            _ColorBox(
              color: AppColors.textSecondary,
              label: 'Text Secondary\n#D2B5FF',
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorBox({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
