import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';
import 'package:flutter_test/flutter_test.dart';

Future<MyAppState> loadMain(WidgetTester tester) async {
  //Kör hela inintState och hoppar till nästa frame
  await tester.pumpWidget(const MaterialApp(home: MyApp()));
  //ser även till så att alla saker efter att framen updaterats blir klara
  await tester.pumpAndSettle();
  //få staten
  final MyAppState state = tester.state<MyAppState>(find.byType(MyApp));

  return state;
}

void main() {
  group("generatAddButtons tests", () {
    testWidgets("generateAddButtons generates button on correct cordinates", (
      WidgetTester tester,
    ) async {
      MyAppState mas = await loadMain(tester);
      List<AddButton> addButtons = mas.generateAddButtons([
        (x: 1, y: 1),
        (x: 2, y: 2),
      ]);
      expect(addButtons.elementAt(0).x, 1);
      expect(addButtons.elementAt(0).y, 1);
      expect(addButtons.elementAt(1).x, 2);
      expect(addButtons.elementAt(1).y, 2);
    });

    testWidgets("generateAddButtons right amount of buttons", (
      WidgetTester tester,
    ) async {
      MyAppState mas = await loadMain(tester);
      List<AddButton> addButtons1 = mas.generateAddButtons([(x: 1, y: 1)]);
      List<AddButton> addButtons2 = mas.generateAddButtons([
        (x: 1, y: 1),
        (x: 2, y: 2),
      ]);
      expect(addButtons1.length, 1);
      expect(addButtons2.length, 2);
    });

    testWidgets("generateAddButtons generates button with uniq key", (
      WidgetTester tester,
    ) async {
      MyAppState mas = await loadMain(tester);
      List<AddButton> addButtons = mas.generateAddButtons([
        (x: 1, y: 1),
        (x: 2, y: 2),
      ]);
      expect(addButtons.elementAt(0).key != addButtons.elementAt(1).key, true);
    });
  });

  group("extractPots tests", () {
    testWidgets("extractPots rettruns empty list if no pots placed", (
      WidgetTester tester,
    ) async {
      MyAppState mas = await loadMain(tester);
      expect(mas.extractPots().length, 0);
    });

    testWidgets(
      "loadPotsOnAddButtonWithIndex places pot on right index and extractPots extracts correct index",
      (WidgetTester tester) async {
        final MyAppState mas = await loadMain(tester);
        mas.loadPotsOnAddButtonWithIndex([1, 2, 3]);
        await tester.pump();

        List<({Flower? flower, int index, Pot pot})> pots = mas.extractPots();

        expect(pots.elementAt(0).index, 1);
        expect(pots.elementAt(1).index, 2);
        expect(pots.elementAt(2).index, 3);
      },
    );
  });
}
