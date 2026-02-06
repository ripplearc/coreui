import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:flutter/material.dart';

class SwitchShowcaseScreen extends StatefulWidget {
  const SwitchShowcaseScreen({super.key});

  @override
  State<SwitchShowcaseScreen> createState() => _SwitchShowcaseScreenState();
}

class _SwitchShowcaseScreenState extends State<SwitchShowcaseScreen> {
  bool isLocked = false;
  bool isPrivate = false;
  bool isMetric = false;
  bool normalCompact = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Core Switch Showcase')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Switch Types',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Normal Type Section
            Text(
              'Normal Type (Grey, Width: 71px labeled / 32px compact)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              runSpacing: 15,
              spacing: 20,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Compact (no labels):'),
                    const SizedBox(height: 5),
                    CoreSwitch(
                      type: CoreSwitchType.normal,
                      value: normalCompact,
                      onChanged: (v) => setState(() => normalCompact = v),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('With labels:'),
                    const SizedBox(height: 5),
                    CoreSwitch(
                      type: CoreSwitchType.normal,
                      value: isPrivate,
                      onChanged: (v) => setState(() => isPrivate = v),
                      activeLabel: 'Public',
                      inactiveLabel: 'Private',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Lock Type Section
            Text(
              'Lock Type (Red, Width: 71px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lock/Unlock switch:'),
                const SizedBox(height: 5),
                CoreSwitch(
                  type: CoreSwitchType.lock,
                  value: isLocked,
                  onChanged: (v) => setState(() => isLocked = v),
                  activeLabel: 'Lock',
                  inactiveLabel: 'Unlock',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Imperial Type Section
            Text(
              'Imperial Type (Green, Width: 77px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Metric/Imperial switch:'),
                const SizedBox(height: 5),
                CoreSwitch(
                  type: CoreSwitchType.imperial,
                  value: isMetric,
                  onChanged: (v) => setState(() => isMetric = v),
                  activeLabel: 'Metric',
                  inactiveLabel: 'Imperial',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
