import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class PalletSignature extends StatefulWidget {
  final String palletNo;
  final int palletActivityId;
  const PalletSignature({
    super.key,
    required this.palletNo,
    required this.palletActivityId,
  });

  @override
  State<PalletSignature> createState() => _PalletSignatureState();
}

class _PalletSignatureState extends State<PalletSignature> {
  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  bool? _signature;
  bool isAccess = true;

  closePallet(int palletActivityId) async {
    bool res = await ApiServices.pallet.close(palletActivityId);
    if (mounted) {
      if (res != true) {
        customShowToast(
          context,
          "Failed to close the pallet. Please try again.",
          Colors.red.shade300,
          dismiss: true,
        );
        return;
      }
      customShowToast(
        context,
        "Pallet closed successfully.",
        Colors.blue.shade300,
        dismiss: true,
      );
      setState(() {});

      Provider.of<PalletNotifier>(context, listen: false)
          .close(palletActivityId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget actionButton = Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.minPositive, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.blue.shade600,
                      width: 0.8,
                    ),
                  ),
                  backgroundColor: AppColor().milkWhite,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.blue.shade600,
                      width: 0.8,
                    ),
                  ),
                  backgroundColor: AppColor().milkWhite,
                ),
                onPressed: () {
                  _signature = null;
                  signaturePadKey.currentState!.clear();
                },
                child: Text(
                  "Clear",
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColor().blueZodiac,
                ),
                onPressed: () => validateSignature(),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar('Pallet Signature (${widget.palletNo})'),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: SfSignaturePad(
                  key: signaturePadKey,
                  minimumStrokeWidth: 1,
                  maximumStrokeWidth: 3,
                  strokeColor: Colors.blue,
                  backgroundColor: Colors.white,
                  onDrawEnd: () {
                    _signature = true;
                  },
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  '*Signature Area*',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Action button to submit/clear/cancel signature
              actionButton,
            ],
          ),
        ),
      ),
    );
  }

  void validateSignature() async {
    if (_signature != null) {
      await _sendSignature(widget.palletActivityId);
    } else {
      customShowToast(
        context,
        'Please sign the pallet before press submit',
        Colors.red.shade300,
      );
    }
  }

  _sendSignature(index) async {
    // Save the signature as a file
    ui.Image signature = await signaturePadKey.currentState!.toImage();

    ByteData? byteData =
        await signature.toByteData(format: ui.ImageByteFormat.png);
    Uint8List signatureBytes = byteData!.buffer.asUint8List();

    //Create temporary directory to store the signature image
    final tempDir = await getTemporaryDirectory();
    File signatureFile = File('${tempDir.path}/${widget.palletNo}.jpeg');
    await signatureFile.writeAsBytes(signatureBytes);

    var res = await ApiServices.signature
        .sendSignature(widget.palletActivityId, signatureFile, isAccess);

    if (mounted) {
      if (res.statusCode != HttpStatus.ok) {
        customShowToast(
          context,
          'Failed to send signature. Please try again.',
          Colors.red.shade300,
        );
        return;
      } else {
        customShowToast(
          context,
          'Successfully sign the pallet.',
          Colors.red.shade300,
        );

        // Call the close pallet api
        await closePallet(widget.palletActivityId).then((_) {
          Navigator.pop(context);
        });
        return;
      }
    }
    setState(() {});
  }
}
