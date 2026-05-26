//Den här klassen håller bara status för hur mycket pengar som finns, kan öka och minska det värdet
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_demo/widgets/camera_button.dart';

const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';

class CoinsState {
  final ValueNotifier<int> coinValue = ValueNotifier<int>(0);

  Future<void> updateCoinValue(int coins) async {
    try{
      final uri = Uri.parse('$_baseUrl/home/setcoins/$loggedInUserId/$coins');
      final response = await http.put(uri);

      print(response.statusCode);
      print(response.body);
      
    } catch(e){
      print("Error: $e");
    }
  }

  void increaseCoinValue(int addedValue) {
    coinValue.value = coinValue.value + addedValue;
  }

  void decreaseCoinValue(int deletedValue) {
    coinValue.value = coinValue.value - deletedValue;
  }

  void setCoinValue(int coin){
    coinValue.value = coin;
  }

  int getCoinValue() {
    return coinValue.value;
  }
}