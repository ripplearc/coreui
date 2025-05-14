import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

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
              'Our icon system provides standardized icons in different sizes.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Small icons (16x16)
            _buildIconSizeSection(context, 'Small Icons (16x16)', [
              _buildIconItem(
                  'infoSmall', CoreIcons.getSmallIcon(CoreIcons.infoSmall)),
              _buildIconItem('warningSmall',
                  CoreIcons.getSmallIcon(CoreIcons.warningSmall)),
              _buildIconItem(
                  'errorSmall', CoreIcons.getSmallIcon(CoreIcons.errorSmall)),
              _buildIconItem('calendarSmall',
                  CoreIcons.getSmallIcon(CoreIcons.calendarSmall)),
              _buildIconItem(
                  'gridSmall', CoreIcons.getSmallIcon(CoreIcons.gridSmall)),
              _buildIconItem(
                  'closeSmall', CoreIcons.getSmallIcon(CoreIcons.closeSmall)),
              _buildIconItem('arrowRightSmall',
                  CoreIcons.getSmallIcon(CoreIcons.arrowRightSmall)),
            ]),

            const SizedBox(height: 32),

            // Medium icons (20x20)
            _buildIconSizeSection(context, 'Medium Icons (20x20)', [
              _buildIconItem('closeMedium',
                  CoreIcons.getMediumIcon(CoreIcons.closeMedium)),
              _buildIconItem(
                  'gridMedium', CoreIcons.getMediumIcon(CoreIcons.gridMedium)),
              _buildIconItem('expandMoreMedium',
                  CoreIcons.getMediumIcon(CoreIcons.expandMoreMedium)),
              _buildIconItem(
                  'editMedium', CoreIcons.getMediumIcon(CoreIcons.editMedium)),
              _buildIconItem(
                  'infoMedium', CoreIcons.getMediumIcon(CoreIcons.infoMedium)),
              _buildIconItem(
                  'helpMedium', CoreIcons.getMediumIcon(CoreIcons.helpMedium)),
              _buildIconItem('expandLessMedium',
                  CoreIcons.getMediumIcon(CoreIcons.expandLessMedium)),
              _buildIconItem('collapseMedium',
                  CoreIcons.getMediumIcon(CoreIcons.collapseMedium)),
              _buildIconItem('personMedium',
                  CoreIcons.getMediumIcon(CoreIcons.personMedium)),
              _buildIconItem('emailMedium',
                  CoreIcons.getMediumIcon(CoreIcons.emailMedium)),
              _buildIconItem('percentMedium',
                  CoreIcons.getMediumIcon(CoreIcons.percentMedium)),
              _buildIconItem('minusMedium',
                  CoreIcons.getMediumIcon(CoreIcons.minusMedium)),
              _buildIconItem('slashMedium',
                  CoreIcons.getMediumIcon(CoreIcons.slashMedium)),
              // _buildIconItem('divideMedium', CoreIcons.getMediumIcon(CoreIcons.divideMedium)),
              _buildIconItem('cancelMedium',
                  CoreIcons.getMediumIcon(CoreIcons.cancelMedium)),
              _buildIconItem(
                  'addMedium', CoreIcons.getMediumIcon(CoreIcons.addMedium)),
              _buildIconItem('plusMinusMedium',
                  CoreIcons.getMediumIcon(CoreIcons.plusMinusMedium)),
              _buildIconItem('arrowRightMedium',
                  CoreIcons.getMediumIcon(CoreIcons.arrowRightMedium)),
              _buildIconItem(
                  'linkMedium', CoreIcons.getMediumIcon(CoreIcons.linkMedium)),
              _buildIconItem('deleteMedium',
                  CoreIcons.getMediumIcon(CoreIcons.deleteMedium)),
              _buildIconItem('checkboxMedium',
                  CoreIcons.getMediumIcon(CoreIcons.checkboxMedium)),
              _buildIconItem('calendarMedium',
                  CoreIcons.getMediumIcon(CoreIcons.calendarMedium)),
              _buildIconItem(
                  'moreMedium', CoreIcons.getMediumIcon(CoreIcons.moreMedium)),
              _buildIconItem('clockMedium',
                  CoreIcons.getMediumIcon(CoreIcons.clockMedium)),
              _buildIconItem(
                  'backMedium', CoreIcons.getMediumIcon(CoreIcons.backMedium)),
              _buildIconItem('searchMedium',
                  CoreIcons.getMediumIcon(CoreIcons.searchMedium)),
              _buildIconItem('settingsMedium',
                  CoreIcons.getMediumIcon(CoreIcons.settingsMedium)),
              _buildIconItem(
                  'codeMedium', CoreIcons.getMediumIcon(CoreIcons.codeMedium)),
              _buildIconItem('imageMedium',
                  CoreIcons.getMediumIcon(CoreIcons.imageMedium)),
              _buildIconItem('favoriteMedium',
                  CoreIcons.getMediumIcon(CoreIcons.favoriteMedium)),
            ]),

            const SizedBox(height: 32),

            // Large icons (24x24)
            _buildIconSizeSection(context, 'Large Icons (24x24)', [
              _buildIconItem(
                  'visibility', CoreIcons.getLargeIcon(CoreIcons.visibility)),
              _buildIconItem('visibilityOff',
                  CoreIcons.getLargeIcon(CoreIcons.visibilityOff)),
              _buildIconItem('info', CoreIcons.getLargeIcon(CoreIcons.info)),
              _buildIconItem(
                  'warning', CoreIcons.getLargeIcon(CoreIcons.warning)),
              _buildIconItem('error', CoreIcons.getLargeIcon(CoreIcons.error)),
              _buildIconItem('help', CoreIcons.getLargeIcon(CoreIcons.help)),
              _buildIconItem(
                  'expandMore', CoreIcons.getLargeIcon(CoreIcons.expandMore)),
              _buildIconItem('check', CoreIcons.getLargeIcon(CoreIcons.check)),
              _buildIconItem('email', CoreIcons.getLargeIcon(CoreIcons.email)),
              _buildIconItem(
                  'google', CoreIcons.getLargeIcon(CoreIcons.google)),
              _buildIconItem(
                  'facebook', CoreIcons.getLargeIcon(CoreIcons.facebook)),
              _buildIconItem(
                  'arrowBack', CoreIcons.getLargeIcon(CoreIcons.arrowBack)),
              _buildIconItem('apple', CoreIcons.getLargeIcon(CoreIcons.apple)),
              _buildIconItem(
                  'microsoft', CoreIcons.getLargeIcon(CoreIcons.microsoft)),
              _buildIconItem(
                  'mobile', CoreIcons.getLargeIcon(CoreIcons.mobile)),
              _buildIconItem(
                  'person', CoreIcons.getLargeIcon(CoreIcons.person)),
              _buildIconItem('add', CoreIcons.getLargeIcon(CoreIcons.add)),
              _buildIconItem(
                  'square', CoreIcons.getLargeIcon(CoreIcons.square)),
              _buildIconItem(
                  'checkSquare', CoreIcons.getLargeIcon(CoreIcons.checkSquare)),
              _buildIconItem('bell', CoreIcons.getLargeIcon(CoreIcons.bell)),
              _buildIconItem(
                  'search', CoreIcons.getLargeIcon(CoreIcons.search)),
              _buildIconItem('list', CoreIcons.getLargeIcon(CoreIcons.list)),
              _buildIconItem('grid', CoreIcons.getLargeIcon(CoreIcons.grid)),
              _buildIconItem('user', CoreIcons.getLargeIcon(CoreIcons.user)),
              _buildIconItem('home', CoreIcons.getLargeIcon(CoreIcons.home)),
              _buildIconItem('image', CoreIcons.getLargeIcon(CoreIcons.image)),
              _buildIconItem('more', CoreIcons.getLargeIcon(CoreIcons.more)),
              _buildIconItem('edit', CoreIcons.getLargeIcon(CoreIcons.edit)),
              _buildIconItem(
                  'delete', CoreIcons.getLargeIcon(CoreIcons.delete)),
              _buildIconItem(
                  'favorite', CoreIcons.getLargeIcon(CoreIcons.favorite)),
              _buildIconItem('file', CoreIcons.getLargeIcon(CoreIcons.file)),
              _buildIconItem('copy', CoreIcons.getLargeIcon(CoreIcons.copy)),
              _buildIconItem(
                  'calendar', CoreIcons.getLargeIcon(CoreIcons.calendar)),
              _buildIconItem('clock', CoreIcons.getLargeIcon(CoreIcons.clock)),
              _buildIconItem(
                  'download', CoreIcons.getLargeIcon(CoreIcons.download)),
              _buildIconItem(
                  'calculator', CoreIcons.getLargeIcon(CoreIcons.calculator)),
              _buildIconItem(
                  'dollar', CoreIcons.getLargeIcon(CoreIcons.dollar)),
              _buildIconItem(
                  'camera', CoreIcons.getLargeIcon(CoreIcons.camera)),
              _buildIconItem('chart', CoreIcons.getLargeIcon(CoreIcons.chart)),
              _buildIconItem(
                  'arrowUp', CoreIcons.getLargeIcon(CoreIcons.arrowUp)),
              _buildIconItem(
                  'percent', CoreIcons.getLargeIcon(CoreIcons.percent)),
            ]),

            const SizedBox(height: 32),

            // Extra Large icons (32x32)
            _buildIconSizeSection(context, 'Extra Large Icons (32x32)', [
              _buildIconItem('documentLarge',
                  CoreIcons.getExtraLargeIcon(CoreIcons.documentLarge)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSizeSection(
      BuildContext context, String title, List<Widget> icons) {
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
      ],
    );
  }

  Widget _buildIconItem(String name, Widget icon) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: icon,
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
