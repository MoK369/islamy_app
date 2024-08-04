import 'package:flutter/widgets.dart';

class BgContainer extends StatelessWidget {
  Widget child;

  BgContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: child,
    );
  }
}
