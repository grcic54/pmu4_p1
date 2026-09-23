import 'package:flutter/material.dart';

Color magnitudeColor(double magnitude) {
  if(magnitude >= 6) return Colors.red;
  if(magnitude>=4.5) return Colors.orange;
  return Colors.amber;
}

class MagnitudeBadge extends StatelessWidget {
  final double magnitude;
  final double size;


  const MagnitudeBadge({super.key, required this.magnitude, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.22),
        decoration: BoxDecoration(
          color: magnitudeColor(magnitude),
          shape: BoxShape.circle
        ),
        child: FittedBox(
          child: Text(
            magnitude.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}