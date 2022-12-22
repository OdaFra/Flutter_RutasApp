import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:rutasapp/blocs/blocs.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;
  final GpsBloc _gpsBloc = GpsBloc();

  LocationBloc() : super(const LocationState()) {
    on<OnStarFollowingUser>(
        (event, emit) => emit(state.copyWith(followingUser: true)));

    on<OnStopFollowingUser>(
        (event, emit) => emit(state.copyWith(followingUser: false)));

    on<OnNewUserLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          lastKwonLocation: event.newLocation,
          myLocationHistory: [...state.myLocationHistory, event.newLocation],
        ),
      );
    });
  }

  Future<void> getCurrentPosition() async {
    // if (_gpsBloc.state.isAllGranted) {
    //   try {
    final position = await Geolocator.getCurrentPosition();
    print(position);
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
    //   } catch (e) {
    //     print('El error es: $e');
    //   }
    // } else {
    //   return;
    // }

    //return position;
  }

  void startFollowingUser() {
    // if (_gpsBloc.state.isAllGranted) {
    //   try {

    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      print(position);
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    });
    add(OnStarFollowingUser());
    //   } catch (e) {
    //     print('El error es: $e');
    //   }
    // } else {
    //   return;
    // }
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    add(OnStopFollowingUser());
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
