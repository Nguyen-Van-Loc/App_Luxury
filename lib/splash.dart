import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab5/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class viewSplash extends State<splacsh> {
  double _scale = 1.0;
  double _maxScale = 1.2;
  int _duration = 100;
  bool _zoomIn = true;
  double opacity = 0.0;
  @override
  void initState() {
    super.initState();
    autoZoomIn();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }
  void autoZoomIn() {
    Timer.periodic(Duration(milliseconds: _duration), (Timer timer) {
      setState(() {
        if (_zoomIn) {
          if (_scale < _maxScale) {
            _scale += 0.2;
          } else {
            _zoomIn = false;
            timer.cancel();
            Timer(
                const Duration(seconds: 10),
                () => Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          var tween = Tween(
                              begin: const Offset(1,0), end: Offset.zero);
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: barNavigation(),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    ));
          }
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,left: 0,bottom: 250,top: 0,
          child: AnimatedContainer(
            duration: Duration(seconds: 3), // Điều chỉnh thời gian animation
            width: 200 * _scale, // Kích thước ban đầu của hình ảnh
            height: 200 * _scale, // Kích thước ban đầu của hình ảnh
            child: Image.asset(
                'assets/image/logo.png'), // Thay đổi đường dẫn của hình ảnh tại đây
          ),
        ),
        AnimatedOpacity(
          duration: Duration(seconds: 3), // Thời gian xuất hiện dần dần
          opacity: opacity, // Độ trong suốt ban đầu là 0.0 (ẩn)
          child: Container(
            margin: const EdgeInsets.only(bottom: 100),
            alignment: Alignment.bottomCenter,
            child: LoadingAnimationWidget.discreteCircle(
                color: Color(0xffff2b00),
                size: 40,
                thirdRingColor: Color(0xff50e826),
                secondRingColor: Color(0xff0059ff)),
          ),
        ),
      ],
    );
  }
}