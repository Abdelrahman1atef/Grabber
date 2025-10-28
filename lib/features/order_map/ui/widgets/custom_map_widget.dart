import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:products/features/order_map/logic/order_cubit.dart';
import 'package:products/features/order_map/logic/order_state.dart';
import 'package:products/gen/assets.gen.dart';
import 'package:location/location.dart';
import 'package:products/gen/colors.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/order_model.dart';

class CustomMapScreen extends StatefulWidget {
  const CustomMapScreen({super.key});

  @override
  State<CustomMapScreen> createState() => _CustomMapScreenState();
}

class _CustomMapScreenState extends State<CustomMapScreen> {
  GoogleMapController? _mapController; // ✅ FIXED: Made nullable
  final Location _locationController = Location();
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropOffIcon;
  BitmapDescriptor? _carIcon;
  String? _mapStyle;

  // NEW
  bool _shouldAnimateCar = false;
  Timer? _animationTimer;

  LatLng defaultLocation = const LatLng(31.037119, 31.379824);
  LatLng pickupLocation = const LatLng(31.038525, 31.354811);
  LatLng dropOffLocation = const LatLng(31.037119, 31.379824);
  List<LatLng> _routePoints = [];
  LatLng? _currentPosition;
  int _currentPointIndex = 0;

  bool isOrderPlaced = false;
  bool _hasLoadedRoute = false;
  double _currentBearing = 0.0;

  @override
  void initState() {
    super.initState();
    _getLocationUpdate();
    _loadMarkers();
    _loadMapStyle();
    ;
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _mapStyle == null
        ? const Center(child: CircularProgressIndicator())
        : _currentPosition == null
        ? const Center(child: CircularProgressIndicator())
        : BlocListener<OrderCubit, OrderState>(
      // ✅ Use BlocListener for side effects (loading route)
      listener: (context, state) {
        state.whenOrNull(
          loaded: (order) {
            final newOrderPlaced =
                order.ordersState == OrdersStates.outForDelivery;

            // ✅ Only load route once when order state changes
            if (newOrderPlaced && !_hasLoadedRoute) {
              print('📍 Loading route for the first time...');
              _hasLoadedRoute = true;
              isOrderPlaced = true;
              _loadRoute();
            } else if (!newOrderPlaced && _hasLoadedRoute) {
              // ✅ Reset if order is no longer out for delivery
              _hasLoadedRoute = false;
              isOrderPlaced = false;
              setState(() {
                _routePoints = [];
              });
            }
          },
        );
      },
      child: BlocBuilder<OrderCubit, OrderState>(
        buildWhen: (previous, current) {
          // ✅ Only rebuild when order state actually changes
          return previous.maybeWhen(
            loaded: (prevOrder) => current.maybeWhen(
              loaded: (currOrder) =>
              prevOrder.ordersState != currOrder.ordersState,
              orElse: () => true,
            ),
            orElse: () => true,
          );
        },
        builder: (context, state) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: dropOffLocation,
              zoom: 17,
            ),
            style: _mapStyle,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller; // ✅ FIXED: Now safely assigns
              if (_shouldAnimateCar) {
                Future.delayed(
                  const Duration(seconds: 1),
                  _animateCarAlongRoute,
                );
              }
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            compassEnabled: false,
            polylines: {
              if (_routePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: _routePoints,

                  // Color & Width
                  color: ColorName.primaryColor,
                  width: 7,

                  // 🎯 Rounded Corners - THIS IS THE KEY!
                  jointType: JointType.round,
                  // Options: round, bevel, miter

                  // End Caps (rounded ends)
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,

                  // Dash Pattern
                  patterns: [
                    PatternItem.dash(50), // Length of dash
                    PatternItem.gap(40), // Length of gap
                  ],

                  // Other Options
                  geodesic: true,
                  // Follow earth's curvature
                  visible: true,
                  // Show/hide polyline
                  zIndex: 1,
                  // Layer order
                  consumeTapEvents: true, // Handle tap events
                ),
            },
            markers: {
              if (_pickupIcon != null)
                Marker(
                  markerId: const MarkerId('pickup'),
                  position: _currentPosition!,
                  icon: _pickupIcon!,
                  anchor: const Offset(0.5, 1.0),
                ),
              if (!isOrderPlaced && _dropOffIcon != null)
                Marker(
                  markerId: const MarkerId('dropOff'),
                  position: dropOffLocation,
                  icon: _dropOffIcon!,
                  anchor: const Offset(0.5, 1.0),
                ),
              if (isOrderPlaced && _carIcon != null)
                Marker(
                  markerId: const MarkerId('car'),
                  position: _routePoints.isEmpty
                      ? dropOffLocation
                      : _routePoints[_currentPointIndex],
                  icon: _carIcon!,
                  anchor: const Offset(0.5, 0.5), // ✅ Center anchor for rotation
                  rotation: _currentBearing+50, // ✅ Rotate car icon!
                ),
            },
          );
        },
      ),
    );
  }

  Future<void> _loadRoute() async {
    // ✅ FIXED: Check if _currentPosition is not null before using it
    if (_currentPosition == null) {
      debugPrint('Cannot load route: current position is null');
      return;
    }

    final points = await _getRouteBetween(dropOffLocation, _currentPosition!);

    if (mounted) {
      setState(() {
        _routePoints = points;
        _shouldAnimateCar = points.isNotEmpty;
      });
      if (_shouldAnimateCar) {
        Future.delayed(
          const Duration(seconds: 1),
          _animateCarAlongRoute,
        );
      }
    }
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    // ✅ FIXED: Check if controller is initialized
    final controller = _mapController;
    if (controller == null) {
      debugPrint('Cannot move camera: map controller not initialized');
      return;
    }

    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 17);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> _getLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((
        LocationData currentLocation,) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        final newPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        setState(() {
          _currentPosition = newPosition;
        });
      }
    });
  }

  void _animateCarAlongRoute() {
    if (_routePoints.isEmpty) return;

    _animationTimer?.cancel();

    print('🚗 Starting car animation with ${_routePoints.length} points');

    _animationTimer = Timer.periodic(
      const Duration(milliseconds: 500),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_currentPointIndex >= _routePoints.length - 1) {
          print('🏁 Car reached destination!');
          timer.cancel();
          context.read<OrderCubit>().emitOrderDelivered();
          return;
        }

        setState(() {
          _currentPointIndex++;

          // ✅ Calculate bearing for next movement
          if (_currentPointIndex < _routePoints.length) {
            _currentBearing = _calculateBearing(
              _routePoints[_currentPointIndex - 1],
              _routePoints[_currentPointIndex],
            );
          }
        });

        print('🚗 Car moving to point $_currentPointIndex, bearing: $_currentBearing°');

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _routePoints[_currentPointIndex],
              zoom: 17,
            ),
          ),
        );
      },
    );
  }
  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * (pi / 180);
    final lat2 = end.latitude * (pi / 180);
    final lon1 = start.longitude * (pi / 180);
    final lon2 = end.longitude * (pi / 180);

    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    final bearing = atan2(y, x) * (180 / pi);
    return (bearing + 360) % 360;
  }

  Future<void> _loadMarkers() async {
    final pickup = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      Assets.markers.pickupMarker.path,
      width: 24,
      height: 24,
    );
    final dropOff = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      Assets.markers.dropoffMarker.path,
      width: 24,
      height: 24,
    );
    final car = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      Assets.markers.carMarker.path,
      width: 24,
      height: 24,
    );

    setState(() {
      _pickupIcon = pickup;
      _dropOffIcon = dropOff;
      _carIcon = car;
    });
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString(Assets.maps.mapStyleLight);
      if (mounted) {
        setState(() {
          _mapStyle = style;
        });
      }
    } catch (e) {
      debugPrint('Failed to load map style: $e');
    }
  }

  Future<List<LatLng>> _getRouteBetween(LatLng from, LatLng to) async {
    // // 🆓 OPTION 1: Try Google Directions API (requires billing but $200 free/month)
    // try {
    //   print('🗺️ Trying Google Directions API...');
    //
    //   PolylinePoints polylinePoints = PolylinePoints(
    //     apiKey: 'AIzaSyAPKYx2O3dnXnFI3iA8XugOv9W__GAOLYg',
    //   );
    //
    //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //     request: PolylineRequest(
    //       origin: PointLatLng(from.latitude, from.longitude),
    //       destination: PointLatLng(to.latitude, to.longitude),
    //       mode: TravelMode.driving,
    //     ),
    //   );
    //
    //   if (result.points.isNotEmpty) {
    //     print('✅ Google route found - ${result.points.length} points');
    //     return result.points
    //         .map((point) => LatLng(point.latitude, point.longitude))
    //         .toList();
    //   } else {
    //     print('⚠️ Google API failed: ${result.errorMessage}');
    //   }
    // } catch (e) {
    //   print('⚠️ Google API error: $e');
    // }

    // 🆓 OPTION 2: Fallback to OpenRouteService (100% free, no billing)
    try {
      print('🔄 Falling back to OpenRouteService...');
      return await _getRouteFromOpenRouteService(from, to);
    } catch (e) {
      print('❌ OpenRouteService error: $e');
    }

    // 🆓 OPTION 3: Simple straight line fallback
    print('⚠️ Using straight line as fallback');
    return [from, to];
  }

  Future<List<LatLng>> _getRouteFromOpenRouteService(LatLng from,
      LatLng to,) async {
    // Get free API key from: https://openrouteservice.org/dev/#/signup
    const String apiKey =
        'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImI0ODdkZTU0ZmQ4ZjRhZjg4ZjBhZDUwM2E4NmJjNGE3IiwiaCI6Im11cm11cjY0In0='; // Replace with your key

    final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?'
          'start=${from.longitude},${from.latitude}&'
          'end=${to.longitude},${to.latitude}',
    );

    try {
      final response = await http.get(url, headers: {'Authorization': apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coordinates =
        data['features'][0]['geometry']['coordinates'] as List;

        List<LatLng> route = coordinates
            .map((coord) => LatLng(coord[1], coord[0])) // Note: reversed order
            .toList();

        print('✅ OpenRouteService route found - ${route.length} points');
        return route;
      } else {
        print('❌ OpenRouteService HTTP ${response.statusCode}');
        throw Exception('Failed to fetch route');
      }
    } catch (e) {
      print('❌ OpenRouteService error: $e');
      rethrow;
    }
  }

}
