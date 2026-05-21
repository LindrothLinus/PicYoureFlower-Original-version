import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_demo/states/coins_state.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import '../resources/constants.dart';

import 'package:http/http.dart' as http;

const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';

const String coinsPath = "lib/resources/images/coin.webp";

class Coins extends StatefulWidget{
  final CoinsState coinsState;
  const Coins({super.key, required this.coinsState});

  @override
  State<Coins> createState() => _Coins(coinsState: coinsState);
}

class _Coins extends State<Coins> {
  final CoinsState coinsState;
  _Coins({required this.coinsState});


  @override
  void initState(){
    super.initState();
    getCoins();
  }

  Future<void> getCoins() async {
    try{
      final response = await http.get(
        Uri.parse('$_baseUrl/home/coins/$loggedInUserId'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        }
      );
      if(response.statusCode == 200){
        final coinValue = jsonDecode(response.body);
        coinsState.setCoinValue(coinValue);
      }
    } catch(e){
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: coinsState.coinValue,
      builder: (context, value, child) {
        return SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                coinsState.getCoinValue().toString(),
                style: TextStyles.coinsValue,
              ),
              IconButton(
                icon: Image.asset(coinsPath, width: 28, height: 28),
                onPressed: () {
                  //should be removed or changed to fit the database
                  //coinsState.increaseCoinValue(1);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
