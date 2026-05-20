import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/login_popup.dart';
import '../resources/constants.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle menuText = GoogleFonts.nunito(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

class Friend {
  String name;
  Friend(this.name);
}

class FriendMenu extends StatefulWidget{

  @override
  FriendMenuState createState() => FriendMenuState();

}

class FriendMenuState extends State<FriendMenu>{
  bool showButtons = false;
  bool isExpanded = false;
  Color? activePanelColor;
  double smallHeigth = 150;
  double mediumHeight = 300;
  double largeHeigth = 540;
  double panelHeigth = 0; 

  final friends = [
    //NOTICE ME BACKEND!!!!
    //add friends from the database here by the method below
    //Friend("name from database")

  ];

  Padding heartButton(){
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap:() {
          setState((){
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

  Expanded friendsButton(){
    return Expanded(
      child: SizedBox(
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: backgroundColor,
          ),
          onPressed: (){
            isExpanded = false;
            panelHeigth = smallHeigth;
            openPanel(backgroundColor);
          }, 
          child: Text(
            'Friends',
            style: menuText,
          ),
        ),
      ), 
    );
  }

  Expanded searchButton(){
    return Expanded(
      child: SizedBox(
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: mainColor,
          ),
          onPressed: (){
            panelHeigth = smallHeigth;
            openPanel(mainColor);
          }, 
          child: Text(
            'Search',
            style: menuText,
          ),
        ),
      ), 
    );
  }

  Expanded profileButton(){
    return Expanded(
      child: SizedBox(
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: greenColor,
          ),
          onPressed: (){
            panelHeigth = mediumHeight;
            openPanel(greenColor);
          }, 
          child: Text(
            'Profile',
            style: menuText,
          ),
        ),
      ), 
    );
  }

  Positioned cancelButton(){
    return Positioned(
      top: 10,
      child: IconButton(
      icon: Icon(Icons.close, size: 30,),
        onPressed: () {
          setState(() {
            showButtons = false;
            activePanelColor = null;
          });
        },
      ),
    );
  }

  Positioned expandButton(){
    return Positioned(
      left: 10,
      bottom: 10,
      child: GestureDetector(
        onTap:() {
          toggleExpand();
        },
        child: Image.asset(
          'lib/resources/images/Expand.png',
          width: 50,
        ),
      ),
    );
  }

  Container searchConfirmButton(){
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: greenColor,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6)
      ),
      child: Image.asset(
        'lib/resources/images/Search.png',
      ),
    );
  }

  TextField searchTextField(){
    return TextField(
      decoration: InputDecoration(
        hintText: "Username...",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: (){
            //do something
          },
          child: SizedBox(
            width: 60,
            height: 60,
            child: searchConfirmButton(),
          ),
        )
      ),
    );
  }

  Container menuBox(){
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color:Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Padding friendBox(){
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
        )
      ),
    );
  }

  Container profileBoxPic(Color c, double w, double h, String image){
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
          width: 1,
        )
      ),
      child: Image.asset(
        image,
      ),
    );
  }

  Container profileBoxText(Color c, double w, double h, String text){
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
          width: 1,
        )
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text, style: menuText,),
        )
      ),
    );
  }

  Widget createFriendBoxes(){
    return Row(
      children: [
        SizedBox(width: 100),
        friendBox(),
        SizedBox(width: 30),
        friendBox(),
        SizedBox(width: 30),
        friendBox(),
      ]
    );
  }

  void openPanel(Color color){
    setState((){
      activePanelColor = color;
    });
  }
  
  void toggleExpand(){
    setState(() {
      isExpanded = !isExpanded;

      panelHeigth = isExpanded ? largeHeigth : smallHeigth;
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
          
        //Buttons
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            if(!showButtons)
            heartButton(),
              
            //Buttons that show up when friend menu appears
            if(showButtons)
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
        if(activePanelColor != null)
          Container(
            width: double.infinity,
            height: panelHeigth,
            color: activePanelColor,
            child: Stack(
              children: [
                if(activePanelColor == backgroundColor)... [
                  
                  GridView.builder(
                    padding: EdgeInsets.only(top: 15, left: 65),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10, 
                    ),
                    itemCount: friends.length,
                    itemBuilder: (BuildContext context, int index){
                      final friend = friends[index];
                      return Card(
                        elevation: 3,
                        child: Stack(
                          children: [

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 35),
                                child: SizedBox(
                                  height: 90,
                                  child: Image.asset(
                                    'lib/resources/images/showel_icon.png',
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
                                  color: Colors.white,
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
                      );
                    }
                  ),
                  expandButton(),
                ],
                if(activePanelColor == mainColor)...[
                  Center(
                    child:SizedBox(
                      width: 350,
                      child: searchTextField(),
                    ),
                  ),
                ],
                if(activePanelColor == greenColor)...[
                  Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        children: [
                          SizedBox(width: 30),
                          //profile pic
                          profileBoxPic(Colors.white, 150, 150, 'lib/resources/images/showel_icon.png'),

                          SizedBox(width: 20),
                          //other column
                          Column(
                            children: [
                              //calender
                              Row(
                                children: [
                                  profileBoxPic(purpleColor, 40, 40, 'lib/resources/images/Calendar_v2.png'),
                                  profileBoxText(Colors.white, 155, 40, '26-05-15'),
                                ],
                              ),

                              SizedBox(height: 15),
                              //name
                              Row(
                                children: [
                                  profileBoxPic(purpleColor, 40, 40, 'lib/resources/images/Identity.png'),
                                  profileBoxText(Colors.white, 155, 40, 'FlowerManiac'),
                                ],
                              ),

                              SizedBox(height: 15),
                              //flower status
                              Row(
                                children: [
                                  profileBoxPic(purpleColor, 40, 40, 'lib/resources/images/flower_icon.png'),
                                  profileBoxText(Colors.white, 155, 40, '1,234'),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      //second column slot, manage friends
                      profileBoxText(purpleColor, 370, 50, 'Manage Friends'),
                    ],
                  ),
                ],
              ],
            ),
          ),
      ],
    );
   
  }
}