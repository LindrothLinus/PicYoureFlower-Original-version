import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/new_add_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String likedPath = "lib/resources/images/SentLike.png";

class Greenhouse extends StatefulWidget {
  const Greenhouse({
    super.key, 
    required this.addButtons,
    required this.onBuildModeButtonPressed,
    this.buildModeActiveNotifier,
    this.showBuildButton = true,
    });
  final List<AddButton> addButtons;
  final Function() onBuildModeButtonPressed;
  final ValueNotifier<bool>? buildModeActiveNotifier;
  final bool showBuildButton;

  @override
  State<Greenhouse> createState() => _Greenhouse();
}

class _Greenhouse extends State<Greenhouse> {
  final double imageWidth = 5906;
  final double imageHeight = 4725;
  final double scale = 0.17;
  Offset _offset = Offset.zero;

  Offset _clamp(Offset offset, Size screenSize) {
    final double scaledWidth = imageWidth * scale;
    final double scaledHeight = imageHeight * scale;
    final double minX = (screenSize.width - scaledWidth).clamp(double.negativeInfinity, 0.0);
    final double minY = (screenSize.height - scaledHeight).clamp(double.negativeInfinity, 0.0);
    return Offset(
      offset.dx.clamp(minX, 0.0),
      offset.dy.clamp(minY, 0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ClipRect(
        child: SizedBox.expand(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (details) {
              setState(() {
                _offset = _clamp(_offset + details.delta, screenSize);
              });
            },
            child: Stack(
              children: [
                Positioned(
                  left: _offset.dx,
                  top: _offset.dy,
                  child: SizedBox(
                    width: imageWidth * scale,
                    height: imageHeight * scale,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned.fill(
                              child: SvgPicture.asset(
                                "lib/resources/images/Greenhouse.svg",
                              ),
                            ),
                            ...widget.addButtons,

                        
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.showBuildButton)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: NewAddButton(
                    onBuildModeButtonPressed: widget.onBuildModeButtonPressed,
                  ),
                ),
                if (widget.buildModeActiveNotifier != null)
                ValueListenableBuilder<bool>(
                  valueListenable: widget.buildModeActiveNotifier!,
                  builder: (context, isActive, _) {
                    if (!isActive) return const SizedBox.shrink();
                    return Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Build mode',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}