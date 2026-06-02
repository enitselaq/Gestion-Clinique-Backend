import 'dart:typed_data';

import 'pdf_share_helper_stub.dart'
    if (dart.library.html) 'pdf_share_helper_web.dart';

Future<void> sharePdf({
  required Uint8List bytes,
  required String filename,
}) =>
    sharePdfImpl(bytes: bytes, filename: filename);
