import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  Position? _position;
  String? _country;
  bool _isLoading = false;

  Position? get position => _position;
  String? get country => _country;
  bool get isLoading => _isLoading;

  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();
    try {
      _position = await _locationService.getCurrentPosition();
      _country = await _locationService.getCountryFromPosition(_position!);
    } catch (e) {
      _country = null;
    }
    _isLoading = false;
    notifyListeners();
  }
} 