import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';

import 'bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        iconTheme: const IconThemeData(
          color: Colors.indigo,
        ),
        primarySwatch: Colors.indigo,
      ),
      home:Home(),
    );
  }
}
