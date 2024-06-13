import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/utils/main_utils.dart';

class BLEPalletPrintView extends StatefulWidget {
  final Pallet pallet;
  const BLEPalletPrintView({super.key, required this.pallet});

  @override
  State<BLEPalletPrintView> createState() => _BLEPalletPrintViewState();
}

class _BLEPalletPrintViewState extends State<BLEPalletPrintView> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  BluetoothDevice? _pairedDevice;
  BluetoothDevice? _selectedDevice;

  bool _connected = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    initBluetoothPlatformState();
  }

  Future<void> initBluetoothPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _loading = false;
            show("bluetooth device state: connected", Colors.green.shade300,
                hide: true);
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _loading = false;
            show("bluetooth device state: disconnected", Colors.red.shade300,
                hide: true);
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            _loading = false;
            show("bluetooth device state: disconnect requested", Colors.grey,
                hide: true);
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            _loading = false;
            show("bluetooth device state: bluetooth turning off", Colors.grey);
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            _loading = false;
            show("bluetooth device state: bluetooth off", Colors.red.shade300,
                hide: true);
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            _loading = false;
            show("bluetooth device state: bluetooth on", Colors.green.shade300,
                hide: true);
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            _loading = false;
            show("bluetooth device state: bluetooth turning on",
                Colors.blue.shade300,
                hide: true);
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            _loading = false;
            show("bluetooth device state: error", Colors.red.shade300,
                hide: true);
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      for (var v in devices) {
        if (v.name == "D520") {
          _pairedDevice = v;
        }
      }
    });

    if (isConnected == true) {
      setState(() {
        _loading = false;
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Print Pallet Label'),
      backgroundColor: AppColor().milkWhite,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 8, 15.0, 8),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  (widget.pallet.palletType == "palletise")
                      ? 'Select Available Label Printer:'
                      : 'Select Available Receipt Printer:',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Divider(),
                (_pairedDevice != null)
                    ? ListTile(
                        onTap: () {
                          setState(() {
                            _selectedDevice = _pairedDevice;
                          });
                        },
                        title: Text('${_pairedDevice?.name}'),
                        subtitle: Text('${_pairedDevice?.address}'),
                        trailing: _selectedDevice != null &&
                                _selectedDevice?.address ==
                                    _pairedDevice?.address
                            ? const Icon(Icons.check)
                            : null,
                      )
                    : const Text('Not Available'),
                const Divider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().milkWhite,
                          elevation: 3,
                        ),
                        onPressed: () {
                          setState(() {
                            _loading = true;
                            _selectedDevice = null;
                          });

                          initBluetoothPlatformState();
                        },
                        child: const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedDevice == null
                              ? AppColor().greyGoose
                              : _connected
                                  ? Colors.red
                                  : Colors.green,
                          elevation: 3,
                        ),
                        onPressed: _connected
                            ? () {
                                setState(() {
                                  _loading = true;
                                });

                                _disconnect();
                              }
                            : () {
                                setState(() {
                                  _loading = true;
                                });

                                _connect();
                              },
                        child: Text(
                          _connected ? 'Disconnect' : 'Connect',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _connected
                              ? AppColor().blueZodiac
                              : AppColor().greyGoose,
                          elevation: 3,
                        ),
                        onPressed: _connected
                            ? () => printPalletLabel(widget.pallet)
                            : null,
                        child: const Text(
                          'Print',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_loading) ...[
              const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            ]
          ],
        ),
      ),
    );
  }

  void _connect() {
    if (_selectedDevice != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_selectedDevice!).catchError((error) {
            setState(() => _connected = false);
          });
        }
        setState(() => _connected = true);
      });
    } else {
      show('No device selected.', Colors.red.shade300);
    }

    setState(() {
      _loading = false;
    });
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() {
      _loading = false;
      _selectedDevice = null;
      _connected = false;
    });
  }

  Future show(
    String message,
    Color color, {
    Duration duration = const Duration(seconds: 5),
    bool hide = false,
  }) async {
    if (mounted) {
      if (hide) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: color,
          duration: duration,
        ),
      );
    }
  }

  // Print Label for palletise type
  void printPalletLabel(Pallet pallet) async {
    final now = DateTime.now();
    String dateTime = formatDateString(now.toString());

    String tsplCommands =
        "CLS\nSIZE 101.00 mm, 152.00 mm\nDENSITY 10\nGAP 3.0 mm, 0.0 mm\nDIRECTION 1,0\nREFERENCE 0,0\nOFFSET 0.0 mm\nCODEPAGE UTF-8\nTEXT 100,200,\"3\",0, 2, 2,\"Pallet Information\"\r\nTEXT 100,300,\"3\",0,1,1,\"Pallet No: ${pallet.palletNo}\"\r\nTEXT 100,380,\"3\",0,1,1,\"Status: ${pallet.status}\"\r\nTEXT 100,460,\"3\",0,1,1,\"Destination: ${pallet.destination.capitalize()}\"\r\nTEXT 100,540,\"3\",0,1,1,\"Lorry No: ${pallet.lorryNo}\"\r\nTEXT 100,620,\"3\",0,1,1,\"Date & Time: $dateTime\"\r\nBARCODE 100,700,\"128M\" ,90 ,1 ,0 ,4, 12,\"1234567890\"\r\nPRINT 1, 1\n";
    try {
      await bluetooth.writeBytes(Uint8List.fromList(tsplCommands.codeUnits));
      show('Print success', Colors.green.shade300);
    } catch (e) {
      show('Error during printing: $e', Colors.red.shade300);
    }
  }
}
