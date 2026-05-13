import 'package:flutter/material.dart';

void login_popup(BuildContext context) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFFFDEF1),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Colors.black,
            width: 2,
          )
        ),

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
                Text(
                  'In order to play and share your greenhouse please log in!',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
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
                  minimumSize: const Size(250, 50),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                    )
                  ),

                  backgroundColor: Color(0xFFAEF7A1),
                ),
                onPressed: () {
                  //open the login microservice instead of just poping the screen
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Log in!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  )
                ),
              ) 
            )

          ) 
        ],
      );
    }
  );
}