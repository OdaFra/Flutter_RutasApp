import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutasapp/blocs/location/location_bloc.dart';
import 'package:rutasapp/themes/themes.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  MapBloc({
    required this.locationBloc,
  }) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(_onStopFollowingUser);
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);

    locationBloc.stream.listen((locationState) {
      if (locationState.lastKwonLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }

      if (!state.isFollowingUser) return;

      if (locationState.lastKwonLocation == null) return;

      moveCamera(locationState.lastKwonLocation!);
    });
  }

  FutureOr<void> _onInitMap(
      OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.mapController;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(
      isMapInitialized: true,
    ));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.moveCamera(cameraUpdate);
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKwonLocation == null) return;
    moveCamera(locationBloc.state.lastKwonLocation!);
  }

  void _onStopFollowingUser(
      OnStopFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: false));
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
      polylineId: const PolylineId('myRouter'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations,
    );

    final Map<String, Polyline> currentsPolylines = Map.from(state.polylines);

    currentsPolylines['myRoute'] = myRoute;

    emit(state.copyWith(polylines: currentsPolylines));
  }
}
