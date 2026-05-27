import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/view_friend.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/login_popup.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/constants.dart';

import 'package:http/http.dart' as http;

const String _baseUrl = 'http://10.0.2.2:8080';

final List<String> avatarImages = [
  "lib/resources/images/Avatar_Blue.png",
  "lib/resources/images/Avatar_Pink.png",
  "lib/resources/images/Avatar_Purple.png",
  "lib/resources/images/Avatar_Green.png",
  "lib/resources/images/Avatar_Red.png",
  "lib/resources/images/Avatar_Yellow.png",
];

final random = Random();

final TextStyle menuText = GoogleFonts.nunito(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

class Friend {
  String name;
  int id;
  String avatar;

  Friend(this.name, this.id)
    : avatar = avatarImages[random.nextInt(avatarImages.length)];

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(json['name'], json['id']);
  }
}

class FriendMenu extends StatefulWidget {
  const FriendMenu({super.key, required this.addButtons, required this.userId});
  final List<AddButton> addButtons;
  final String? userId;

  @override
  FriendMenuState createState() => FriendMenuState();
}

class FriendMenuState extends State<FriendMenu> {
  bool showButtons = false;
  bool isProfileExpanded = false;
  bool isExpanded = false;
  double smallHeigth = 150;
  double mediumHeight = 300;
  double largeHeigth = 0;
  double panelHeigth = 0;
  Color? activePanelColor;
  Friend? selectedFriend;

  final TextEditingController friendController = TextEditingController();

  late List<Friend> friends = [Friend("Linus", 6)];

  @override
  void initState() {
    super.initState();
    _getFriends();
  }

  Future<void> _getFriends() async {
    try {
      String? id = widget.userId;
      final response = await http.get(Uri.parse('$_baseUrl/home/friends/$id'));
      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> raw = jsonDecode(response.body);
        final maps = raw.cast<Map<String, dynamic>>();

        friends = maps.map((e) => Friend.fromJson(e)).toList();
      }
    } catch (e) {
      friends = [Friend("Somthing whernt wrong", 10000)];
      print(e);
    }
  }


  Future<String> _getLikes() async{
    String answer="";
    try {
      String? id = widget.userId;
      final response = await http.get(Uri.parse('$_baseUrl/home/likes/1'));
      print(response.toString());
      answer = response.toString();
    }
    catch (e) {
      print("server error: $e");
    }


    return answer;
  }

  @override
  void dispose() {
    friendController.dispose();
    super.dispose();
  }

  void addFriends(Friend friend) {
    if (friend.name == "") {
      return;
    }
    setState(() {
      friends.add(friend);
    });
  }

  void removeFriends(Friend? friend) {
    setState(() {
      friends.remove(friend);
      selectedFriend = null;
    });
  }

  Future<void> showCheck() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'lib/resources/images/Check.webp',
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pop();
  }

  Padding heartButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showButtons = true;
          });
        },
        child: Image.asset(
          'lib/resources/images/Social.png',
          width: 80,
          height: 90,
        ),
      ),
    );
  }

  Expanded friendsButton() {
    return Expanded(
      child: SizedBox(
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: backgroundColor,
          ),
          onPressed: () {
            setState(() {
              selectedFriend = null;
            });
            isExpanded = false;
            panelHeigth = smallHeigth;
            openPanel(backgroundColor);
          },
          child: Text('Friends', style: menuText),
        ),
      ),
    );
  }

  Expanded searchButton() {
    return Expanded(
      child: SizedBox(
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: mainColor,
          ),
          onPressed: () {
            panelHeigth = smallHeigth;
            openPanel(mainColor);
          },
          child: Text('Search', style: menuText),
        ),
      ),
    );
  }

  Expanded profileButton() {
    return Expanded(
      child: SizedBox(
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: greenColor,
          ),
          onPressed: () {
            setState(() {
              selectedFriend = null;
            });
            isProfileExpanded = false;
            panelHeigth = mediumHeight;
            openPanel(greenColor);
          },
          child: Text('Profile', style: menuText),
        ),
      ),
    );
  }

  Positioned cancelButton() {
    return Positioned(
      top: 10,
      child: IconButton(
        icon: Icon(Icons.close, size: 30),
        onPressed: () {
          setState(() {
            showButtons = false;
            activePanelColor = null;
          });
        },
      ),
    );
  }

  Positioned expandButton() {
    return Positioned(
      left: 10,
      bottom: 10,
      child: GestureDetector(
        onTap: () {
          toggleExpand();
        },
        child: Image.asset('lib/resources/images/Expand.png', width: 50),
      ),
    );
  }

  Positioned expandProfileButton() {
    return Positioned(
      left: 10,
      bottom: 10,
      child: GestureDetector(
        onTap: () {
          toggleProfileExpand();
        },
        child: Image.asset('lib/resources/images/Expand.png', width: 50),
      ),
    );
  }

  Positioned unfriendButton() {
    return Positioned(
      left: 70,
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Color(0xFFFFA6A6),
            ),
            onPressed: () {
              //Remove friends from list and database
              removeFriends(selectedFriend);
            },
            child: Text('Unfriend', style: menuText),
          ),
        ),
      ),
    );
  }

  Container searchConfirmButton() {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: greenColor,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Image.asset('lib/resources/images/Search.png'),
    );
  }

  TextField searchTextField() {
    return TextField(
      controller: friendController,
      decoration: InputDecoration(
        hintText: "Add a Friend Here!",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            //Send contents of textfield to backend to identity if the user exists and
            //add it to current users friend list if exists

            addFriends(Friend(friendController.text, 4));
            friendController.text = "";
            showCheck();
          },
          child: SizedBox(width: 60, height: 60, child: searchConfirmButton()),
        ),
      ),
    );
  }

  Container menuBox() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Padding friendBox() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          //do something
        },
        child: Column(
          children: [
            menuBox(),
            Text('Name', style: menuText),
          ],
        ),
      ),
    );
  }

  Container profileBoxPic(Color c, double w, double h, String image) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Image.asset(image),
    );
  }

  Container profileBoxText(Color c, double w, double h, String text) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text, style: menuText),
        ),
      ),
    );
  }

  Widget createFriendBoxes() {
    return Row(
      children: [
        SizedBox(width: 100),
        friendBox(),
        SizedBox(width: 30),
        friendBox(),
        SizedBox(width: 30),
        friendBox(),
      ],
    );
  }

  Widget createCard(Friend friend) {
    bool isSelected = selectedFriend == friend;

    return GestureDetector(
      onTap: () {
        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewFriendScreen(
                  friendId: friend.id,
                  addButtons: widget.addButtons,
                ),
              ),
            );
      },
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Color(0xFFFFA6A6) : Colors.black,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 35),
                child: SizedBox(
                  height: 90,
                  child: Image.asset(
                    friend.avatar,
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 30,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: purpleColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        friend.name, //friends name
                        style: infoText,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openPanel(Color color) {
    setState(() {
      activePanelColor = color;
    });
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;

      panelHeigth = isExpanded ? largeHeigth : smallHeigth;
    });
  }

  void toggleProfileExpand() {
    setState(() {
      isProfileExpanded = !isProfileExpanded;

      panelHeigth = isProfileExpanded ? largeHeigth : mediumHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    largeHeigth = (MediaQuery.of(context).size.height) * 0.4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Buttons
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            if (!showButtons) heartButton(),

            //Buttons that show up when friend menu appears
            if (showButtons)
              SizedBox(
                width: double.infinity,
                height: 70,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        friendsButton(),
                        searchButton(),
                        profileButton(),
                      ],
                    ),
                    cancelButton(),
                  ],
                ),
              ),
          ],
        ),

        //InfoBox
        if (activePanelColor != null)
          Container(
            width: double.infinity,
            height: panelHeigth,
            color: activePanelColor,
            child: Stack(
              children: [
                if (activePanelColor == backgroundColor) ...[
                  GridView.builder(
                    padding: EdgeInsets.only(top: 15, left: 65),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: friends.length,
                    itemBuilder: (BuildContext context, int index) {
                      final friend = friends[index];
                      return createCard(friend);
                    },
                  ),
                  expandButton(),
                ],
                if (activePanelColor == mainColor) ...[
                  Center(child: SizedBox(width: 350, child: searchTextField())),
                ],
                if (activePanelColor == greenColor) ...[
                  if (panelHeigth == mediumHeight) ...[
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 2,
                                child: profileBoxPic(
                                  Colors.white,
                                  150,
                                  150,
                                  'lib/resources/images/Avatar_Pink.png',
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        profileBoxPic(
                                          purpleColor,
                                          40,
                                          40,
                                          'lib/resources/images/Like.png',
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: profileBoxText(
                                            Colors.white,
                                            double.infinity,
                                            40,
                                            _getLikes().toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),

                                    Row(
                                      children: [
                                        profileBoxPic(
                                          purpleColor,
                                          40,
                                          40,
                                          'lib/resources/images/Identity.png',
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: profileBoxText(
                                            Colors.white,
                                            double.infinity,
                                            40,
                                            'FlowerManiac',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),

                                    Row(
                                      children: [
                                        profileBoxPic(
                                          purpleColor,
                                          40,
                                          40,
                                          'lib/resources/images/flower_icon.png',
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: profileBoxText(
                                            Colors.white,
                                            double.infinity,
                                            40,
                                            '123',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                toggleProfileExpand();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: purpleColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Manage Friends',
                                      style: menuText,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //profileBoxText(purpleColor, double.infinity, 50, 'Manage Friends'),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (panelHeigth == largeHeigth) ...[
                    Stack(
                      children: [
                        GridView.builder(
                          padding: EdgeInsets.only(
                            top: 15,
                            left: 65,
                            bottom: 80,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: friends.length,
                          itemBuilder: (BuildContext context, int index) {
                            final friend = friends[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedFriend = friend;
                                });
                              },
                              child: createCard(friend),
                            );
                          },
                        ),
                        unfriendButton(),
                        expandProfileButton(),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
      ],
    );
  }
}
