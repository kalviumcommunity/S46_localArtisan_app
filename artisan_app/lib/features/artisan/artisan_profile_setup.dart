import 'package:flutter/material.dart';
import '../../core/colors.dart';


class ArtisanProfileSetup extends StatefulWidget {
  const ArtisanProfileSetup({super.key});

  @override
  State<ArtisanProfileSetup> createState() => _ArtisanProfileSetupState();
}

class _ArtisanProfileSetupState extends State<ArtisanProfileSetup> {
  int _currentStep = 1;
  final int _totalSteps = 3;

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      Navigator.pushReplacementNamed(context, '/artisan-dashboard');
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 1 
            ? IconButton(
                onPressed: _previousStep,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
              )
            : null,
        title: Text(
          'Profile Setup',
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Row(
              children: List.generate(_totalSteps, (index) {
                final stepNum = index + 1;
                final isCompleted = stepNum < _currentStep;
                final isActive = stepNum == _currentStep;
                
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted || isActive ? theme.primaryColor : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted 
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : Text(
                                  '$stepNum',
                                  style: TextStyle(
                                    color: isCompleted || isActive ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      if (index < _totalSteps - 1)
                        Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isCompleted ? theme.primaryColor : Colors.grey[200],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   if (_currentStep == 1) ...[
                    Text('Tell us about your craft', style: theme.textTheme.displayMedium),
                    const SizedBox(height: 12),
                    Text('Help customers find your unique creations.', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
                    const SizedBox(height: 40),
                    Text('Artisan / Business Name', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(hintText: 'e.g. Earthy Pots Studio'),
                    ),
                    const SizedBox(height: 24),
                    Text('Craft Category', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(hintText: 'e.g. Pottery, Weaving, Painting'),
                    ),
                  ] else if (_currentStep == 2) ...[
                    Text('Where are you located?', style: theme.textTheme.displayMedium),
                    const SizedBox(height: 12),
                    Text('Let nearby customers know where to find you.', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
                    const SizedBox(height: 40),
                    Text('Studio/Shop Location', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Contact Details', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Phone number or Social handle',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                  ] else ...[
                    Text('Your Creative Story', style: theme.textTheme.displayMedium),
                    const SizedBox(height: 12),
                    Text('Share the passion behind your handmade crafts.', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
                    const SizedBox(height: 40),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withAlpha(20),
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.primaryColor.withAlpha(50), width: 2),
                            ),
                            child: Icon(Icons.add_a_photo_outlined, size: 40, color: theme.primaryColor),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text('Short Bio / Shop Description', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Tell customers about your journey and what makes your crafts special...',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: _nextStep,
              child: Text(_currentStep == _totalSteps ? 'Complete Setup' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

