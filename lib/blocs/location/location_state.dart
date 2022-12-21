part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastKwonLocation;
  final List<LatLng> myLocationHistory;
  const LocationState({
    this.followingUser = false,
    this.lastKwonLocation,
    myLocationHistory,
  }) : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKwonLocation,
    List<LatLng>? myLocationHistory,
  }) =>
      LocationState(
        followingUser: followingUser ?? this.followingUser,
        lastKwonLocation: lastKwonLocation ?? this.lastKwonLocation,
        myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      );

  @override
  List<Object?> get props =>
      [followingUser, lastKwonLocation, myLocationHistory];
}
