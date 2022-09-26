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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Column(
            children: const [
              _UpBox(),
              _DownBox(),
            ],
          ),
          const HeaderLogo(),
          child,
        ],
      ),
    );
  }
}

//*****************************************************************************
//************************** HeaderLogo ***************************************
//*****************************************************************************

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: Image.asset(
          "assets/kplogo.png",
          height: 200,
        ),
      ),
    );
  }
}

//*****************************************************************************
//************************** _UpBox *******************************************
//*****************************************************************************

class _UpBox extends StatelessWidget {
  const _UpBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      decoration: _UpBackground(),
      child: Stack(
        children: [
          Positioned(
            child: _Bubble(),
            top: 90,
            left: 30,
          ),
          Positioned(
            child: _Bubble(),
            top: -40,
            left: -30,
          ),
          Positioned(
            child: _Bubble(),
            top: -50,
            right: -20,
          ),
          Positioned(
            child: _Bubble(),
            bottom: -50,
            left: 10,
          ),
          Positioned(
            child: _Bubble(),
            bottom: 120,
            right: 20,
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ _UpBackground --------------------------------
//-----------------------------------------------------------------------------

  BoxDecoration _UpBackground() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0XFF94acd4),
        Color(0XFF3658a8),
      ]));
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
      decoration: _DownBackground(),
      child: Stack(
        children: [
          Positioned(
            child: _Bubble(),
            top: 90,
            left: 30,
          ),
          Positioned(
            child: _Bubble(),
            top: -40,
            left: -30,
          ),
          Positioned(
            child: _Bubble(),
            top: -50,
            right: -20,
          ),
          Positioned(
            child: _Bubble(),
            bottom: -50,
            left: 10,
          ),
          Positioned(
            child: _Bubble(),
            bottom: 120,
            right: 20,
          ),
          Positioned(
              left: 10,
              right: 10,
              bottom: 20,
              child: AnimatedBuilder(
                animation: controller,
                child: IconoLogo(),
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: rotacion.value,
                    child: child,
                  );
                },
              )),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
  BoxDecoration _DownBackground() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0XFF3658a8),
        Color(0XFF94acd4),
      ]));
}

//*****************************************************************************
//************************** _Bubble ******************************************
//*****************************************************************************

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.06),
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
