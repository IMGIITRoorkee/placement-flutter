import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../locator.dart';
import '../../resources/R.dart';
import '../../resources/endpoints.dart';
import '../../resources/strings.dart';
import '../../services/auth/auth_service.dart';
import '../../services/generic/acknowledgementService.dart';
import '../../shared/GlobalCache.dart';
import '../../shared/loadingPage.dart';

/// Blocks the PIC section until the student accepts the acknowledgement for
/// the open season. The document is [EndPoints.ACKNOWLEDGEMENT_PDF].
/// Shown on start-up when the state asks for it, and opened by
/// [AcknowledgementService.checkResponse] when a request is gated.
class AcknowledgementScreen extends StatefulWidget {
  const AcknowledgementScreen({super.key});

  @override
  State<AcknowledgementScreen> createState() => _AcknowledgementScreenState();
}

class _AcknowledgementScreenState extends State<AcknowledgementScreen> {
  final AcknowledgementService _service = locator<AcknowledgementService>();
  bool _checked = false;
  bool _submitting = false;
  bool _pdfReady = false;
  bool _mountPdf = true;
  static final Uri _pdfUri = Uri.parse(EndPoints.ACKNOWLEDGEMENT_PDF);

  @override
  void initState() {
    super.initState();
    _service.setScreenOpen(true);
  }

  @override
  void dispose() {
    _service.setScreenOpen(false);
    super.dispose();
  }

  void _retryPdf() {
    setState(() {
      _pdfReady = false;
      _mountPdf = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _mountPdf = true);
    });
  }

  Widget _loadingBanner(
      BuildContext context, int bytesDownloaded, int? totalBytes) {
    return Center(
      child: CircularProgressIndicator(
        value: totalBytes != null && totalBytes > 0
            ? bytesDownloaded / totalBytes
            : null,
        color: R.primaryCol,
      ),
    );
  }

  Widget _errorBanner(BuildContext context, Object error, StackTrace? stackTrace,
      PdfDocumentRef documentRef) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Could not load the acknowledgement."),
          TextButton(onPressed: _retryPdf, child: Text("Try again")),
        ],
      ),
    );
  }

  Widget _document() {
    if (!_mountPdf) return LoadingPage();
    return PdfViewer.uri(
      _pdfUri,
      params: PdfViewerParams(
        backgroundColor: const Color(0xFFF2F2F2),
        loadingBannerBuilder: _loadingBanner,
        errorBannerBuilder: _errorBanner,
        onViewerReady: (document, controller) {
          if (!mounted || _pdfReady) return;
          setState(() => _pdfReady = true);
        },
      ),
    );
  }

  Future<void> _accept() async {
    setState(() => _submitting = true);
    var result = await _service.accept();
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case AcknowledgementResult.accepted:
        // Anything cached before the season opened is stale now.
        locator<GlobalCache>().clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        break;
      case AcknowledgementResult.forbidden:
        Fluttertoast.showToast(
            msg: "Only active students can use Placement Online.",
            textColor: Colors.red,
            toastLength: Toast.LENGTH_LONG);
        break;
      case AcknowledgementResult.failed:
        Fluttertoast.showToast(
            msg: "Could not save your acceptance. Please check your connection.",
            textColor: Colors.red,
            toastLength: Toast.LENGTH_LONG);
        break;
    }
  }

  Future<void> _logout() async {
    await AuthService().logOut();
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/wrapper', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.ACKNOWLEDGEMENT_TITLE),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton(
            onPressed: _submitting ? null : _logout,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text("Log out"),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: _document()),
            CheckboxListTile(
              value: _checked,
              onChanged: _submitting || !_pdfReady
                  ? null
                  : (value) => setState(() => _checked = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: R.primaryCol,
              title: Text(Strings.ACKNOWLEDGEMENT_CHECKBOX),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: ElevatedButton(
                onPressed: _checked && !_submitting ? _accept : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: R.primaryCol,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: _submitting
                    ? SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.0, color: Colors.white),
                      )
                    : Text(Strings.ACKNOWLEDGEMENT_ACCEPT),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
