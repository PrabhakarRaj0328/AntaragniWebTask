import 'package:flutter/material.dart';

class Recents extends StatefulWidget {
  const Recents({super.key});

  @override
  State<Recents> createState() => _RecentsState();
}

class _RecentsState extends State<Recents> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 200),
      child: Text(
        "Make your first call so that your loved ones are just a tap away!",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    )
    );
  }
}
