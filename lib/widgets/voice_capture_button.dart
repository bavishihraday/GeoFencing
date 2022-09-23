import 'package:flutter/material.dart';

class VoiceCaptureButton extends StatefulWidget {
  const VoiceCaptureButton({Key? key, required this.duration, required this.shouldBeginProgress, required this.onPressed}) : super(key: key);

  final int duration;
  final bool shouldBeginProgress;
  final Function() onPressed;

  @override
  State<VoiceCaptureButton> createState() => _VoiceCaptureButtonState();
}

// Button widget that animates down into a smaller button surrounded by a timer for a visual representation of capturing audio
class _VoiceCaptureButtonState extends State<VoiceCaptureButton> with TickerProviderStateMixin {
  late Animation<double> buttonAnimation;
  late AnimationController buttonAnimationController;

  late Animation<double> progressAnimation;
  late AnimationController progressAnimationController;
  
  bool isPressed = false;
  bool progressVisible = false;

  void _animateButtonPressed() {
    if (!isPressed) {
      buttonAnimationController.forward();

      isPressed = !isPressed;
      progressVisible = !progressVisible;
    }
  }

  void _beginProgress() {
    progressAnimationController.forward();
  }

  void _animateButtonUnpressed() {
    if (isPressed) {
      buttonAnimationController.reverse();
      progressAnimationController.value = 0;

      isPressed = !isPressed;
      progressVisible = !progressVisible;
    }
  }
  
  @override
  void initState() {
    super.initState();

    buttonAnimationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    buttonAnimation = Tween<double>(begin: 64, end: 32).animate(CurvedAnimation(parent: buttonAnimationController, curve: Curves.easeInOutQuad))..addListener(() { setState(() { }); });

    progressAnimationController = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    progressAnimation = Tween<double>(begin: 0, end: 1).animate(progressAnimationController)..addListener(() { setState(() { if (progressAnimation.value == 1) _animateButtonUnpressed(); }); });
  }

  // Dispose of animation controllers so this widget can be disposed of without error
  @override
  void dispose() {
    buttonAnimationController.dispose();
    progressAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shouldBeginProgress) {
      _beginProgress();
    } else {
      progressAnimationController.value = 0;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: progressVisible,
          child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                value: progressAnimation.value,
                color: Colors.white,
                backgroundColor: Colors.blue,
              ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            widget.onPressed();
            _animateButtonPressed();
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.mic,
            size: buttonAnimation.value,
          ),
          padding: const EdgeInsets.all(16),
          shape: const CircleBorder(),
        ),
      ],
    );
  }
}
