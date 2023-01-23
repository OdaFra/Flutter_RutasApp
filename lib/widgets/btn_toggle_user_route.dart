import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutasapp/blocs/blocs.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      padding: const EdgeInsets.only(left: 40.0),
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.indigo,
        maxRadius: 25,
        child: IconButton(
            onPressed: () {
              mapBloc.add(OnToggleUserRoute());
            },
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            )),
      ),
    );
  }
}
