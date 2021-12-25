import 'package:contact_sharing/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';

class AppButton extends StatefulWidget {
  final String title;
  final bool isLoading;
  final void Function()? onPressed;
  const AppButton({
    Key? key,
    required this.title,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  // animation variables
  static const Duration _animDuration = Duration(milliseconds: 500);
  static const Curve _animCurve = Curves.easeInOutCubic;
  static const Curve _opacityCurve = Curves.easeInCirc;

  // device variables
  late Size size;
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: widget.isLoading ? () {} : widget.onPressed,
      child: Center(
        child: AnimatedContainer(
          duration: _animDuration,
          curve: _animCurve,
          height: size.height * 0.08,
          width: widget.isLoading ? size.height * 0.08 : size.width,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(72.0),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // button text
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: _animDuration,
                  curve: _opacityCurve,
                  opacity: widget.isLoading ? 0.0 : 1.0,
                  child: Align(
                    child: Text(
                      widget.title,
                      style: textTheme.button,
                    ),
                  ),
                ),
              ),
              // loading spinner
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: _animDuration,
                  curve: _opacityCurve,
                  opacity: widget.isLoading ? 1.0 : 0.0,
                  child: const Align(
                    child: LoadingIndicator(),
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
