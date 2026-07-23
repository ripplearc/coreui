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
        expect(node.hasFlag(SemanticsFlag.isButton), isTrue);
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
