import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/dummy_data.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // Начальная точка (например, центр Парижа или усредненная координата)
  final LatLng _center = const LatLng(48.8566, 2.3522);

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    // В реальности координаты должны быть в модели City. 
    // Пока создадим метки для примера на базе наших городов.
    final exampleCoords = [
      LatLng(42.8746, 74.5698), // Bishkek
      LatLng(48.1351, 11.5820), // Munich
      LatLng(48.8566, 2.3522),  // Paris
      LatLng(41.9028, 12.4964), // Rome
    ];

    for (int i = 0; i < cities.length && i < exampleCoords.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(cities[i].id),
          position: exampleCoords[i],
          infoWindow: InfoWindow(
            title: cities[i].name,
            snippet: cities[i].country,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Map'),
        elevation: 0,
      ),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 3.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 5));
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
