//Den här klassen håller bara status för hur mycket pengar som finns, kan öka och minska det värdet
import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import 'package:http/http.dart' as http;

class CoinsState {
  final ValueNotifier<int> coinValue = ValueNotifier<int>(0);

  Future<void> updateCoinValue(int coins) async {
    try{
      final uri = Uri.parse('${UrlConst.userService}/home/setcoins/$loggedInUserId/$coins');
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