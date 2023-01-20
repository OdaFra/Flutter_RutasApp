import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutasapp/blocs/blocs.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.initialLocation,
    required this.polyline,
  });

  final LatLng initialLocation;
  final Set<Polyline> polyline;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15,
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (pointerMoveEvent) =>
            mapBloc.add(OnStopFollowingUserEvent()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          polylines: polyline,
          onMapCreated: (controller) => mapBloc.add(
            OnMapInitializedEvent(controller),
          ),
          //TODO: Markers
          //TODO: polylines
          //TODO: Cuando se mueve el mapa
        ),
      ),
    );
  }
}
