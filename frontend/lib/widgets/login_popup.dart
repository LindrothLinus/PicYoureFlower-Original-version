import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle headerText = GoogleFonts.nunito(
  fontSize: 25,
  fontWeight: FontWeight.w500,
);

final TextStyle infoText = GoogleFonts.nunito(
  fontSize: 17,
  fontWeight: FontWeight.w500,
);

final TextStyle loginText = GoogleFonts.nunito(
  fontSize: 25,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

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

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login!', style: headerText),
            SizedBox(width: 10),
            Icon(Icons.lock),
          ],
        ), 

        content: SizedBox(
          width: 200,
          height: 100,
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'In order to play and share your greenhouse please log in!',
                  style: infoText,
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
                onPressed: () async {
                  //open the login microservice instead of just poping the screen
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
                        )
                      );
                    }
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Log in!',
                  style: loginText
                ),
              ) 
            )

          ) 
        ],
      );
    }
  );
}