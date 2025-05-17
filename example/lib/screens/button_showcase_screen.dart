import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ButtonShowcaseScreen extends StatelessWidget {
  const ButtonShowcaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Showcase'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Large Buttons (48px)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CoreButton(
                  label: 'Primary',
                  size: CoreButtonSize.large,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Secondary',
                  size: CoreButtonSize.large,
                  variant: CoreButtonVariant.secondary,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Disabled',
                  size: CoreButtonSize.large,
                  isDisabled: true,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'With Icon',
                  size: CoreButtonSize.large,
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Loading',
                  size: CoreButtonSize.large,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Medium Buttons (40px)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CoreButton(
                  label: 'Primary',
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Secondary',
                  variant: CoreButtonVariant.secondary,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Disabled',
                  isDisabled: true,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'With Icon',
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Loading',
                  // isLoading: true,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Small Buttons (36px)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CoreButton(
                  label: 'Primary',
                  size: CoreButtonSize.small,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Secondary',
                  size: CoreButtonSize.small,
                  variant: CoreButtonVariant.secondary,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Disabled',
                  size: CoreButtonSize.small,
                  isDisabled: true,
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'With Icon',
                  size: CoreButtonSize.small,
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                CoreButton(
                  label: 'Loading',
                  size: CoreButtonSize.small,
                  // isLoading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
