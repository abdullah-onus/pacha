import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pacha/constants.dart';

class QRCodeGenerator extends StatefulWidget {
  final String qrData;
  const QRCodeGenerator({Key? key, required this.qrData}) : super(key: key);
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).screenQrGeneratorAppBarTitleText),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: QrImage(
          embeddedImage: Image.asset('assets/logo-qr-original.png').image,
          //embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(100, 100)),
          data: widget.qrData,
          gapless: false,
          padding: EdgeInsets.all(Constants().padding),
          version: QrVersions.auto,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    ));
  }
}
