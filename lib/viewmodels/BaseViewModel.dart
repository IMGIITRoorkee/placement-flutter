import 'package:flutter/material.dart';
import 'package:placement/enums/ViewStateEnum.dart';

class BaseViewModel extends ChangeNotifier {

  ViewStateEnum _state = ViewStateEnum.Idle;
  bool _isDisposed = false;
  bool _isLoading = false;

  @override
  void dispose() { 
    _isDisposed = true;
    super.dispose();
  }

  ViewStateEnum get state => _state;
  bool get isBusy => _isLoading;

  void reload() {
    if(!_isDisposed) notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    reload();
  }

  void setIdle() {
    _isLoading = false;
    reload();
  }

  void setViewState(ViewStateEnum viewState) {
    _state = viewState;
    notifyListeners();
  }
}