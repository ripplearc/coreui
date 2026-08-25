import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreInputChip', () {
    group('Rendering', () {
      testWidgets('renders label text', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(label: 'alice@example.com', onRemove: () {}),
            theme: CoreTheme.light(),
          ),
        );

        expect(find.text('alice@example.com'), findsOneWidget);
      });

      testWidgets('renders close icon when onRemove is provided', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(label: 'alice@example.com', onRemove: () {}),
            theme: CoreTheme.light(),
          ),
        );

        expect(find.byKey(CoreInputChip.removeButtonKey), findsOneWidget);
      });

      testWidgets('does not render remove button when onRemove is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestApp(
            const CoreInputChip(label: 'alice@example.com'),
            theme: CoreTheme.light(),
          ),
        );

        expect(find.byKey(CoreInputChip.removeButtonKey), findsNothing);
      });
    });

    group('Remove interaction', () {
      testWidgets('calls onRemove when remove button is tapped', (tester) async {
        var removed = false;

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'alice@example.com',
              onRemove: () => removed = true,
            ),
            theme: CoreTheme.light(),
          ),
        );

        await tester.tap(find.byKey(CoreInputChip.removeButtonKey));
        await tester.pump();

        expect(removed, isTrue);
      });

      testWidgets('does not call onRemove when the label is tapped in the '
          'default mode', (tester) async {
        var removed = false;

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'alice@example.com',
              onRemove: () => removed = true,
            ),
            theme: CoreTheme.light(),
          ),
        );

        await tester.tap(find.text('alice@example.com'));
        await tester.pump();

        expect(removed, isFalse);
      });
    });

    group('Whole-chip tap-to-remove', () {
      testWidgets('calls onRemove when any part of the chip is tapped', (
        tester,
      ) async {
        var removed = false;

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'Jan 05, 2026',
              onRemove: () => removed = true,
              removeOnChipTap: true,
            ),
            theme: CoreTheme.light(),
          ),
        );

        await tester.tap(find.text('Jan 05, 2026'));
        await tester.pump();

        expect(removed, isTrue);
      });

      testWidgets('still renders the close icon as the removal affordance', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'Jan 05, 2026',
              onRemove: () {},
              removeOnChipTap: true,
            ),
            theme: CoreTheme.light(),
          ),
        );

        expect(find.byKey(CoreInputChip.removeButtonKey), findsOneWidget);
      });

      testWidgets('exposes the whole chip as one semantic button labeled '
          'with removeSemanticLabel', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'Jan 05, 2026',
              onRemove: () {},
              removeOnChipTap: true,
              removeSemanticLabel: 'Clear date filter',
            ),
            theme: CoreTheme.light(),
          ),
        );

        expect(
          find.bySemanticsLabel('Clear date filter'),
          findsOneWidget,
        );
        // The close icon must not be a second, separately announced button.
        expect(find.bySemanticsLabel(RegExp('Remove')), findsNothing);

        handle.dispose();
      });

      testWidgets('keeps the tap region at the 48 dp minimum height', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'Jan 05, 2026',
              onRemove: () {},
              removeOnChipTap: true,
            ),
            theme: CoreTheme.light(),
          ),
        );

        expect(
          tester.getSize(find.byType(CoreInputChip)).height,
          greaterThanOrEqualTo(CoreSpacing.space12),
        );
      });

      testWidgets('has no effect while onRemove is null', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            const CoreInputChip(
              label: 'Jan 05, 2026',
              removeOnChipTap: true,
            ),
            theme: CoreTheme.light(),
          ),
        );

        expect(find.byKey(CoreInputChip.removeButtonKey), findsNothing);
        expect(find.byType(InkWell), findsNothing);
      });
    });

    group('Semantics', () {
      testWidgets('remove button exposes button role and label', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(label: 'alice@example.com', onRemove: () {}),
            theme: CoreTheme.light(),
          ),
        );

        final node = tester.getSemantics(
          find.byKey(CoreInputChip.removeButtonKey),
        );
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.label, contains('alice@example.com'));

        handle.dispose();
      });

      testWidgets('chip label is exposed as a container semantic node', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(label: 'alice@example.com', onRemove: () {}),
            theme: CoreTheme.light(),
          ),
        );

        final node = tester.getSemantics(find.byType(CoreInputChip));
        expect(node.label, contains('alice@example.com'));

        handle.dispose();
      });

      testWidgets('custom removeSemanticLabel replaces the default label', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'alice@example.com',
              onRemove: () {},
              removeSemanticLabel: 'Supprimer alice@example.com',
            ),
            theme: CoreTheme.light(),
          ),
        );

        final node = tester.getSemantics(
          find.byKey(CoreInputChip.removeButtonKey),
        );
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.label.split('\n'), contains('Supprimer alice@example.com'));
        expect(node.label, isNot(contains('Remove alice@example.com')));

        handle.dispose();
      });

      testWidgets('default remove label is used when removeSemanticLabel is null', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(label: 'alice@example.com', onRemove: () {}),
            theme: CoreTheme.light(),
          ),
        );

        final node = tester.getSemantics(
          find.byKey(CoreInputChip.removeButtonKey),
        );
        expect(node.label.split('\n'), contains('Remove alice@example.com'));

        handle.dispose();
      });

      testWidgets('default remove label is used when removeSemanticLabel is empty', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(
              label: 'alice@example.com',
              onRemove: () {},
              removeSemanticLabel: '',
            ),
            theme: CoreTheme.light(),
          ),
        );

        final node = tester.getSemantics(
          find.byKey(CoreInputChip.removeButtonKey),
        );
        expect(node.label.split('\n'), contains('Remove alice@example.com'));

        handle.dispose();
      });

      testWidgets('exactly one semantic button node exists (the remove button)', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          buildTestApp(
            CoreInputChip(label: 'alice@example.com', onRemove: () {}),
            theme: CoreTheme.light(),
          ),
        );

        expect(
          find.bySemanticsLabel(RegExp('Remove alice@example.com')),
          findsOneWidget,
        );

        handle.dispose();
      });
    });
  });
}
