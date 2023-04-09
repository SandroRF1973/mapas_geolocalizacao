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

  Set<Marker> _marcadores = {};

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

  _carregarMarcadores() {
    Set<Marker> marcadoresLocal = {};

    Marker marcadorShopping = Marker(
        markerId: const MarkerId("marcador-shopping"),
        position: const LatLng(-23.56331643290178, -46.652642650333135),
        infoWindow: const InfoWindow(title: "Shopping Cidade São Paulo"),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        onTap: () {
          // ignore: avoid_print
          print("shopping clicado!");
        }
        //rotation: 45
        );

    Marker marcadorCartorio = Marker(
        markerId: const MarkerId("marcador-cartorio"),
        position: const LatLng(-23.56483325943213, -46.65435843245621),
        infoWindow: const InfoWindow(title: "12° Cartório de Notas"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));

    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorCartorio);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  @override
  void initState() {
    super.initState();

    _carregarMarcadores();
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
            target: LatLng(-23.56331643290178, -46.652642650333135), zoom: 16),
        onMapCreated: _onMapCreated,
        markers: _marcadores,
      ),
    );
  }
}
