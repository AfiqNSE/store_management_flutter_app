import 'package:flutter/material.dart';
import 'package:store_management_system/components/pagination_components.dart';
import 'package:store_management_system/components/search_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/services/api_services.dart';

class SearchPalletView extends StatefulWidget {
  const SearchPalletView({super.key});

  @override
  State<SearchPalletView> createState() => _SearchPalletViewState();
}

class _SearchPalletViewState extends State<SearchPalletView> {
  GlobalKey<PaginationState> paginationKey = GlobalKey();
  final TextEditingController searchController = TextEditingController();

  List<dynamic>? _pallets;

  String _searchValue = "";

  bool searchMode = true;
  bool _loading = false;

  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    if (_searchValue != "") palletSearch();
  }

  palletSearch() async {
    setState(() => _loading = true);
    _pallets = await ApiServices.pallet.search(
      0,
      _itemsPerPage,
      _searchValue,
    );
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColor().milkWhite,
          centerTitle: true,
          actions: [
            const SizedBox(width: 35),
            Expanded(
              child: PalletSearch(
                padding: const EdgeInsets.only(left: 20, right: 20),
                controller: searchController,
                enabled: !_loading,
                waitTime: const Duration(seconds: 1),
                onSearch: (String value) async {
                  _searchValue = value;
                  paginationKey.currentState?.reset();
                  await palletSearch();
                },
              ),
            ),
          ],
        ),
        backgroundColor: AppColor().milkWhite,
        body: Builder(
          builder: (context) {
            if (_loading) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(AppColor().blueZodiac),
                ),
              );
            }

            if (_searchValue == "") {
              return Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 30),
                child: const Text('Enter pallet number to search pallet.'),
              );
            }

            if (_pallets == null) {
              return const SizedBox.shrink();
            }

            if (_pallets!.isEmpty) {
              return Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 30),
                child: const Text('No pallets found.'),
              );
            }

            return Pagination(
              key: paginationKey,
              itemsPerPage: _itemsPerPage,
              pallets: _pallets!,
              onLoadMore: (page) async {
                _pallets!.addAll(await ApiServices.pallet.search(
                  page,
                  _itemsPerPage,
                  _searchValue,
                ));

                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
