import 'package:flutter/material.dart';
import 'package:to_do/layout/home_layout.dart';
import 'package:bloc/bloc.dart';
import 'package:to_do/widgets/cutom_buitld_tasks_Item.dart';

void main() {
  // Bloc.observer = MyBlocObserver();
  runApp(const Main());
}
class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: HomeLayout(),
    );
  }
}
