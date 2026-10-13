import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  Future<void> pumpWithSemantics(
    WidgetTester tester,
    Widget field,
    Future<void> Function() body,
  ) async {
    final semanticsHandle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(body: field),
        ),
      );
      await body();
    } finally {
      semanticsHandle.dispose();
    }
  }

  group('CoreUnderlineTextField – accessibility', () {
    for (final size in CoreUnderlineTextFieldSize.values) {
      testWidgets('${size.name} meets tap target, label and contrast rules',
          (tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => CoreUnderlineTextField(
            label: 'Equipment',
            initialValue: 'Mini excavator',
            size: size,
          ),
          find.byType(CoreUnderlineTextField),
        );
      });
    }

    testWidgets('prefix, unit and a trailing button meet the guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreUnderlineTextField(
          label: 'Rate',
          prefixText: r'$',
          initialValue: '145.00',
          unitText: '/day',
          trailing: IconButton(
            tooltip: 'Look up a rate',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ),
        find.byType(CoreUnderlineTextField),
      );
    });

    testWidgets('reads the prefix, then the field, then the unit',
        (tester) async {
      await pumpWithSemantics(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          prefixText: r'$',
          initialValue: '145.00',
          unitText: '/day',
        ),
        () async {
          final labels = <String>[];
          void visit(SemanticsNode node) {
            final label = node.getSemanticsData().label;
            if (label.isNotEmpty) labels.add(label);
            node.visitChildren((child) {
              visit(child);
              return true;
            });
          }

          visit(
              tester.binding.pipelineOwner.semanticsOwner!.rootSemanticsNode!);

          expect(
            labels.where((l) => [r'$', 'Rate', '/day'].contains(l)).toList(),
            [r'$', 'Rate', '/day'],
          );
        },
      );
    });

    testWidgets(
        'an empty field meets the text contrast rule '
        '(the guideline does not check hint text)', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreUnderlineTextField(
          label: 'Equipment',
          hintText: 'Name the equipment',
        ),
        find.byType(CoreUnderlineTextField),
      );
    });

    testWidgets('the text field announces its label and its value',
        (tester) async {
      await pumpWithSemantics(
        tester,
        const CoreUnderlineTextField(
          label: 'Equipment',
          initialValue: 'Mini excavator',
        ),
        () async {
          final data =
              tester.getSemantics(find.byType(TextField)).getSemanticsData();

          expect(data.label, 'Equipment');
          expect(data.value, 'Mini excavator');
          expect(data.flagsCollection.isTextField, isTrue);
        },
      );
    });

    testWidgets(
        'the text field node is 48px tall though the row is drawn thinner',
        (tester) async {
      for (final size in CoreUnderlineTextFieldSize.values) {
        await pumpWithSemantics(
          tester,
          CoreUnderlineTextField(label: 'Equipment', size: size),
          () async {
            final rect = tester.getSemantics(find.byType(TextField)).rect;

            expect(rect.height, greaterThanOrEqualTo(48));
          },
        );
      }
    });

    testWidgets('the visible label is not announced a second time',
        (tester) async {
      await pumpWithSemantics(
        tester,
        const CoreUnderlineTextField(label: 'Equipment'),
        () async {
          expect(find.bySemanticsLabel('Equipment'), findsOneWidget);
        },
      );
    });

    testWidgets('gaining focus reports the field as focused', (tester) async {
      await pumpWithSemantics(
        tester,
        const CoreUnderlineTextField(label: 'Equipment'),
        () async {
          await tester.tap(find.byType(TextField));
          await tester.pumpAndSettle();

          final data =
              tester.getSemantics(find.byType(TextField)).getSemanticsData();
          expect(data.flagsCollection.isFocused, ui.Tristate.isTrue);
        },
      );
    });
  });
}
