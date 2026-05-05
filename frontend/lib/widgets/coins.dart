import 'package:flutter/material.dart';
import 'package:flutter_demo/states/coins_state.dart';

const String coinsPath = "lib/resources/images/coin_icon.png";

class Coins extends StatefulWidget{
    final CoinsState coinsState; 
    const Coins({super.key, required this.coinsState});

    @override
    State<Coins> createState() => CoinsValue();
}

class CoinsValue extends State<Coins>{

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                    Text(widget.coinsState.getCoinValue().toString(), style: Theme.of(context).textTheme.headlineMedium,),
                    IconButton( icon: Image.asset(coinsPath, width: 28, height: 28), onPressed: (){setState((){widget.coinsState.increaseCoinValue(1);});},), 
                ],
            )
        );
    }
}