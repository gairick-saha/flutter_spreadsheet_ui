part of 'widgets.dart';

class _TableBody extends StatelessWidget {
  const _TableBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterSpreadsheetUIState tableState = FlutterSpreadsheetUI.of(context);
    return SliverToBoxAdapter(
      child: LimitedBox(
        maxHeight: tableState.calculatedTotalRowsHeight,
        child: CustomScrollView(
          controller: tableState.tableBodyController,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          scrollBehavior: const FlutterSpreadsheetUIScrollBehavior(),
          slivers: const [
            _FreezedColumn(isHeaderItem: false),
            _NonFreezedColumns(isHeaderItem: false),
          ],
        ),
      ),
    );
  }
}
