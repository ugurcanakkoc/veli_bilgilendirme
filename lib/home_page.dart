import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:veli_bilgilendirme_yeni/camera_service.dart';
import 'package:veli_bilgilendirme_yeni/database_service.dart';
import 'package:veli_bilgilendirme_yeni/standart_widget.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position? _currentPosition;
  String? _userName;
  String? _userClass;

  final Map<String, double> _officeLocation = {
    "latitude":
        0, //google maps üzerinden istenilen konumun kordinatları giriliyor
    "longitude":
        0, //google maps üzerinden istenilen konumun kordinatları giriliyor
  };

  bool _isWithinOfficeArea = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _fetchProfileName();
  }

  Future<void> _fetchProfileName() async {
    String? userName = await Database.getUser('name');
    if (userName != null) {
      setState(() {
        _userName = userName;
      });
    }
    String? userClass = await Database.getUser("class");

    if (userClass != null) {
      setState(() {
        _userClass = userClass;
      });
    }
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _isWithinOfficeArea = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              _officeLocation["latitude"]!,
              _officeLocation["longitude"]!) <
          50; // belirlenen metre yarıçapında bir alan oluşturur
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: StandartWidget(
                child: Text("LOGO"),
              )),
              Expanded(
                  flex: 3,
                  child: StandartWidget(
                    child: Column(
                      children: [
                        Divider(),
                        Text(
                          "ÖĞRENCİ ADI: " + _userName.toString(),
                          style: standartTextLat,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("ÖĞRENCİ SINIFI: " + _userClass.toString(),
                            style: standartTextLat),
                        Expanded(flex: 1, child: Container()),
                        ElevatedButton(
                          child: Text(_isWithinOfficeArea
                              ? "Öğrenci çağırma"
                              : "Alan dışındasınız"),
                          onPressed: _isWithinOfficeArea
                              ? () {
                                  CameraService();
                                }
                              : null,
                        ),
                        Divider()
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
