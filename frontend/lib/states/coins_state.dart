//Den här klassen håller bara status för hur mycket pengar som finns, kan öka och minska det värdet
import 'package:flutter/material.dart';

class CoinsState {
  final ValueNotifier<int> coinValue = ValueNotifier<int>(0);

  void increaseCoinValue(int addedValue) {
    coinValue.value = coinValue.value + addedValue;
  }

  void decreaseCoinValue(int deletedValue) {
    coinValue.value = coinValue.value - deletedValue;
  }

  int getCoinValue() {
    return coinValue.value;
  }
}
