import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget{
    const CustomBackButton({super.key});

    @override
    Widget build(BuildContext context) {
        return IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(); // för att komma tillbaka till huvudappens tidigare sida, kanske vill ändra detta sen
        },
        );
    }
}