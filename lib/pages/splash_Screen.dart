import 'dart:async';
import 'package:animations/animations.dart';
import 'package:compress_punk/constants.dart';
import 'package:compress_punk/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget({super.key});

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Suppose this is an app in your Phone\'s Screen page.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            OpenContainer(
              closedBuilder: (_, openContainer) {
                return const SizedBox(
                  height: 80,
                  width: 80,
                  child: Center(
                    child: Text(
                      'App Logo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              openColor: mainColor,
              closedElevation: 20,
              closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              transitionDuration: const Duration(milliseconds: 900),
              openBuilder: (_, closeContainer) {
                return const SecondScreen();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _a = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 700), () {
      setState(() {
        _a = !_a;
      });
    });
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(SlideTransitionAnimation(const Home()));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 3),
            curve: Curves.fastLinearToSlowEaseIn,
            width: _a ? width : 0,
            height: height,
            color: seconndaryColor,
          ),
          Center(
            child: Container(
                child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image(
                //     image: NetworkImage(
                //         'https://img.pikbest.com/png-images/truck-icon-vector-graphic-element_1532195.png!w700wp')),
                // Icon(
                //   Icons.anchor,
                //   color: Colors.white,
                //   size: 86,
                // ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Compress Punk',
                  style: TextStyle(
                      color: mainColor, fontFamily: 'Cyperbunk', fontSize: 52),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class SlideTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  SlideTransitionAnimation(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 2000),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
              );
              return SlideTransition(
                position: Tween(
                        begin: const Offset(1.0, 0.0),
                        end: const Offset(0.0, 0.0))
                    .animate(animation),
                textDirection: TextDirection.rtl,
                child: page,
              );
            });
}
