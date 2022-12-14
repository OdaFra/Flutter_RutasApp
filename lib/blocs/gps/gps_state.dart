part of 'gps_bloc.dart';

abstract class GpsState extends Equatable {
  const GpsState();
  
  @override
  List<Object> get props => [];
}

class GpsInitial extends GpsState {}
