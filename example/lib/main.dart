import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return false;
          },
          child: FlutterSpreadsheetUI(
            columnCount: 10,
            rowCount: 50,
            diagonalDragBehavior: DiagonalDragBehavior.none,
            columnBuilder: (int index) => FlutterSpreadsheetUIColumn(
              width: 200,
              decoration: FlutterSpreadsheetUIColumnDecoration(
                border: FlutterSpreadsheetUIColumnBorder(
                  left: index == 0 ? const BorderSide() : BorderSide.none,
                  right: const BorderSide(),
                ),
              ),
            ),
            rowBuilder: (int index) => FlutterSpreadsheetUIRow(
              height: kMinInteractiveDimension,
              decoration: FlutterSpreadsheetUIRowDecoration(
                border: FlutterSpreadsheetUIRowBorder(
                  left: index == 0 ? const BorderSide() : BorderSide.none,
                  right: const BorderSide(),
                ),
              ),
            ),
            cellBuilder: (BuildContext context, CellIndex cellIndex) => Center(
              child: Text(
                cellIndex.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
