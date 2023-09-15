part of 'ui.dart';

class FlutterSpreadsheetUIViewport extends TwoDimensionalViewport {
  const FlutterSpreadsheetUIViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required FlutterSpreadsheetUICellDelegateMixin super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderFlutterSpreadsheetUIViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      delegate: delegate as FlutterSpreadsheetUICellDelegateMixin,
      childManager: context as TwoDimensionalChildManager,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderFlutterSpreadsheetUIViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior
      ..delegate = delegate as FlutterSpreadsheetUICellDelegateMixin;
  }
}

class RenderFlutterSpreadsheetUIViewport extends RenderTwoDimensionalViewport {
  RenderFlutterSpreadsheetUIViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required FlutterSpreadsheetUICellDelegateMixin super.delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  FlutterSpreadsheetUICellDelegateMixin get delegate =>
      super.delegate as FlutterSpreadsheetUICellDelegateMixin;

  @override
  set delegate(FlutterSpreadsheetUICellDelegateMixin value) {
    super.delegate = value;
  }

  Map<int, _ColumnSpan> _columnMetrics = <int, _ColumnSpan>{};
  Map<int, _RowSpan> _rowMetrics = <int, _RowSpan>{};
  int? _firstNonPinnedRow;
  int? _firstNonPinnedColumn;
  int? _lastNonPinnedRow;
  int? _lastNonPinnedColumn;

  CellIndex? get _firstNonPinnedCell {
    if (_firstNonPinnedRow == null || _firstNonPinnedColumn == null) {
      return null;
    }
    return CellIndex(
      column: _firstNonPinnedColumn!,
      row: _firstNonPinnedRow!,
    );
  }

  CellIndex? get _lastNonPinnedCell {
    if (_lastNonPinnedRow == null || _lastNonPinnedColumn == null) {
      return null;
    }
    return CellIndex(
      column: _lastNonPinnedColumn!,
      row: _lastNonPinnedRow!,
    );
  }

  int? get _lastPinnedRow =>
      delegate.pinnedRowCount > 0 ? delegate.pinnedRowCount - 1 : null;
  int? get _lastPinnedColumn =>
      delegate.pinnedColumnCount > 0 ? delegate.pinnedColumnCount - 1 : null;

  double get _pinnedRowsSize =>
      _lastPinnedRow != null ? _rowMetrics[_lastPinnedRow]!.size : 0.0;

  double get _pinnedColumnsSize =>
      _lastPinnedColumn != null ? _columnMetrics[_lastPinnedColumn]!.size : 0.0;

  @override
  FlutterSpreadsheetUIParentData parentDataOf(RenderBox child) =>
      child.parentData! as FlutterSpreadsheetUIParentData;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlutterSpreadsheetUIParentData) {
      child.parentData = FlutterSpreadsheetUIParentData();
    }
  }

  void _updateAllMetrics() {
    assert(needsDelegateRebuild || didResize);

    _firstNonPinnedColumn = null;
    _lastNonPinnedColumn = null;
    double startOfRegularColumn = 0;
    double startOfPinnedColumn = 0;

    final Map<int, _ColumnSpan> newColumnMetrics = <int, _ColumnSpan>{};
    for (int column = 0; column < delegate.columnCount; column++) {
      final bool isPinned = column < delegate.pinnedColumnCount;
      final double startOffset =
          isPinned ? startOfPinnedColumn : startOfRegularColumn;
      _ColumnSpan? span = _columnMetrics.remove(column);
      assert(needsDelegateRebuild || span != null);
      final FlutterSpreadsheetUIColumn configuration = needsDelegateRebuild
          ? delegate.buildColumn(column)
          : span!.configuration;
      span ??= _ColumnSpan();
      span.updateColumn(
        isPinned: isPinned,
        configuration: configuration,
        startOffset: startOffset,
        width: configuration.width,
      );
      newColumnMetrics[column] = span;
      if (!isPinned) {
        if (span.size >= horizontalOffset.pixels &&
            _firstNonPinnedColumn == null) {
          _firstNonPinnedColumn = column;
        }
        final double targetColumnPixel = cacheExtent +
            horizontalOffset.pixels +
            viewportDimension.width -
            startOfPinnedColumn;
        if (span.size >= targetColumnPixel && _lastNonPinnedColumn == null) {
          _lastNonPinnedColumn = column;
        }
        startOfRegularColumn = span.size;
      } else {
        startOfPinnedColumn = span.size;
      }
    }
    assert(newColumnMetrics.length >= delegate.pinnedColumnCount);
    for (final _ColumnSpan span in _columnMetrics.values) {
      span.dispose();
    }
    _columnMetrics = newColumnMetrics;

    _firstNonPinnedRow = null;
    _lastNonPinnedRow = null;
    double startOfRegularRow = 0;
    double startOfPinnedRow = 0;

    final Map<int, _RowSpan> newRowMetrics = <int, _RowSpan>{};
    for (int row = 0; row < delegate.rowCount; row++) {
      final bool isPinned = row < delegate.pinnedRowCount;
      final double startOffset =
          isPinned ? startOfPinnedRow : startOfRegularRow;
      _RowSpan? span = _rowMetrics.remove(row);
      assert(needsDelegateRebuild || span != null);
      final FlutterSpreadsheetUIRow configuration =
          needsDelegateRebuild ? delegate.buildRow(row) : span!.configuration;
      span ??= _RowSpan();
      span.updateRow(
        isPinned: isPinned,
        configuration: configuration,
        startOffset: startOffset,
        height: configuration.height,
      );
      newRowMetrics[row] = span;
      if (!isPinned) {
        if (span.size >= verticalOffset.pixels && _firstNonPinnedRow == null) {
          _firstNonPinnedRow = row;
        }
        final double targetRowPixel = cacheExtent +
            verticalOffset.pixels +
            viewportDimension.height -
            startOfPinnedRow;
        if (span.size >= targetRowPixel && _lastNonPinnedRow == null) {
          _lastNonPinnedRow = row;
        }
        startOfRegularRow = span.size;
      } else {
        startOfPinnedRow = span.size;
      }
    }
    assert(newRowMetrics.length >= delegate.pinnedRowCount);
    for (final _RowSpan span in _rowMetrics.values) {
      span.dispose();
    }
    _rowMetrics = newRowMetrics;

    final double maxVerticalScrollExtent;
    if (_rowMetrics.length <= delegate.pinnedRowCount) {
      assert(_firstNonPinnedRow == null && _lastNonPinnedRow == null);
      maxVerticalScrollExtent = 0.0;
    } else {
      final int lastRow = _rowMetrics.length - 1;
      if (_firstNonPinnedRow != null) {
        _lastNonPinnedRow ??= lastRow;
      }
      maxVerticalScrollExtent = math.max(
        0.0,
        _rowMetrics[lastRow]!.size -
            viewportDimension.height +
            startOfPinnedRow,
      );
    }

    final double maxHorizontalScrollExtent;
    if (_columnMetrics.length <= delegate.pinnedColumnCount) {
      assert(_firstNonPinnedColumn == null && _lastNonPinnedColumn == null);
      maxHorizontalScrollExtent = 0.0;
    } else {
      final int lastColumn = _columnMetrics.length - 1;
      if (_firstNonPinnedColumn != null) {
        _lastNonPinnedColumn ??= lastColumn;
      }
      maxHorizontalScrollExtent = math.max(
        0.0,
        _columnMetrics[lastColumn]!.size -
            viewportDimension.width +
            startOfPinnedColumn,
      );
    }

    final bool acceptedDimension = horizontalOffset.applyContentDimensions(
            0.0, maxHorizontalScrollExtent) &&
        verticalOffset.applyContentDimensions(0.0, maxVerticalScrollExtent);
    if (!acceptedDimension) {
      _updateFirstAndLastVisibleCell();
    }
  }

  void _updateFirstAndLastVisibleCell() {
    _firstNonPinnedColumn = null;
    _lastNonPinnedColumn = null;
    final double targetColumnPixel = cacheExtent +
        horizontalOffset.pixels +
        viewportDimension.width -
        _pinnedColumnsSize;
    for (int column = 0; column < _columnMetrics.length; column++) {
      if (_columnMetrics[column]!.isPinned) {
        continue;
      }
      final double endOfColumn = _columnMetrics[column]!.size;
      if (endOfColumn >= horizontalOffset.pixels &&
          _firstNonPinnedColumn == null) {
        _firstNonPinnedColumn = column;
      }
      if (endOfColumn >= targetColumnPixel && _lastNonPinnedColumn == null) {
        _lastNonPinnedColumn = column;
        break;
      }
    }
    if (_firstNonPinnedColumn != null) {
      _lastNonPinnedColumn ??= _columnMetrics.length - 1;
    }

    _firstNonPinnedRow = null;
    _lastNonPinnedRow = null;
    final double targetRowPixel = cacheExtent +
        verticalOffset.pixels +
        viewportDimension.height -
        _pinnedRowsSize;
    for (int row = 0; row < _rowMetrics.length; row++) {
      if (_rowMetrics[row]!.isPinned) {
        continue;
      }
      final double endOfRow = _rowMetrics[row]!.size;
      if (endOfRow >= verticalOffset.pixels && _firstNonPinnedRow == null) {
        _firstNonPinnedRow = row;
      }
      if (endOfRow >= targetRowPixel && _lastNonPinnedRow == null) {
        _lastNonPinnedRow = row;
        break;
      }
    }
    if (_firstNonPinnedRow != null) {
      _lastNonPinnedRow ??= _rowMetrics.length - 1;
    }
  }

  @override
  void layoutChildSequence() {
    if (needsDelegateRebuild || didResize) {
      _updateAllMetrics();
    } else {
      _updateFirstAndLastVisibleCell();
    }

    if (_firstNonPinnedCell == null &&
        _lastPinnedRow == null &&
        _lastPinnedColumn == null) {
      assert(_lastNonPinnedCell == null);
      return;
    }

    final double? offsetIntoColumn = _firstNonPinnedColumn != null
        ? horizontalOffset.pixels -
            _columnMetrics[_firstNonPinnedColumn]!.startOffset -
            _pinnedColumnsSize
        : null;
    final double? offsetIntoRow = _firstNonPinnedRow != null
        ? verticalOffset.pixels -
            _rowMetrics[_firstNonPinnedRow]!.startOffset -
            _pinnedRowsSize
        : null;

    if (_lastPinnedRow != null && _lastPinnedColumn != null) {
      _layoutCells(
        start: const CellIndex(column: 0, row: 0),
        end: CellIndex(column: _lastPinnedColumn!, row: _lastPinnedRow!),
        offset: Offset.zero,
      );
    }

    if (_lastPinnedRow != null && _firstNonPinnedColumn != null) {
      assert(_lastNonPinnedColumn != null);
      assert(offsetIntoColumn != null);
      _layoutCells(
        start: CellIndex(column: _firstNonPinnedColumn!, row: 0),
        end: CellIndex(
          column: _lastNonPinnedColumn!,
          row: _lastPinnedRow!,
        ),
        offset: Offset(offsetIntoColumn!, 0),
      );
    }

    if (_lastPinnedColumn != null && _firstNonPinnedRow != null) {
      assert(_lastNonPinnedRow != null);
      assert(offsetIntoRow != null);
      _layoutCells(
        start: CellIndex(column: 0, row: _firstNonPinnedRow!),
        end: CellIndex(column: _lastPinnedColumn!, row: _lastNonPinnedRow!),
        offset: Offset(0, offsetIntoRow!),
      );
    }

    if (_firstNonPinnedCell != null) {
      assert(_lastNonPinnedCell != null);
      assert(offsetIntoColumn != null);
      assert(offsetIntoRow != null);
      _layoutCells(
        start: _firstNonPinnedCell!,
        end: _lastNonPinnedCell!,
        offset: Offset(offsetIntoColumn!, offsetIntoRow!),
      );
    }
  }

  void _layoutCells({
    required CellIndex start,
    required CellIndex end,
    required Offset offset,
  }) {
    double yPaintOffset = -offset.dy;
    for (int row = start.row; row <= end.row; row += 1) {
      double xPaintOffset = -offset.dx;
      final double rowHeight = _rowMetrics[row]!.height;
      for (int column = start.column; column <= end.column; column += 1) {
        final double columnWidth = _columnMetrics[column]!.width;

        final CellIndex cellIndex = CellIndex(column: column, row: row);

        final RenderBox? cell = buildOrObtainChildFor(cellIndex);

        if (cell != null) {
          final FlutterSpreadsheetUIParentData cellParentData =
              parentDataOf(cell);

          final BoxConstraints cellConstraints = BoxConstraints.tightFor(
            width: columnWidth,
            height: rowHeight,
          );
          cell.layout(cellConstraints);
          cellParentData.layoutOffset = Offset(xPaintOffset, yPaintOffset);
        }
        xPaintOffset += columnWidth;
      }
      yPaintOffset += rowHeight;
    }
  }

  final LayerHandle<ClipRectLayer> _clipPinnedRowsHandle =
      LayerHandle<ClipRectLayer>();
  final LayerHandle<ClipRectLayer> _clipPinnedColumnsHandle =
      LayerHandle<ClipRectLayer>();
  final LayerHandle<ClipRectLayer> _clipCellsHandle =
      LayerHandle<ClipRectLayer>();

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_firstNonPinnedCell == null &&
        _lastPinnedRow == null &&
        _lastPinnedColumn == null) {
      assert(_lastNonPinnedCell == null);
      return;
    }

    if (_firstNonPinnedCell != null) {
      assert(_lastNonPinnedCell != null);
      _clipCellsHandle.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Rect.fromLTWH(
          _pinnedColumnsSize,
          _pinnedRowsSize,
          viewportDimension.width - _pinnedColumnsSize,
          viewportDimension.height - _pinnedRowsSize,
        ),
        (PaintingContext context, Offset offset) {
          _paintCells(
            context: context,
            offset: offset,
            leading: _firstNonPinnedCell!,
            trailing: _lastNonPinnedCell!,
          );
        },
        clipBehavior: clipBehavior,
        oldLayer: _clipCellsHandle.layer,
      );
    } else {
      _clipCellsHandle.layer = null;
    }

    if (_lastPinnedColumn != null && _firstNonPinnedRow != null) {
      _clipPinnedColumnsHandle.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Rect.fromLTWH(
          0.0,
          _pinnedRowsSize,
          _pinnedColumnsSize,
          viewportDimension.height - _pinnedRowsSize,
        ),
        (PaintingContext context, Offset offset) {
          _paintCells(
            context: context,
            offset: offset,
            leading: CellIndex(column: 0, row: _firstNonPinnedRow!),
            trailing:
                CellIndex(column: _lastPinnedColumn!, row: _lastNonPinnedRow!),
          );
        },
        clipBehavior: clipBehavior,
        oldLayer: _clipPinnedColumnsHandle.layer,
      );
    } else {
      _clipPinnedColumnsHandle.layer = null;
    }

    if (_lastPinnedRow != null && _firstNonPinnedColumn != null) {
      _clipPinnedRowsHandle.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Rect.fromLTWH(
          _pinnedColumnsSize,
          0.0,
          viewportDimension.width - _pinnedColumnsSize,
          _pinnedRowsSize,
        ),
        (PaintingContext context, Offset offset) {
          _paintCells(
            context: context,
            offset: offset,
            leading: CellIndex(column: _firstNonPinnedColumn!, row: 0),
            trailing:
                CellIndex(column: _lastNonPinnedColumn!, row: _lastPinnedRow!),
          );
        },
        clipBehavior: clipBehavior,
        oldLayer: _clipPinnedRowsHandle.layer,
      );
    } else {
      _clipPinnedRowsHandle.layer = null;
    }

    if (_lastPinnedRow != null && _lastPinnedColumn != null) {
      _paintCells(
        context: context,
        offset: offset,
        leading: const CellIndex(column: 0, row: 0),
        trailing: CellIndex(column: _lastPinnedColumn!, row: _lastPinnedRow!),
      );
    }
  }

  void _paintCells({
    required PaintingContext context,
    required CellIndex leading,
    required CellIndex trailing,
    required Offset offset,
  }) {
    final LinkedHashMap<Rect, FlutterSpreadsheetUIColumnDecoration>
        columnDecorations =
        LinkedHashMap<Rect, FlutterSpreadsheetUIColumnDecoration>();

    for (int column = leading.column; column <= trailing.column; column++) {
      final _ColumnSpan span = _columnMetrics[column]!;
      if (span.configuration.decoration != null) {
        final RenderBox leadingCell = getChildFor(
          CellIndex(column: column, row: leading.row),
        )!;
        final RenderBox trailingCell = getChildFor(
          CellIndex(column: column, row: trailing.row),
        )!;

        final Rect rect = Rect.fromPoints(
          parentDataOf(leadingCell).paintOffset! + offset,
          parentDataOf(trailingCell).paintOffset! +
              Offset(trailingCell.size.width, trailingCell.size.height) +
              offset,
        );

        if (span.configuration.decoration != null) {
          columnDecorations[rect] = span.configuration.decoration!;
        }
      }
    }

    final LinkedHashMap<Rect, FlutterSpreadsheetUIRowDecoration>
        rowDecorations =
        LinkedHashMap<Rect, FlutterSpreadsheetUIRowDecoration>();

    for (int row = leading.row; row <= trailing.row; row++) {
      final _RowSpan span = _rowMetrics[row]!;
      if (span.configuration.decoration != null) {
        final RenderBox leadingCell = getChildFor(
          CellIndex(column: leading.column, row: row),
        )!;
        final RenderBox trailingCell = getChildFor(
          CellIndex(column: trailing.column, row: row),
        )!;

        final Rect rect = Rect.fromPoints(
          parentDataOf(leadingCell).paintOffset! + offset,
          parentDataOf(trailingCell).paintOffset! +
              Offset(trailingCell.size.width, trailingCell.size.height) +
              offset,
        );
        if (span.configuration.decoration != null) {
          rowDecorations[rect] = span.configuration.decoration!;
        }
      }
    }

    switch (mainAxis) {
      case Axis.vertical:
        rowDecorations
            .forEach((Rect rect, FlutterSpreadsheetUIDecoration decoration) {
          final FlutterSpreadsheetUIDecorationPaintDetails paintingDetails =
              FlutterSpreadsheetUIDecorationPaintDetails(
            canvas: context.canvas,
            rect: rect,
            axisDirection: horizontalAxisDirection,
          );
          decoration.paint(paintingDetails);
        });
        columnDecorations.forEach(
          (Rect rect, FlutterSpreadsheetUIDecoration decoration) {
            final FlutterSpreadsheetUIDecorationPaintDetails paintingDetails =
                FlutterSpreadsheetUIDecorationPaintDetails(
              canvas: context.canvas,
              rect: rect,
              axisDirection: verticalAxisDirection,
            );
            decoration.paint(paintingDetails);
          },
        );
        break;

      case Axis.horizontal:
        columnDecorations
            .forEach((Rect rect, FlutterSpreadsheetUIDecoration decoration) {
          final FlutterSpreadsheetUIDecorationPaintDetails paintingDetails =
              FlutterSpreadsheetUIDecorationPaintDetails(
            canvas: context.canvas,
            rect: rect,
            axisDirection: verticalAxisDirection,
          );
          decoration.paint(paintingDetails);
        });
        rowDecorations.forEach(
          (Rect rect, FlutterSpreadsheetUIDecoration decoration) {
            final FlutterSpreadsheetUIDecorationPaintDetails paintingDetails =
                FlutterSpreadsheetUIDecorationPaintDetails(
              canvas: context.canvas,
              rect: rect,
              axisDirection: horizontalAxisDirection,
            );
            decoration.paint(paintingDetails);
          },
        );
    }

    for (int column = leading.column; column <= trailing.column; column++) {
      for (int row = leading.row; row <= trailing.row; row++) {
        final RenderBox cell = getChildFor(
          CellIndex(
            column: column,
            row: row,
          ),
        )!;
        final FlutterSpreadsheetUIParentData cellParentData =
            parentDataOf(cell);
        if (cellParentData.isVisible) {
          context.paintChild(cell, offset + cellParentData.paintOffset!);
        }
      }
    }
  }

  @override
  void dispose() {
    _clipPinnedRowsHandle.layer = null;
    _clipPinnedColumnsHandle.layer = null;
    _clipCellsHandle.layer = null;
    super.dispose();
  }
}

class _ColumnSpan implements Drag {
  double get startOffset => _startOffset;
  late double _startOffset;

  double get width => _width;
  late double _width;

  FlutterSpreadsheetUIColumn get configuration => _configuration!;
  FlutterSpreadsheetUIColumn? _configuration;

  bool get isPinned => _isPinned;
  late bool _isPinned;

  double get size => startOffset + width;

  void updateColumn({
    required FlutterSpreadsheetUIColumn configuration,
    required double startOffset,
    required double width,
    required bool isPinned,
  }) {
    _startOffset = startOffset;
    _width = width;
    _isPinned = isPinned;
    if (configuration == _configuration) {
      return;
    }
    _configuration = configuration;
  }

  void dispose() {}

  @override
  void cancel() {}

  @override
  void end(DragEndDetails details) {}

  @override
  void update(DragUpdateDetails details) {
    log(details.delta.dx.toString());
  }
}

class _RowSpan {
  double get startOffset => _startOffset;
  late double _startOffset;

  double get height => _height;
  late double _height;

  FlutterSpreadsheetUIRow get configuration => _configuration!;
  FlutterSpreadsheetUIRow? _configuration;

  bool get isPinned => _isPinned;
  late bool _isPinned;

  double get size => startOffset + height;

  void updateRow({
    required FlutterSpreadsheetUIRow configuration,
    required double startOffset,
    required double height,
    required bool isPinned,
  }) {
    _startOffset = startOffset;
    _height = height;
    _isPinned = isPinned;
    if (configuration == _configuration) {
      return;
    }
    _configuration = configuration;
  }

  void dispose() {}
}
