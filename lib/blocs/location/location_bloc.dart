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

  Future getCurrentPosition() async {
    if (_gpsBloc.state.isAllGranted != true) {
      return;
    } else {
      try {
        final position = await Geolocator.getCurrentPosition();
        add(OnNewUserLocationEvent(
            LatLng(position.latitude, position.longitude)));
      } catch (e) {
        print('El error es: $e');
      }
    }

    //return position;
  }

  void startFollowingUser() {
    if (_gpsBloc.state.isAllGranted != true) {
      return;
    } else {
      try {
        add(OnStarFollowingUser());
        positionStream = Geolocator.getPositionStream().listen((event) {
          final position = event;
          add(OnNewUserLocationEvent(
              LatLng(position.latitude, position.longitude)));
        });
      } catch (e) {
        print('El error es: $e');
      }
    }
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
