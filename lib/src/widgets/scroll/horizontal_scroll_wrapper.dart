part of 'scroll.dart';

class _HorizontalScrollWrapper extends StatelessWidget {
  const _HorizontalScrollWrapper({
    Key? key,
    required this.scrollController,
    required this.slivers,
  }) : super(key: key);

  final ScrollController scrollController;
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      scrollBehavior: const FlutterSpreadsheetUIScrollBehavior(),
      controller: scrollController,
      slivers: slivers,
    );
  }
}
