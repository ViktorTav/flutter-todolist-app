import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  final IconData icon;

  const FieldLabel({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      )
    ]);
  }
}

class FieldContent extends StatelessWidget {
  final dynamic text;

  const FieldContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w100,
          color: Theme.of(context).colorScheme.onPrimary),
    );
  }
}

class Field extends StatelessWidget {
  final String label;
  final dynamic content;
  final IconData icon;

  const Field(
      {super.key,
      required this.label,
      required this.content,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).colorScheme.primary),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel(text: label, icon: icon),
          const SizedBox(
            height: 5.0,
          ),
          FieldContent(text: content)
        ],
      ),
    );
  }
}
