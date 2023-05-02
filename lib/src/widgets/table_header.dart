part of 'widgets.dart';

class _TableHeader extends StatelessWidget {
  const _TableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterSpreadsheetUIState tableState = FlutterSpreadsheetUI.of(context);
    return SliverPersistentHeader(
      pinned: tableState.freezeFirstRow,
      delegate: _TableHeaderDelegate(
        headerHeight: tableState.tempHeaderHeight ?? tableState.headerHeight,
        child: Material(
          elevation: 0,
          child: HorizontalScrollWrapper(
            scrollController: tableState.tableHeaderController,
            slivers: const [
              _FreezedColumn(isHeaderItem: true),
              _NonFreezedColumns(isHeaderItem: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TableHeaderDelegate({
    required this.headerHeight,
    required this.child,
  });

  final double headerHeight;
  final Widget child;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Align(
        alignment: Alignment.topLeft,
        child: child,
      );

  @override
  double get maxExtent => headerHeight;

  @override
  double get minExtent => headerHeight;

  @override
  bool shouldRebuild(covariant _TableHeaderDelegate oldDelegate) =>
      oldDelegate.headerHeight != headerHeight || oldDelegate.child != child;
}
