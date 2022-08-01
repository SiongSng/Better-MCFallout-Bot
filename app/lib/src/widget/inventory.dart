import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart' hide NetworkImage;

class InventoryView extends StatefulWidget {
  final List<MinecraftItem> items;

  const InventoryView({Key? key, required this.items}) : super(key: key);

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final List<Row> rows = [];

  @override
  void initState() {
    final int rowCount = (widget.items.length / 9).ceil();
    for (int i = 0; i < rowCount; i++) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int j = 0; j < 9; j++)
            Builder(builder: (context) {
              final int index = i * 9 + j;
              if ((index + 1) > widget.items.length) {
                return Container();
              }

              final item = widget.items[index];

              return InventoryItem(
                item: item,
              );
            })
        ],
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

class InventoryItem extends StatefulWidget {
  final MinecraftItem item;

  const InventoryItem({Key? key, required this.item}) : super(key: key);

  @override
  State<InventoryItem> createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: '${widget.item.count} 個 ${widget.item.displayName}',
        child: NetworkImage(
            src:
                'https://raw.githubusercontent.com/SiongSng/mc-icons/master/pics/${widget.item.name}.png',
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            errorWidget: const Icon(Icons.grid_view)));
  }
}
