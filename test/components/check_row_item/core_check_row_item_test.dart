import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreCheckRowItem – general', () {
    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('renders an optional subtitle', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'Floyd Miles',
            subtitle: 'floyd@acme.com',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Floyd Miles'), findsOneWidget);
      expect(find.text('floyd@acme.com'), findsOneWidget);
    });

    testWidgets('defaults the leading widget to a CoreInitialAvatar',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(CoreInitialAvatar), findsOneWidget);
    });

    testWidgets('custom leading widget replaces the default avatar',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
            leading: const Icon(Icons.star),
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(CoreInitialAvatar), findsNothing);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('passes avatar color overrides to the default leading avatar',
        (tester) async {
      final theme = CoreTheme.light();
      final customBg = theme.coreColors.backgroundGreenLight;
      final customText = theme.coreColors.iconGreen;

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
            avatarBackgroundColor: customBg,
            avatarTextColor: customText,
          ),
          theme: theme,
        ),
      );

      final avatar = tester.widget<CoreInitialAvatar>(
        find.byType(CoreInitialAvatar),
      );
      expect(avatar.backgroundColor, customBg);
      expect(avatar.textColor, customText);
    });

    testWidgets('shows the checked icon when selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: true,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final icon = tester.widget<CoreIconWidget>(
        find.byType(CoreIconWidget).first,
      );
      expect(icon.icon, CoreIcons.check);
    });

    testWidgets('shows the unchecked icon when not selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final icon = tester.widget<CoreIconWidget>(
        find.byType(CoreIconWidget).first,
      );
      expect(icon.icon, CoreIcons.checkBlank);
    });

    testWidgets('tapping the row toggles selection via onChanged',
        (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (value) => newValue = value,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(newValue, isTrue);
    });

    testWidgets('tapping a selected row calls onChanged with false',
        (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: true,
            onChanged: (value) => newValue = value,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(newValue, isFalse);
    });

    testWidgets('default semantic label uses the title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCheckRowItem));
      expect(semantics.label, 'John Doe');
    });

    testWidgets('custom semantic label overrides the default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
            semanticLabel: 'Owner John Doe, unchecked',
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCheckRowItem));
      expect(semantics.label, 'Owner John Doe, unchecked');
    });
  });
}
