part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoutes;

  //Polylines

  final Map<String, Polyline> polylines;

  /// mi_ruta:{
  ///
  /// }

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRoutes = true,
    Map<String, Polyline>? polylines,
  }) : polylines = polylines ?? const <String, Polyline>{};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoutes,
    Map<String, Polyline>? polylines,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        showMyRoutes: showMyRoutes ?? this.showMyRoutes,
        polylines: polylines ?? this.polylines,
      );

  @override
  List<Object> get props => [
        isMapInitialized,
        isFollowingUser,
        polylines,
        showMyRoutes,
      ];

  @override
  String toString() =>
      'MapState(isMapInitialized: $isMapInitialized, isFollowingUser: $isFollowingUser, polylines: $polylines, showMyRoutes: $showMyRoutes)';
}
