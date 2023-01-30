import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Todolist",
                style: TextStyle(
                    fontFamily: "Neucha",
                    fontSize: 70,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ));
  }
}
