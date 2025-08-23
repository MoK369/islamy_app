import 'package:flutter/material.dart';

class ToastWidget extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const ToastWidget(
      {super.key,
      required this.text,
      required this.color,
      this.icon = Icons.check});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: Icon(
                icon,
                color: color,
                size: 24,
              )),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
              child: Text(
            text,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
    );
  }
}
