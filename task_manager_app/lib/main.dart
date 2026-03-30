import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Task Manager",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
