import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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

final GoogleSignIn _googleSignIn = GoogleSignIn(
  serverClientId: '167485843554-b82rj6jet7kr9rt81r0qm20jv40okesd.apps.googleusercontent.com',
  clientId: Platform.isIOS 
      ? '167485843554-2evckuk7fa0k7a2v8u67u1afijqqe0vr.apps.googleusercontent.com'
      : null, 
  scopes: ['email', 'profile'],
);

Future<void> signInWithGoogle(BuildContext context, {VoidCallback? onSuccess}) async {
  try {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) return;

    final GoogleSignInAuthentication auth = await account.authentication;
    final String? idToken = auth.idToken;
    if (idToken == null) throw Exception('No ID token received');

    final response = await http.post( 
      Uri.parse('https://group-1-75.pvt.dsv.su.se/auth/api/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      authToken = data['token'];
      loggedInUserId = data['userId']?.toString();

      onSuccess?.call();

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  ImagePathsConsts.confirmed,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        );
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      }
    } else {
      throw Exception('Backend returned ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Login error: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
}

void login_popup(BuildContext context, {VoidCallback? onSuccess}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFFFDEF1),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 2),
        ),

        // Main branch title preserved exactly
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
          //height: 100,
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
              padding: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 50),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 1),
                  ),

                  backgroundColor: Color(0xFFAEF7A1),
                ),
                // Your branch: real sign-in instead of dummy pop
                onPressed: () => signInWithGoogle(context, onSuccess: onSuccess),
                child: Text('Log in!', style: loginText),
              ),
            ),
          ),
        ],
      );
    },
  );
}