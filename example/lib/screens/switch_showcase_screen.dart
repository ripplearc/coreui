import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

class SwitchShowcaseScreen extends StatefulWidget {
  const SwitchShowcaseScreen({super.key});

  @override
  State<SwitchShowcaseScreen> createState() => _SwitchShowcaseScreenState();
}

class _SwitchShowcaseScreenState extends State<SwitchShowcaseScreen> {
  bool _basicSwitchValue = false;
  bool _lockValue = false;
  bool _showValue = false;
  bool _privacyValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Components'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Switches',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // Basic switches
            _buildSectionTitle(context, 'Basic Switches'),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomSwitch(
                  value: _basicSwitchValue,
                  onChanged: (value) {
                    setState(() {
                      _basicSwitchValue = value;
                    });
                  },
                  variant: SwitchVariant.basic,
                ),
                const SizedBox(width: 16),
                Text(
                  _basicSwitchValue ? 'ON' : 'OFF',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action switches
            _buildSectionTitle(context, 'Action Switches'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CustomSwitch(
                  value: _lockValue,
                  onChanged: (value) {
                    setState(() {
                      _lockValue = value;
                    });
                  },
                  variant: SwitchVariant.lockUnlock,
                  // activeColor: Colors.blue[700],
                  // activeTrackColor: Colors.blue[100],
                ),
                CustomSwitch(
                  value: _showValue,
                  onChanged: (value) {
                    setState(() {
                      _showValue = value;
                    });
                  },
                  variant: SwitchVariant.showHide,
                  // activeColor: Colors.blue[700],
                  // activeTrackColor: Colors.blue[100],
                ),
                CustomSwitch(
                  value: _privacyValue,
                  onChanged: (value) {
                    setState(() {
                      _privacyValue = value;
                    });
                  },
                  variant: SwitchVariant.privatePublic,
                  // activeColor: Colors.blue[700],
                  // activeTrackColor: Colors.blue[100],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
