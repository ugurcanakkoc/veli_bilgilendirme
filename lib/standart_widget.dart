import 'package:flutter/material.dart';

class StandartWidget extends StatelessWidget {
  final Widget child;

  const StandartWidget({super.key, this.child = const Text("NULL")});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: standartMargin,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widgetRengi,
        borderRadius: standartBorder,
      ),
      child: child,
    );
  }
}

const EdgeInsetsGeometry standartMargin = EdgeInsets.all(14);
const Color widgetRengi = Color.fromARGB(255, 39, 60, 68);
final BorderRadius standartBorder = BorderRadius.circular(21.0);
final EdgeInsets standartPadding = EdgeInsets.all(16.0);

TextStyle standartTextLat = const TextStyle(
    fontFamily: "RobotoCondensed",
    fontSize: 23,
    fontWeight: FontWeight.w400,
    color: Colors.white);

TextStyle standartTextBold = const TextStyle(
    fontFamily: "RobotoCondensed",
    fontSize: 35,
    color: Colors.white,
    fontWeight: FontWeight.bold);
