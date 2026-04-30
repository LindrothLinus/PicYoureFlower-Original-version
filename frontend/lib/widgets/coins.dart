import 'package:flutter/material.dart';
import 'package:flutter_demo/states/coins_state.dart';

const String coinsPath = "lib/resources/images/coin_icon.png";

class Coins extends StatefulWidget{
    const Coins({super.key});

    @override
    State<Coins> createState() => CoinsValue();
}

class CoinsValue extends State<Coins>{

    CoinsState coinsState  = CoinsState(); 

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                    Text(coinsState.getCounterValue().toString(), style: Theme.of(context).textTheme.headlineMedium,),
                    IconButton( icon: Image.asset(coinsPath, width: 28, height: 28), onPressed: (){setState((){coinsState.increaseCounter(1);});},), 
                ],
            )
        );
    }
}