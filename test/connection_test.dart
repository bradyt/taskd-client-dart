import 'dart:io';

import 'package:test/test.dart';

void main() {
  var address = 'localhost';
  var port = 53589;
  var certificate = 'fixture/.task/first_last.cert.pem';
  var key = 'fixture/.task/first_last.key.pem';
  var ca = 'fixture/.task/ca.cert.pem';

  test('test fails', () async {
    var socket = await Socket.connect(
      address,
      port,
    );

    var madeIt = false;

    try {
      await SecureSocket.secure(
        socket,
        context: SecurityContext(withTrustedRoots: true)
          ..useCertificateChain(certificate)
          ..usePrivateKey(key)
          ..setTrustedCertificates(ca),
      ).then((socket) => socket.close());
      madeIt = true;
    } on HandshakeException catch (_) {}

    expect(madeIt, !Platform.isMacOS);
  });
  test('test succeeds', () async {
    var socket = await Socket.connect(
      address,
      port,
    );
    var secureSocket = await SecureSocket.secure(
      socket,
      context: SecurityContext(withTrustedRoots: true)
        ..useCertificateChain(certificate)
        ..usePrivateKey(key)
        ..setTrustedCertificates(ca),
      onBadCertificate: (_) => true,
    );

    await secureSocket.close();

    expect(secureSocket.done, completion(isA<SecureSocket>()));
  });
}
