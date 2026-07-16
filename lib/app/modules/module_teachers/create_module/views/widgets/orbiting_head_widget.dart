import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

class OrbitingHeaderWidget extends StatefulWidget {
  const OrbitingHeaderWidget({super.key});

  @override
  State<OrbitingHeaderWidget> createState() => _OrbitingHeaderWidgetState();
}

class _OrbitingHeaderWidgetState extends State<OrbitingHeaderWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _animController,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: ColorConstant.primaryShadowMedium,
                    width: 1
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 20,
                    child: Container(height: 8, width: 8, decoration: const BoxDecoration(color: ColorConstant.primary, shape: BoxShape.circle)),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Container(height: 6, width: 6, decoration: const BoxDecoration(color: ColorConstant.primary, shape: BoxShape.circle)),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              border: Border.all(
                  color: ColorConstant.primaryShadow,
                  width: 1.5
              ),
              shape: BoxShape.circle,
            ),
          ),

          Container(
            height: 90,
            width: 90,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    ColorConstant.primary,
                    ColorConstant.linearPrimary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.primary,
                    blurRadius: 15,
                    spreadRadius: -2,
                    offset: Offset(0, 4),
                  )
                ]
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: ColorConstant.yellowColor,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}