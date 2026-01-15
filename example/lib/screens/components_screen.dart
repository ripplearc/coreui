import 'package:example/screens/bottom_navigation_showcase_screen.dart';
import 'package:example/screens/button_showcase_screen.dart';
import 'package:example/screens/keyboard_showcase_screen.dart';
import 'package:example/screens/loading_indicator_showcase_screen.dart';
import 'package:example/screens/single_selector_showcase_screen.dart';
import 'package:example/screens/success_modal_showcase_screen.dart';
import 'package:example/screens/switch_showcase_screen.dart';
import 'package:example/screens/text_field_showcase_screen.dart';
import 'package:example/screens/toast_showcase_screen.dart';
import 'package:example/screens/tooltip_showcase_screen.dart';
import 'package:flutter/material.dart';

class ComponentsScreen extends StatelessWidget {
  const ComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('UI Components', style: textTheme.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Component Showcases',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildShowcaseButton(
              context,
              'Text Field Components',
              const TextFieldScreen(),
            ),
            _buildShowcaseButton(
              context,
              'Single Select Field Components',
              const SingleItemSelectorShowcaseScreen(),
            ),
            _buildShowcaseButton(
              context,
              'Button Components',
              const ButtonShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Toast Components',
              const ToastShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Tooltip Components',
              const TooltipShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Switch Components',
              const SwitchShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Success Modal Components',
              const SuccessModalShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Bottom Navigation Components',
              const BottomNavigationShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Keyboard Components',
              const KeyboardShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Loading Indicator Components',
              const LoadingIndicatorShowcaseScreen(),
            ),
            // Add more component showcases here as they become available
          ],
        ),
      ),
    );
  }

  Widget _buildShowcaseButton(
      BuildContext context, String label, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
