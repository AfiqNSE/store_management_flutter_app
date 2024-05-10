import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_management_system/services/api_services.dart';

class ApiSignature {
  String path = "${ApiServices.base}/pallet";

  Future<http.StreamedResponse> sendSignature(
    int palletActivityId,
    File signature,
  ) async {
    var request = await _createRequest(palletActivityId, signature);
    var response = http.StreamedResponse(
      const Stream.empty(),
      HttpStatus.internalServerError,
    );

    try {
      response = await request.send();
    } catch (e) {
      debugPrint(e.toString());
      return response;
    }

    return response;
  }

  Future<http.MultipartRequest> _createRequest(
    int palletActivityId,
    File signature,
  ) async {
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse("$path/signature"),
    );

    // Add Fields
    request.fields["palletActivityId"] = palletActivityId.toString();

    // Add Signature File
    var signatureMultipartFile = await http.MultipartFile.fromPath(
      "signaturePath",
      signature.path,
    );
    request.files.add(signatureMultipartFile);

    return request;
  }
}
