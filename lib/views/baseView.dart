import 'package:flutter/material.dart';
import 'package:placement/locator.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T) onModelReady;

  BaseView({required this.builder, required this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model;

  @override
  void initState() {
    model = locator<T>();
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: (context, model, child) {
          if (model.isBusy) {
            return Center(
              child: LoadingPage(),
            );
          } else {
            return widget.builder(context, model, child);
          }
        },
      ),
    );
  }
}
