import 'package:flutter/material.dart';
import '../resources/constants.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle menuText = GoogleFonts.nunito(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

class FriendMenu extends StatefulWidget{

  @override
  FriendMenuState createState() => FriendMenuState();

}

class FriendMenuState extends State<FriendMenu>{
  bool showButtons = false;
  bool isExpanded = false;
  Color? activePanelColor;
  double smallHeigth = 150;
  double largeHeigth = 540;
  double panelHeigth = 0; //150 for small

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
            panelHeigth = largeHeigth;
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
                  expandButton(),
                  Column(
                    children: [
                      createFriendBoxes(),
                      if(isExpanded)...[
                        createFriendBoxes(),
                        createFriendBoxes(),
                        createFriendBoxes(),
                      ]
                    ]
                  )
                ]
                //if(activePanelColor == mainColor)
                //if(activePanelColor == greenColor)
              ],
              
            ),
          ),
      ],
    );
   
  }
}