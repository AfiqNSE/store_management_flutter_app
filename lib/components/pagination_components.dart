import 'package:flutter/material.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';

class Pagination extends StatefulWidget {
  final int itemsPerPage;
  final List<dynamic> pallets;
  final Function(int page) onLoadMore;

  const Pagination({
    super.key,
    required this.itemsPerPage,
    required this.pallets,
    required this.onLoadMore,
  });

  @override
  State<Pagination> createState() => PaginationState();
}

class PaginationState extends State<Pagination> {
  int _page = 0;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      itemCount: widget.pallets.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.pallets.length) {
          int max = (_page + 1) * widget.itemsPerPage;

          if (index >= max || _loading) {
            if (!_loading) {
              _page++;
              _loadmore();
            }

            return Center(
              child: Container(
                height: 24,
                width: 24,
                margin: const EdgeInsets.all(12),
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(AppColor().blueZodiac),
                  strokeWidth: 2,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
        Pallet pallet = Pallet.fromMap(widget.pallets[index]);

        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: createPalletCard(context, pallet, searchView: true),
        );
      },
    );
  }

  reset() {
    _page = 0;
    setState(() {});
  }

  _loadmore() async {
    _loading = true;
    await widget.onLoadMore(_page);
    _loading = false;
    setState(() {});
  }
}
