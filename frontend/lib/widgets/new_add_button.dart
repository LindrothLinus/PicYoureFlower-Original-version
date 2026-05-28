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
      width: 60,
      height: 60,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: widget.onBuildModeButtonPressed,
        icon: Image.asset(
          buildmodeIconPath,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
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