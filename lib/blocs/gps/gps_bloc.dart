import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;
  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>(_gpsAndPermission);
    // (event, emit) => emit(state.copyWith(
    //     isGpsEnabled: event.iGpsEnabled,
    //     isGpsPermissionGranted: event.isGpsPermissionGranted,
    //   )));

    _init();
  }

  FutureOr<void> _gpsAndPermission(
      GpsAndPermissionEvent event, Emitter<GpsState> emit) {
    emit(state.copyWith(
      isGpsEnabled: event.iGpsEnabled,
      isGpsPermissionGranted: event.isGpsPermissionGranted,
    ));
    _init();
  }

  Future<void> _init() async {
    // final isEnabled = await _checkGpsStatus();
    // final isGranted = await _isPermissionGranted();
    // print(' isEnabled:  $isEnabled, isGranted: $isGranted');

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted(),
    ]);

    add(
      GpsAndPermissionEvent(
        iGpsEnabled: gpsInitStatus[0],
        isGpsPermissionGranted: gpsInitStatus[1],
      ),
    );
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      add(GpsAndPermissionEvent(
        iGpsEnabled: isEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted,
      ));
    });
    return isEnable;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            iGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true));
        break;
      case PermissionStatus.denied:
      // add(GpsAndPermissionEvent(
      //     iGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: false));
      // break;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(
            iGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: false));
        openAppSettings();
    }
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
