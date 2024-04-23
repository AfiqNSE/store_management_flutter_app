import 'package:flutter/material.dart';
import 'package:store_management_system/utils/main_utils.dart';

class PalletDetailsView extends StatefulWidget {
  const PalletDetailsView({super.key});

  @override
  State<PalletDetailsView> createState() => _PalletDetailsViewState();
}

class _PalletDetailsViewState extends State<PalletDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 254, 253, 1),
      appBar: AppBar(
        title: appBarTitle('Pallet Information'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              const Text('Pallet No:'),
              const Text(
                'PTN0001',
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromRGBO(0, 102, 178, 1),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Divider(
                color: Colors.blue.shade600,
                indent: 25,
                endIndent: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Status: '),
                  const Text(
                    'In Process',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 102, 178, 1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info_outline,
                      color: Color.fromRGBO(0, 102, 178, 1),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Move'),
              ),
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(0, 102, 178, 1),
                )),
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'data',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
