import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';
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
  group("all mainScreen tests", () {
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
        expect(
          addButtons.elementAt(0).key != addButtons.elementAt(1).key,
          true,
        );
      });
    });

    group("loadPotsOnAddButtonWithIndex tests", () {
      testWidgets("loadPotsOnAddButtonWithIndex: empty list do not chrash", (
        WidgetTester tester,
      ) async {
        MyAppState mas = await loadMain(tester);
        mas.loadPotsOnAddButtonWithIndex([]);
      });

      testWidgets("loadPotsOnAddButtonWithIndex: Invalid index", (
        WidgetTester tester,
      ) async {
        MyAppState mas = await loadMain(tester);
        mas.loadPotsOnAddButtonWithIndex([1000000000]);
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

    group("parseClolor tests", () {
      testWidgets("parseClolor: Hex color work with #", (
        WidgetTester tester,
      ) async {
        final MyAppState mas = await loadMain(tester);
        expect(mas.parseColor("#02f091"), Color(0xff02f091));
      });
      testWidgets("parseClolor: Hex color work without #", (
        WidgetTester tester,
      ) async {
        final MyAppState mas = await loadMain(tester);
        expect(mas.parseColor("02f091"), Color(0xff02f091));
      });

      testWidgets("parseClolor: if hex null returns pink", (
        WidgetTester tester,
      ) async {
        final MyAppState mas = await loadMain(tester);
        expect(mas.parseColor(null), Colors.pink);
      });

      testWidgets("parseClolor: if unparebel string reurn pink", (
        WidgetTester tester,
      ) async {
        final MyAppState mas = await loadMain(tester);
        expect(mas.parseColor("Test"), Colors.pink);
      });
    });

    group("buildFlower tests", () {
      testWidgets("buildFlower returns correct flower", (
        WidgetTester tester,
      ) async {
        final MyAppState mas = await loadMain(tester);
        expect(
          mas.buildFlower({
            'template': 'ROSE',
            'color': '#FFFFFF',
            'commonName': 'Test Ros',
          }),
          isA<RoseFlower>(),
        );
        expect(
          mas.buildFlower({
            'template': 'SUNFLOWER',
            'color': '#FFFFFF',
            'commonName': 'Test Ros',
          }),
          isA<SunFlower>(),
        );
        expect(
          mas.buildFlower({
            'template': 'TULIP',
            'color': '#FFFFFF',
            'commonName': 'Test Ros',
          }),
          isA<TulipFlower>(),
        );
        expect(
          mas.buildFlower({
            'template': 'WOODANEMONE',
            'color': '#FFFFFF',
            'commonName': 'Test Ros',
          }),
          isA<WoodanemoneFlower>(),
        );
      });

      testWidgets("buildFlower returns generic flower if unkown flower type", (
        WidgetTester tester,
      ) async {
        final MyAppState mas = await loadMain(tester);
        expect(
          mas.buildFlower({
            'template': 'Intet existerand blomma',
            'color': '#FFFFFF',
            'commonName': 'Test Ros',
          }),
          isA<GenericFlower>(),
        );
      });

      testWidgets("buildFlower Giwes correct name an color", (
        WidgetTester tester,
      ) async {
        String name = "testNamn";
        final MyAppState mas = await loadMain(tester);
        Flower flower = mas.buildFlower({
          'template': 'ROSE',
          'color': '#FFFFFF',
          'commonName': name,
        });
        expect(flower.color, Color(0xFFFFFFFF));
        expect(flower.name, name);
      });

      testWidgets(
        "buildFlower: null values on name and type gives unkown and generic",
        (WidgetTester tester) async {
          final MyAppState mas = await loadMain(tester);
          Flower flower = mas.buildFlower({
            'template': null,
            'color': '#FFFFFF',
            'commonName': null,
          });
          expect(flower.name, "Unknown");
          expect(flower, isA<GenericFlower>());
        },
      );
    });
  });
}
