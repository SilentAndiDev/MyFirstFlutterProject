import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uno_point_sale/common_utils.dart';

import 'first_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FirstScreen())));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(30.0),
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Align(
                    alignment: FractionalOffset.center,
                   child: SizedBox(
                       width: 180,
                     child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("assets/images/uno_point_logo.png"),
                                LinearProgressIndicator(
                                  value: controller.value,
                                  semanticsLabel: 'Linear progress indicator',
                                ),
                              ]
                          )
                   ),

                    )
            ),
            Positioned(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Text(
                      CommonUtils.ver,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          backgroundColor: Colors.white,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.none),
                    ))),
          ],
        ));
  }
} //size: MediaQuery.of(context).size.height

// child:Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex: 3, // 20%
//                           child: Container(),
//                         ),
//                         Expanded(
//                           flex: 4, // 60%
//                           child:Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Image.asset("assets/images/uno_point_logo.png"),
//                                 LinearProgressIndicator(
//                                   value: controller.value,
//                                   semanticsLabel: 'Linear progress indicator',
//                                 ),
//                               ]
//                           ),
//                         ),
//                         Expanded(
//                           flex: 3, // 20%
//                           child: Container(),
//                         )
//                       ],
//                     )