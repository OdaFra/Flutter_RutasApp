part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isfollowUser;

  const MapState({
    this.isMapInitialized = false,
    this.isfollowUser = false,
  });

  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowUser,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isfollowUser: isfollowUser ?? this.isfollowUser,
      );

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'MapState(isMapInitialized: $isMapInitialized, isfollowUser: $isfollowUser)';
}
