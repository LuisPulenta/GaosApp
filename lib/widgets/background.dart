import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackGround extends StatelessWidget {
  final Widget child;

  const BackGround({Key? key, required this.child}) : super(key: key);

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return _DownBox();
  }
}

//*****************************************************************************
//************************** _DownBox *****************************************
//*****************************************************************************

class _DownBox extends StatefulWidget {
  const _DownBox({Key? key}) : super(key: key);

  @override
  State<_DownBox> createState() => _DownBoxState();
}

class _DownBoxState extends State<_DownBox>
    with SingleTickerProviderStateMixin {
//-----------------------------------------------------------------
//------------------------- Variables -----------------------------
//-----------------------------------------------------------------
  late AnimationController controller;
  late Animation<double> rotacion;

//-----------------------------------------------------------------
//------------------------- initState -----------------------------
//-----------------------------------------------------------------
  @override
  void initState() {
    //--- controller ---
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    //--- rotacion ---
    rotacion = Tween(begin: 0.0, end: 2.0 * math.pi)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    //--- Listener ---
    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.reverse();
        //controller.reset();
      } else if (controller.status == AnimationStatus.dismissed) {
        controller.forward();
      }
      ;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    controller.forward();
    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      child: AnimatedBuilder(
        animation: controller,
        child: IconoLogo(),
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: rotacion.value,
            child: child,
          );
        },
      ),
    );
  }
}

class IconoLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Image.asset(
        "assets/ic_launcher.png",
        height: 200,
      ),
    );
  }
}
