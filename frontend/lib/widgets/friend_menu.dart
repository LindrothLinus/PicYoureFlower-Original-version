import 'package:flutter/material.dart';

class FriendMenu extends StatefulWidget{

  @override
  FriendMenuState createState() => FriendMenuState();

}

class FriendMenuState extends State<FriendMenu>{
  bool showButtons = false;
  
  @override
  Widget build(BuildContext context){
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
       
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            //Heart png button
            if(!showButtons)
            Padding(
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
            ),
              
            //Buttons that show up when friend menu appears
            if(showButtons)
            Stack(
              children: [
                //Two friend buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: (){

                          }, 
                          child: Text(
                            'Button 1',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ), 
                    ),

                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: (){

                          }, 
                          child: Text(
                            'Button 2',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ), 
                    ),
                  ],
                ),

                //The X button
                Positioned(
                  top: 10,
                  child: IconButton(
                  icon: Icon(Icons.close, size: 40,),
                    onPressed: () {
                      setState(() {
                        showButtons = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}