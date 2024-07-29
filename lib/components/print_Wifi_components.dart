import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/utils/main_utils.dart';

class NetworkPrinter {
  Future<List<int>> testTicket(Pallet pallet, int itemTotal) async {
    final now = DateTime.now();
    String dateTime = formatDateString(now.toString());

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text('N.S.E LORRY TRANSPORT SDN. BHD.',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
        ),
        linesAfter: 1);

    bytes += generator.text(
      'Store Management Application',
      styles: const PosStyles(align: PosAlign.center),
      linesAfter: 2,
    );

    bytes += generator.text(
      'Lorry No: ${pallet.lorryNo}',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'Dest: ${pallet.destination.capitalize()}',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'Pallet No: ${pallet.palletNo}',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'Forklift Driver: ${pallet.assignToUserName}',
      styles: const PosStyles(
        align: PosAlign.left,
      ),
      linesAfter: 1,
    );

    bytes += generator.row([
      PosColumn(
        text: 'Name',
        width: 9,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: 'Qty',
        width: 3,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
    ]);

    bytes += generator.emptyLines(1);

    for (var v in pallet.items) {
      bytes += generator.row([
        PosColumn(
          text: v.customerName,
          width: 9,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: v.qty.toString(),
          width: 3,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
      ]);
    }

    bytes += generator.emptyLines(1);

    bytes += generator.row([
      PosColumn(
        text: 'Total Qty',
        width: 9,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: itemTotal.toString(),
        width: 3,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
    ]);

    bytes += generator.emptyLines(2);

    bytes += generator.text('Date: $dateTime',
        styles: const PosStyles(align: PosAlign.left));

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  Future<String> printTicket(List<int> ticket) async {
    String status = "";
    final printer = PrinterNetworkManager('192.168.10.100');

    try {
      PosPrintResult connect = await printer.connect();
      if (connect == PosPrintResult.success) {
        await printer.printTicket(ticket);
        status = "Success Print";
      } else {
        status = "Cannot Print Recipt:${connect.msg}";
      }
    } catch (e) {
      status = 'Error sending data: $e';
    } finally {
      printer.disconnect();
    }
    return status;
  }
}
