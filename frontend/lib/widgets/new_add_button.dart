import 'package:flutter/material.dart';
const String buildmodeIconPath = "lib/resources/images/showel_icon.png";


class NewAddButton extends StatefulWidget {
  const NewAddButton({super.key, required this.onBuildModeButtonPressed});

  final Function() onBuildModeButtonPressed;

  @override
  NewAddButtonState createState() => NewAddButtonState();
}
class NewAddButtonState extends State<NewAddButton> {
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          widget.onBuildModeButtonPressed();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Icon(Icons.tune),
        
      ),
    );

  }
/** 
  IconButton(
              icon: Image.asset(buildmodeIconPath),
              onPressed: () {
               
              setState(() {
                  visible = false;
                });
                widget.onBuildModeButtonPressed();
                /* 
                if(isHome){
                  
                } else {
                  Navigator.popUntil(context,ModalRoute.withName('/'));
                }
                */
              } 

            )
*/
}