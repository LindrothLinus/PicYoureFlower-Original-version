import 'package:flutter/material.dart';
import 'package:flutter_demo/states/coins_state.dart';
import '../resources/constants.dart';

const String coinsPath = "lib/resources/images/coin.webp";

class Coins extends StatelessWidget {
  final CoinsState coinsState;
  const Coins({super.key, required this.coinsState});

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
                  coinsState.increaseCoinValue(1);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
