import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutasapp/blocs/blocs.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      padding: const EdgeInsets.only(left: 40.0),
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.indigo,
        maxRadius: 25,
        child: IconButton(
            onPressed: () {
              final userLocation = locationBloc.state.lastKwonLocation;
              if (userLocation == null) return;
              //TODO:SnackBar.

              mapBloc.moveCamera(userLocation);
            },
            icon: const Icon(
              Icons.my_location_outlined,
              color: Colors.white,
            )),
      ),
    );
  }
}
