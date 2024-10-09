import 'package:flutter/material.dart';
import 'package:flutter_gail/feature/dashboard/presentation/widget/wave_backgorund.dart';

class CardBackground extends StatelessWidget {
  final Widget child;

  const CardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: ClipPath(
            clipper: WaveShape(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ClipPath(
            clipper: BottomWaveShape(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
