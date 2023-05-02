A Flutter package for creaing spreadsheet like ui.

## FlutterSpreadsheetUI - v0.0.2

[![pub package](https://img.shields.io/pub/v/flutter_spreadsheet_ui.svg?label=flutter_spreadsheet_ui&color=blue)](https://pub.dev/packages/flutter_spreadsheet_ui)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/gairick-saha/flutter_spreadsheet_ui.svg)](https://github.com/gairick-saha/flutter_spreadsheet_ui)
[![popularity](https://img.shields.io/pub/popularity/flutter_spreadsheet_ui?logo=dart)](https://pub.dev/packages/flutter_spreadsheet_ui/score)
[![likes](https://img.shields.io/pub/likes/flutter_spreadsheet_ui?logo=dart)](https://pub.dev/packages/flutter_spreadsheet_ui/score)
[![pub points](https://img.shields.io/pub/points/flutter_spreadsheet_ui?logo=dart)](https://pub.dev/packages/flutter_spreadsheet_ui/score)
[![GitHub issues](https://img.shields.io/github/issues/gairick-saha/flutter_spreadsheet_ui.svg)](https://github.com/gairick-saha/flutter_spreadsheet_ui/issues)
[![GitHub license](https://img.shields.io/github/license/gairick-saha/flutter_spreadsheet_ui.svg)](https://github.com/gairick-saha/flutter_spreadsheet_ui/blob/master/LICENSE)

<br>
<div align="center">

**Languages:**

[![English](https://img.shields.io/badge/Language-English-blue?style=for-the-badge)](README.md)

</div>
<br>

`FlutterSpreadsheetUI` is a spreadsheet like `DataTable` which can help you to make beautiful looking spreadsheet like application.

<br>

## Get started

Add this to your package's pubspec.yaml file:

```yaml
flutter_spreadsheet_ui: '^0.0.2'
```

<br>

### **Install it**

Install `flutter_spreadsheet_ui` package by running this command from the command line or terminal:

```
$ flutter pub get
```

Alternatively, your editor might support flutter pub get.

<br>

### **Import it**

Now in your Dart code, you can use:

```dart
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';
```

<br>

## How to use

Generate the data of `FlutterSpreadsheetUIColumn` and `FlutterSpreadsheetUIRow` to be used in the table.

```dart
final List<FlutterSpreadsheetUIColumn> _columns = [
    FlutterSpreadsheetUIColumn(
        contentAlignment: Alignment.center,
        cellBuilder: (context, cellId) => const Text("Task"),
    ),
    FlutterSpreadsheetUIColumn(
        width: 200,
        contentAlignment: Alignment.center,
        cellBuilder: (context, cellId) => const Text("Assigned Date"),
    ),
    FlutterSpreadsheetUIColumn(
        width: 110,
        cellBuilder: (context, cellId) => const Text("Permissions"),
    ),
];

final List<FlutterSpreadsheetUIRow> _rows = [
    FlutterSpreadsheetUIRow(
        cells: [
            FlutterSpreadsheetUICell(
                cellBuilder: (context, cellId) => const Text('Task 1'),
            ),
            FlutterSpreadsheetUICell(
                cellBuilder: (context, cellId) => Text(DateTime.now().toString()),
            ),
            FlutterSpreadsheetUICell(
                cellBuilder: (context, cellId) => const Text('None'),
            ),
        ],
    ),
];

```

Add `FlutterSpreadsheetUI` to your widget tree:

```dart
FlutterSpreadsheetUI(
    columns: _columns,
    rows: _rows,
),
```

<br>

Add `FlutterSpreadsheetUIConfig` to customize the default table configuration:

```dart
FlutterSpreadsheetUIConfig _tableConfig = const FlutterSpreadsheetUIConfig(
    enableColumnWidthDrag: true,
    enableRowHeightDrag: true,
    firstColumnWidth: 150,
    freezeFirstColumn: true,
    freezeFirstRow: true,
)
```

<br>

Now use it to pass `config` parameter inside the `FlutterSpreadsheetUI` widget:

```dart
FlutterSpreadsheetUI(
    config: _tableConfig,
    columns: _columns,
    rows: _rows,
),
```

<br>

Add `FlutterSpreadsheetUIColumnWidthResizeCallback` to get the updated width and columnIndex:
<br>
**NOTE:** :zap: [Will called when column width resize drag ends] :zap:

```dart
void _columnWidthResizeCallback(int columnIndex, double updatedWidth) {
    log("Column: $columnIndex's updated width: $updatedWidth");
}
```

Add `FlutterSpreadsheetUIRowHeightResizeCallback` to get the updated height and rowIndex:
<br>
**NOTE:** :zap: [Will called when row height resize drag ends] :zap:

```dart
void _rowHeightResizeCallback(int rowIndex, double updatedHeight) {
    log("Row: $rowIndex's updated width: $updatedHeight");
}
```

<br>

Now use `columnWidthResizeCallback` and `rowHeightResizeCallback` to pass the parameter inside the `FlutterSpreadsheetUI` widget:

```dart
FlutterSpreadsheetUI(
    config: _tableConfig,
    columnWidthResizeCallback: _columnWidthResizeCallback,
    rowHeightResizeCallback: _rowHeightResizeCallback,
    columns: _columns,
    rows: _rows,
),
```

<br>
## Example

![](./demo/example.gif)

<br>

### Donate to this project

[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/white_img.png)](https://www.buymeacoffee.com/gairicksaha)

<br>
