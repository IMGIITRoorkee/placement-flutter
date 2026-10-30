import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/acknowledgementModel.dart';
import '../../services/generic/acknowledgementService.dart';
import '../../shared/loadingPage.dart';
import 'acknowledgementScreen.dart';

/// Checks the acknowledgement state once on start-up and shows
/// [AcknowledgementScreen] instead of [child] when the open season has not
/// been accepted. If the check fails, [child] is shown: the server still
/// gates every request, and the global handler opens the screen then.
class AcknowledgementGate extends StatefulWidget {
  final Widget child;

  const AcknowledgementGate({super.key, required this.child});

  @override
  State<AcknowledgementGate> createState() => _AcknowledgementGateState();
}

class _AcknowledgementGateState extends State<AcknowledgementGate> {
  late final Future<AcknowledgementModel?> _state;

  @override
  void initState() {
    super.initState();
    _state = locator<AcknowledgementService>().fetchState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AcknowledgementModel?>(
      future: _state,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(body: LoadingPage());
        }
        var state = snapshot.data;
        if (state != null && state.needsAcknowledgement) {
          return AcknowledgementScreen(state: state);
        }
        return widget.child;
      },
    );
  }
}
