import 'package:flutter/material.dart';

void login_popup(BuildContext context) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login!'),
            SizedBox(width: 10),
            Icon(Icons.lock),
          ],
        ), 

        content: SizedBox(
          width: 200,
          height: 100,
          child: const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Please Login to use this application'),
              ],
            ),
          ),
        ),

        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 50),
                ),
                onPressed: () {
                  //open the login microservice instead of just poping the screen
                  Navigator.of(context).pop();
                },
                child: const Text('Login'),
              ) 
            )

          ) 
        ],
      );
    }
  );
}