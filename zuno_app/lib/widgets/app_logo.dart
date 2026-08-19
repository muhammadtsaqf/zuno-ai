import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showGlow;

  const AppLogo({
    super.key,
    this.size = 100.0,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C5CE7), // Cyber Purple
            Color(0xFF00F5D4), // Cyan
            Color(0xFFFF007F), // Neon Pink
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withOpacity(0.6),
                  blurRadius: size * 0.3,
                  spreadRadius: size * 0.05,
                ),
                BoxShadow(
                  color: const Color(0xFF00F5D4).withOpacity(0.4),
                  blurRadius: size * 0.5,
                  spreadRadius: size * 0.02,
                )
              ]
            : null,
      ),
      child: Center(
        child: Container(
          width: size * 0.88,
          height: size * 0.88,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0F0E17),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glowing Ring Line
              Container(
                width: size * 0.72,
                height: size * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00F5D4).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
              // Z Stylized Letter / Icon Core
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF00F5D4),
                    Color(0xFF6C5CE7),
                    Color(0xFFFF007F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(
                  Icons.bolt_rounded,
                  size: size * 0.5,
                  color: Colors.white,
                ),
              ),
              // Small Orbiting Dot Node
              Positioned(
                top: size * 0.22,
                right: size * 0.22,
                child: Container(
                  width: size * 0.09,
                  height: size * 0.09,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00F5D4),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00F5D4),
                        blurRadius: 6,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
