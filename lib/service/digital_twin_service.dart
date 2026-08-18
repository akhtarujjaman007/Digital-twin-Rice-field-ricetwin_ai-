import 'dart:convert'; import 'package:http/http.dart' as http; import '../models/digital_twin_data.dart'; import 'api_service.dart';
class DigitalTwinService {
 Future<DigitalTwinData> getDigitalTwinData() async {final r=await http.get(Uri.parse(ApiService.digitalTwin)).timeout(const Duration(seconds:5));if(r.statusCode!=200)throw Exception('Backend returned ${r.statusCode}');return DigitalTwinData.fromJson(jsonDecode(r.body));}
 Future<void> simulateCameraCapture() async {final r=await http.post(Uri.parse(ApiService.simulateCameraCapture)).timeout(const Duration(seconds:60));if(r.statusCode!=200)throw Exception(r.body);}
 Future<void> simulateSensorUpdate() async {final r=await http.post(Uri.parse(ApiService.simulateSensorUpdate)).timeout(const Duration(seconds:10));if(r.statusCode!=200)throw Exception(r.body);}
 Future<void> setPump(bool on) async {final r=await http.post(Uri.parse(ApiService.pump(on?'ON':'OFF'))).timeout(const Duration(seconds:10));if(r.statusCode!=200)throw Exception(r.body);}
}
