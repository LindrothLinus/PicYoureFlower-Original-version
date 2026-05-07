import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const MaterialApp(
      home: SvgBackgroundScreen(),
    ),
  );
}

// All new code removed from the demo version

class SvgBackgroundScreen extends StatefulWidget {
  const SvgBackgroundScreen({super.key});

  @override
  State<SvgBackgroundScreen> createState() => _SvgBackgroundScreenState();
}

class _SvgBackgroundScreenState extends State<SvgBackgroundScreen> {

  
  final TransformationController controller = TransformationController();
  final double scale = 2.0;

  @override
  void initState(){
    super.initState();

    controller.value = Matrix4.translationValues(-200, -200, 0)
    ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        constrained: true,
        boundaryMargin: const EdgeInsets.only(bottom: -80),
        clipBehavior: Clip.hardEdge,
        panEnabled: true,
        scaleEnabled: true,
        minScale: scale,
        maxScale: scale,
        
        transformationController: controller,
        child: SizedBox(
          width: 5906,
          height: 4725,
          child: Stack(
            children: [
              SvgPicture.asset(
                "lib/resources/images/Greenhouse.svg",
              )
            ],
            )
        ),
      ),

      bottomNavigationBar: NavBar()
    );
  }
  
}

// End of all new code