import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutasapp/themes/themes.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapController? _mapController;
  MapBloc() : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
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
    _mapController!.moveCamera(cameraUpdate);
  }
}
