import 'package:flutter/material.dart';
import 'screens/book_list_screen.dart';

void main() {
  runApp(BookManagerApp());
}

class BookManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Manager',
      debugShowCheckedModeBanner: false,
theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: BookListScreen(),
    );
  }
}
