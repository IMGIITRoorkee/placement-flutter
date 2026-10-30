import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../locator.dart';
import '../../models/acknowledgementModel.dart';
import '../../resources/R.dart';
import '../../resources/strings.dart';
import '../../services/auth/auth_service.dart';
import '../../services/generic/acknowledgementService.dart';
import '../../shared/GlobalCache.dart';

/// Blocks the PIC section until the student accepts the acknowledgement for
/// the open season. Shown on start-up when the state asks for it, and opened
/// by [AcknowledgementService.checkResponse] when a request is gated.
class AcknowledgementScreen extends StatefulWidget {
  /// The state from the start-up check, or null when opened by a gated
  /// request, in which case it is fetched for the season name.
  final AcknowledgementModel? state;

  const AcknowledgementScreen({super.key, this.state});

  @override
  State<AcknowledgementScreen> createState() => _AcknowledgementScreenState();
}

class _AcknowledgementScreenState extends State<AcknowledgementScreen> {
  final AcknowledgementService _service = locator<AcknowledgementService>();
  AcknowledgementModel? _state;
  bool _checked = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _service.setScreenOpen(true);
    _state = widget.state;
    if (_state == null) _loadState();
  }

  @override
  void dispose() {
    _service.setScreenOpen(false);
    super.dispose();
  }

  Future<void> _loadState() async {
    var state = await _service.fetchState();
    if (!mounted || state == null) return;
    setState(() => _state = state);
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  if (_state != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        "${_state!.seasonName} season",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: R.textColSecondary),
                      ),
                    ),
                  for (var para in Strings.ACKNOWLEDGEMENT_TEXT)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(para, style: TextStyle(fontSize: 15.0)),
                    ),
                ],
              ),
            ),
            CheckboxListTile(
              value: _checked,
              onChanged: _submitting
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
