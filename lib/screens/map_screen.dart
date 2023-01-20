import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutasapp/blocs/location/location_bloc.dart';
import 'package:rutasapp/blocs/map/map_bloc.dart';
import 'package:rutasapp/views/views.dart';
import 'package:rutasapp/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
  @override
  void initState() {
    super.initState();
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    //locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    //  final locationBloc = BlocProvider.of<LocationBloc>(context);
    super.dispose();
    locationBloc.stopFollowingUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
        if (locationState.lastKwonLocation == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Espere por favor...'),
                SizedBox(height: 15),
                CircularProgressIndicator.adaptive(),
              ],
            ),
          );
        }

        return BlocBuilder<MapBloc, MapState>(
          builder: (context, mapState) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  MapView(
                    initialLocation: locationState.lastKwonLocation!,
                    polyline: mapState.polylines.values.toSet(),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          BtnFollowUser(),
          BtnCurrentLocation(),
        ],
      ),
    );
  }
}


// return GoogleMap(initialCameraPosition: initialCameraPosition);
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Text('La posición actual es '),
          //       Text(
          //           'Latitude : ${state.lastKwonLocation?.latitude}, Longitud : ${state.lastKwonLocation?.longitude}'),
          //     ],
          //   ),
          // );