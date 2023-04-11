import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _posicaoCamera =
      const CameraPosition(target: LatLng(-23.563645, -46.653642), zoom: 16);

  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _carregarMarcadores() {
    /*Set<Marker> marcadoresLocal = {};

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
    });*/

    /*Set<Polygon> listaPolygons = {};
    Polygon polygon1 = const Polygon(
        polygonId: PolygonId("polygon1"),
        // fillColor: Colors.green,
        fillColor: Colors.green,
        strokeColor: Colors.red,
        strokeWidth: 10,
          points: [
            LatLng(-23.557169370910877, -46.65714611623797),
            LatLng(-23.559276783356392, -46.65863785067438),
            LatLng(-23.560724604381264, -46.65689456886243),
            LatLng(-23.558933593811584, -46.654654042238334)
          ],
        // ignore: avoid_print
        consumeTapEvents: true,
        zIndex: 0);
    listaPolygons.add(polygon1);

    setState(() {
      _polygons = listaPolygons;
    });

    Polygon polygon2 = const Polygon(
        polygonId: PolygonId("polygon2"),
        // fillColor: Colors.green,
        fillColor: Colors.purple,
        strokeColor: Colors.orange,
        strokeWidth: 10,
        points: [
          LatLng(-23.55804344175226, -46.65582987997056),
          LatLng(-23.558874608018304, -46.656315424904754),
          LatLng(-23.559282145685923, -46.6546423423604)
        ],
        // ignore: avoid_print
        consumeTapEvents: true,
        zIndex: 1);
    listaPolygons.add(polygon1);
    listaPolygons.add(polygon2);

    setState(() {
      _polygons = listaPolygons;
    });*/

    Set<Polyline> listaPolylines = {};

    Polyline polyline = Polyline(
        polylineId: const PolylineId("polyline"),
        color: Colors.red,
        width: 10,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        points: const [
          LatLng(-23.563645, -46.653642),
          LatLng(-23.566064, -46.650778),
          LatLng(-23.563232, -46.648020)
        ],
        consumeTapEvents: true,
        onTap: () {
          // ignore: avoid_print
          print("clicado na linha ");
        });

    listaPolylines.add(polyline);

    setState(() {
      _polylines = listaPolylines;
    });
  }

  // _recuperarLocalizacaoAtual() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // ignore: avoid_print
  //     print("Location services are disabled.");
  //   }

  //   permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // ignore: avoid_print
  //       print("Location permissions are denied");
  //     }
  //   }

  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     _posicaoCamera = CameraPosition(
  //         target: LatLng(position.latitude, position.longitude), zoom: 17);
  //     _movimentarCamera();
  //   });

  //   // ignore: avoid_print
  //   //print("localização atual: ${position.toString()}");
  // }

  _adicionarListenerLocalizacao() {
    var locationOptions = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator.getPositionStream(locationSettings: locationOptions)
        .listen((Position position) {
      // ignore: avoid_print
      print("localização atual: ${position.toString()}");

      Marker marcadorUsuario = Marker(
          markerId: const MarkerId("marcador-usuario"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: "Meu local"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta));

      setState(() {
        _marcadores.add(marcadorUsuario);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 17);
        _movimentarCamera();
      });
    });
  }

  _recuperarLocalParaEndereco() async {
    List<Location> listaEnderecos =
        await locationFromAddress("Av. Paulista, 1372");

    // ignore: avoid_print
    print("total: ${listaEnderecos.length}");

    // ignore: unnecessary_null_comparison, prefer_is_empty
    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Location endereco = listaEnderecos[0];

      // Placemark enderecoPlacemark =
      //     await placemarkFromCoordinates(endereco.latitude, endereco.longitude)
      //         as Placemark;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(endereco.latitude, endereco.longitude);

      Placemark enderecoPlacemark = placemarks.first;

      String resultado = "";

      resultado =
          "\n administrativeArea ${enderecoPlacemark.administrativeArea}";
      resultado +=
          "\n subAdministrativeArea ${enderecoPlacemark.subAdministrativeArea}";
      resultado += "\n locality ${enderecoPlacemark.locality}";
      resultado += "\n subLocality ${enderecoPlacemark.subLocality}";
      resultado += "\n thoroughfare ${enderecoPlacemark.thoroughfare}";
      resultado += "\n subThoroughfare ${enderecoPlacemark.subThoroughfare}";
      resultado += "\n postalCode ${enderecoPlacemark.postalCode}";
      resultado += "\n country ${enderecoPlacemark.country}";
      resultado += "\n isoCountryCode ${enderecoPlacemark.isoCountryCode}";

      // ignore: avoid_print
      print("resultado: $resultado");
      //-23.565564, -46.652753
    }
  }

  _recuperarLocalParaLatLong() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(-23.565564, -46.652753);

    // ignore: unnecessary_null_comparison, prefer_is_empty
    if (placemarks != null && placemarks.length > 0) {
      Placemark enderecoPlacemark = placemarks.first;

      String resultado = "";

      resultado =
          "\n administrativeArea ${enderecoPlacemark.administrativeArea}";
      resultado +=
          "\n subAdministrativeArea ${enderecoPlacemark.subAdministrativeArea}";
      resultado += "\n locality ${enderecoPlacemark.locality}";
      resultado += "\n subLocality ${enderecoPlacemark.subLocality}";
      resultado += "\n thoroughfare ${enderecoPlacemark.thoroughfare}";
      resultado += "\n subThoroughfare ${enderecoPlacemark.subThoroughfare}";
      resultado += "\n postalCode ${enderecoPlacemark.postalCode}";
      resultado += "\n country ${enderecoPlacemark.country}";
      resultado += "\n isoCountryCode ${enderecoPlacemark.isoCountryCode}";

      // ignore: avoid_print
      print("resultado: $resultado");
      //-23.565564, -46.652753
    }
  }

  @override
  void initState() {
    super.initState();

    // _carregarMarcadores();
    //_recuperarLocalizacaoAtual();
    // _adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    _recuperarLocalParaLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapas e geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        // ignore: sort_child_properties_last
        child: const Icon(Icons.done),
        onPressed: _movimentarCamera,
      ),
      // ignore: avoid_unnecessary_containers
      body: GoogleMap(
        // mapType: MapType.normal,
        mapType: MapType.normal,
        initialCameraPosition: _posicaoCamera,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: _marcadores,
        //polygons: _polygons,
        //polylines: _polylines,
      ),
    );
  }
}
