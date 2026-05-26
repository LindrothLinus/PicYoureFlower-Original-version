import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:test/test.dart';

void main(){
  test("generateAddButtons generates button on correct cordinates", (){
    MyAppState mas = MyAppState();
    List<AddButton> addButtons = mas.generateAddButtons([(x:1,y:1),(x:2,y:2)]);
    expect(addButtons.elementAt(0).x, 1);
    expect(addButtons.elementAt(0).y, 1);
    expect(addButtons.elementAt(1).x, 2);
    expect(addButtons.elementAt(1).y, 2);
  });

  test("generateAddButtons right amount of buttons",(){
    MyAppState mas = MyAppState();
    List<AddButton> addButtons1 = mas.generateAddButtons([(x:1,y:1)]);
    List<AddButton> addButtons2 = mas.generateAddButtons([(x:1,y:1),(x:2,y:2)]);
    expect(addButtons1.length, 1);
    expect(addButtons2.length,2);
  });

  test("generateAddButtons generates button with uniq key", (){
    MyAppState mas = MyAppState();
    List<AddButton> addButtons = mas.generateAddButtons([(x:1,y:1),(x:2,y:2)]);
    expect(addButtons.elementAt(0).key!=addButtons.elementAt(1).key,true);
  });
}