import 'dart:typed_data';

Future<void> sharePdfImpl({
  required Uint8List bytes,
  required String filename,
}) async {
  throw UnsupportedError('PDF sharing is only available on web.');
}
