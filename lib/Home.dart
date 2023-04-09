import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
            target: LatLng(-23.6631361, -46.540326),
            zoom: 16,
            tilt: 0,
            bearing: 30)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapas e geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        // ignore: sort_child_properties_last
        child: const Icon(Icons.done),
        onPressed: _movimentarCamera,
      ),
      // ignore: avoid_unnecessary_containers
      body: GoogleMap(
        // mapType: MapType.normal,
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
            target: LatLng(-23.6631361, -46.540326), zoom: 16),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
