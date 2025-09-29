import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  const LoaderComponent({Key? key, this.text = ''}) : super(key: key);
  //--
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 24, 207, 36)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 24, 207, 36),
            ),
            const SizedBox(height: 20),
            Text(text, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
