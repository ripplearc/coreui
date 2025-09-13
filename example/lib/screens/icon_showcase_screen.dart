import 'package:ripplearc_coreui/core_ui.dart';
import 'package:flutter/material.dart';

class IconShowcaseScreen extends StatelessWidget {
  const IconShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Icon System',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Our icon system combines Material Design icons with custom SVG icons, organized by category for easy access.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Brand & Services
            _buildCategorySection(
              context,
              'Brand & Services',
              [
                _buildIconSet('Microsoft', CoreIcons.microsoft),
                _buildIconSet('OneDrive', CoreIcons.onedrive),
                _buildIconSet('Dropbox', CoreIcons.dropbox),
                _buildIconSet('Google Drive', CoreIcons.googleDrive),
                _buildIconSet('Google', CoreIcons.google),
                _buildIconSet('facebook', CoreIcons.facebook,
                    color: Colors.blue, size: 34),
              ],
            ),

            // Navigation
            _buildCategorySection(
              context,
              'Navigation',
              [
                _buildIconSet('Arrow Left', CoreIcons.arrowLeft),
                _buildIconSet('Arrow Right', CoreIcons.arrowRight),
                _buildIconSet('Arrow Up', CoreIcons.arrowUp),
                _buildIconSet('Arrow Down', CoreIcons.arrowDown),
                _buildIconSet('Drop Down', CoreIcons.arrowDropDown),
                _buildIconSet('Drop Up', CoreIcons.arrowDropUp),
                _buildIconSet('More Vert', CoreIcons.moreVert),
                _buildIconSet('More Horiz', CoreIcons.moreHoriz),
                _buildIconSet('Backspace Left', CoreIcons.backspaceLeft),
              ],
            ),

            // Actions
            _buildCategorySection(
              context,
              'Actions',
              [
                _buildIconSet('Add', CoreIcons.add),
                _buildIconSet('Remove', CoreIcons.minus),
                _buildIconSet('Edit', CoreIcons.edit),
                _buildIconSet('Delete', CoreIcons.delete),
                _buildIconSet('Rename', CoreIcons.rename),
                _buildIconSet('Close', CoreIcons.close),
                _buildIconSet('Search', CoreIcons.search),
                _buildIconSet('Refresh', CoreIcons.refresh),
                _buildIconSet('Settings', CoreIcons.settings),
                _buildIconSet('Download', CoreIcons.download),
                _buildIconSet('Share', CoreIcons.share),
                _buildIconSet('Copy', CoreIcons.copy),
                _buildIconSet('Launch', CoreIcons.launch),
                _buildIconSet('Plagiarism', CoreIcons.plagiarism),
              ],
            ),

            // Math & Calculation
            _buildCategorySection(
              context,
              'Math & Calculation',
              [
                _buildIconSet('Calculate', CoreIcons.calculate),
                _buildIconSet('Calculator', CoreIcons.calculator),
                _buildIconSet('Divide', CoreIcons.divide),
                _buildIconSet('Plus/Minus', CoreIcons.plusMinus),
                _buildIconSet('Slash', CoreIcons.slash),
              ],
            ),

            // Status
            _buildCategorySection(
              context,
              'Status',
              [
                _buildIconSet('Info', CoreIcons.info),
                _buildIconSet('Warning', CoreIcons.warning),
                _buildIconSet('Error', CoreIcons.error),
                _buildIconSet('Success', CoreIcons.success),
                _buildIconSet('Help', CoreIcons.help),
              ],
            ),

            // Communication
            _buildCategorySection(
              context,
              'Communication',
              [
                _buildIconSet('Email', CoreIcons.email),
                _buildIconSet('Message', CoreIcons.message),
                _buildIconSet('Notification', CoreIcons.notification),
                _buildIconSet('Phone', CoreIcons.phone),
              ],
            ),

            // Files & Media
            _buildCategorySection(
              context,
              'Files & Media',
              [
                _buildIconSet('File', CoreIcons.file),
                _buildIconSet('Image', CoreIcons.image),
                _buildIconSet('Camera', CoreIcons.camera),
              ],
            ),

            // Interface
            _buildCategorySection(
              context,
              'Interface',
              [
                _buildIconSet('Home', CoreIcons.home),
                _buildIconSet('List', CoreIcons.list),
                _buildIconSet('Placeholder', CoreIcons.placeholder),
              ],
            ),

            // User Management
            _buildCategorySection(
              context,
              'User Management',
              [
                _buildIconSet('Person', CoreIcons.person),
                _buildIconSet('People', CoreIcons.people),
                _buildIconSet('Add Person', CoreIcons.personAdd),
                _buildIconSet('Members', CoreIcons.members),
              ],
            ),

            // Security
            _buildCategorySection(
              context,
              'Security',
              [
                _buildIconSet('Lock', CoreIcons.lock),
                _buildIconSet('Unlock', CoreIcons.unlock),
              ],
            ),

            // Date & Time
            _buildCategorySection(
              context,
              'Date & Time',
              [
                _buildIconSet('Calendar', CoreIcons.calendar),
                _buildIconSet('History', CoreIcons.history),
              ],
            ),

            // Device
            _buildCategorySection(
              context,
              'Device',
              [],
            ),

            // Business
            _buildCategorySection(
              context,
              'Business',
              [
                _buildIconSet('Cost', CoreIcons.cost),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<Widget> icons,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: icons,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildIconSet(String name, CoreIconData icon,
      {double? size, Color? color}) {
    {
      return SizedBox(
        width: 100,
        child: Column(
          children: [
            CoreIconWidget(
              icon: icon,
              size: size ?? 34,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
  }
}
