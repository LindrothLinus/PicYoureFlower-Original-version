import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/states/like_sent_overlay.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';
import 'package:flutter_demo/widgets/friend_menu.dart';
import 'package:flutter_demo/widgets/like_button.dart';
import 'package:flutter_demo/widgets/like_sent.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';

import 'package:http/http.dart' as http;

class ViewFriendScreen extends StatefulWidget {
  const ViewFriendScreen({
    super.key,
    required this.userId,
    required this.friend,
    required this.addButtonsCordinats,
  });

  final String? userId;
  final Friend friend;
  final List<({double x, double y})> addButtonsCordinats;

  @override
  State<ViewFriendScreen> createState() => ViewFriendScreenState();
}

class ViewFriendScreenState extends State<ViewFriendScreen> {
  List<AddButton> _addButtons = [];
  List<dynamic> flowerCollection = [];
  Map<int, GlobalKey<AddButtonState>> addButtonKeys = {};
  final ValueNotifier<bool> dummyNotifierBool = ValueNotifier<bool>(false);
  final ValueNotifier<Widget?> dummyNotifierWidget = ValueNotifier<Widget?>(
    null,
  );
  final ValueNotifier<PotState?> dummyPotNotifier = ValueNotifier<PotState?>(
    null,
  );

  @override
  void initState() {
    super.initState();
    _loadFriendGreenhouse();
  }

  Future<void> _loadFriendGreenhouse() async {
    final buttons = await loadGreenhouseButtons(widget.addButtonsCordinats);
    setState(() {
      _addButtons = buttons;
    });
  }

  Future<List<AddButton>> loadGreenhouseButtons(List<({double x, double y})> coordinates,) async {
    try {
      final flowerResponse = await http.get(
        Uri.parse('$flowerServiceUrl/home/user/${widget.friend.id}/flowers'),
      );
      if (flowerResponse.statusCode == 200) {
        final List<dynamic> flowerData = jsonDecode(flowerResponse.body);
        flowerCollection = flowerData
            .cast<Map<String, dynamic>>()
            .map(Flower.buildFlower)
            .toList();
      }

      final response = await http.get(
        Uri.parse('$userServiceUrl/home/greenhouse/${widget.friend.id}'),
      );

      if (response.statusCode != 200) return [];

      final List<dynamic> data = jsonDecode(response.body);

      final Map<int, int?> slotFlowers = {
        for (final item in data)
          (item['placementId'] as num).toInt(): (item['flowerId'] as num?)
              ?.toInt(),
      };

      final List<AddButton> buttons = generateAddButtons(coordinates);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final entry in slotFlowers.entries) {
          final int placementId = entry.key;
          final int? flowerId = entry.value;

          final matches = flowerCollection.where((f) => f.id == flowerId);
          final flower = flowerId != null && matches.isNotEmpty
              ? matches.first
              : null;

          addButtonKeys[placementId]?.currentState?.loadPot(
            item: dummyNotifierWidget,
            buildBarActiveNotifer: dummyNotifierBool,
            selectedPotNotifier: dummyPotNotifier,
            initialFlower: flower,
          );
        }
      });

      return buttons;
    } catch (e) {
      print('Error loading friends greenhouse: $e');
      return [];
    }
  }


  List<AddButton> generateAddButtons(List<({double x, double y})> coordinates){
    return List.generate(coordinates.length, (i) {
        final key = GlobalKey<AddButtonState>();
        addButtonKeys[i] = key;

        return AddButton(
          key: key,
          builModeActiveNotifier: dummyNotifierBool,
          buildBarActiveNotifer: dummyNotifierBool,
          x: coordinates[i].x,
          y: coordinates[i].y,
          item: dummyNotifierWidget,
          index: i,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.friend.name}'s greenhouse",style: TextStyles.header),backgroundColor:Theme.of(context).colorScheme.inversePrimary,leading: CustomBackButton(toHome: true),
),
      body: Stack(
        children: [
          Greenhouse(addButtons: _addButtons),
          FriendMenu(addButtonsCordinates: widget.addButtonsCordinats, userId: widget.userId),
          Positioned(
            bottom: 20,
            right: 20,
            child: LikeButton(friendId: widget.friend.id),
          ),
        ],
      ),
    bottomNavigationBar: NavBar(onBuildModeButtonPressed: (){}),
    );
  }
}
