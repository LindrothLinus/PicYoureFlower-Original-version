import 'package:flutter/material.dart';
import '../resources/constants.dart';


class BuildButton extends StatefulWidget {
  const BuildButton({super.key, required this.onBuildModeButtonPressed});

  final Function() onBuildModeButtonPressed;

  @override
  BuildButtonState createState() => BuildButtonState();
}
class BuildButtonState extends State<BuildButton> {
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: widget.onBuildModeButtonPressed,
        icon: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mainColor,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Image.asset(
            ImagePathsConsts.buildmodeIcon,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
        ),
        
      ),
    );
  }

}