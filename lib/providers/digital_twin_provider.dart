import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/digital_twin_data.dart';
import '../models/disease_result.dart';
import '../models/field_state.dart';
import '../models/sensor_data.dart';
import '../service/digital_twin_service.dart';
import '../service/disease_service.dart';

class DigitalTwinProvider extends ChangeNotifier {
 final _digitalTwinService=DigitalTwinService(); final _diseaseService=DiseaseService(); Timer? _timer;
 bool backendConnected=false,isLoading=false,analyzingImage=false; String? backendError,diseaseError; DigitalTwinData? digitalTwinData; SensorData? currentSensorData; final List<SensorData> history=[]; DiseaseResult diseaseResult=DiseaseResult.empty(); FieldState fieldState=FieldState.offline();
 Future<void> initialize() async {await fetchDigitalTwinData();_timer?.cancel();_timer=Timer.periodic(const Duration(seconds:5),(_)=>fetchDigitalTwinData());}
 Future<void> fetchDigitalTwinData() async {try{final d=await _digitalTwinService.getDigitalTwinData();backendConnected=true;backendError=null;digitalTwinData=d;currentSensorData=d.sensorData;if(d.sensorData!=null&&(history.isEmpty||history.last.timestamp!=d.sensorData!.timestamp)){history.add(d.sensorData!);if(history.length>100)history.removeAt(0);}if(d.latestDiagnosis!=null)diseaseResult=d.latestDiagnosis!;_updateFieldState();notifyListeners();}catch(e){backendConnected=false;backendError='Cannot connect to RiceTwin backend.';digitalTwinData=null;currentSensorData=null;fieldState=FieldState.offline();diseaseResult=DiseaseResult.empty();notifyListeners();}}
 void _updateFieldState(){if(!backendConnected||currentSensorData==null){fieldState=FieldState.offline();return;}final r=environmentalRisk;if(r>=70)fieldState=FieldState(status:FieldHealthStatus.critical,message:recommendationMessage,environmentalRisk:r);else if(r>=35)fieldState=FieldState(status:FieldHealthStatus.warning,message:recommendationMessage,environmentalRisk:r);else fieldState=FieldState(status:FieldHealthStatus.healthy,message:recommendationMessage,environmentalRisk:r);}
 double get environmentalRisk=>digitalTwinData?.riskState?.environmentalRisk??0; double get diseaseRisk=>digitalTwinData?.riskState?.diseaseRisk??0; double get overallRisk=>digitalTwinData?.riskState?.combinedRisk??0; double get combinedRisk=>overallRisk;
 DiseaseResult? get automaticDiagnosis=>backendConnected?digitalTwinData?.latestDiagnosis:null; String? get latestCameraImage=>backendConnected?digitalTwinData?.latestImage:null; String? get latestImage=>latestCameraImage; DateTime? get lastSensorUpdate=>digitalTwinData?.lastSensorUpdate; DateTime? get lastCameraCapture=>digitalTwinData?.lastCameraCapture;
 String get synchronizationStatus=>backendConnected?(digitalTwinData?.synchronizationStatus??'DELAYED'):'OFFLINE'; CropState? get cropState=>digitalTwinData?.cropState; PredictionState? get predictionState=>digitalTwinData?.predictionState; Recommendation? get recommendation=>digitalTwinData?.recommendation; ActuatorState? get actuatorState=>digitalTwinData?.actuatorState; String get recommendationMessage=>recommendation?.message??(backendConnected?'Waiting for recommendation.':'Backend is offline. No live field data available.');
 Future<void> analyzeDisease({required Uint8List imageBytes,required String fileName}) async {if(!backendConnected){diseaseError='Backend is offline.';notifyListeners();return;}analyzingImage=true;diseaseError=null;notifyListeners();try{diseaseResult=await _diseaseService.predictDisease(imageBytes:imageBytes,fileName:fileName);}catch(e){diseaseError=e.toString();}finally{analyzingImage=false;notifyListeners();}}
 Future<void> simulateSensorUpdate() async {if(!backendConnected)return;await _digitalTwinService.simulateSensorUpdate();await fetchDigitalTwinData();}
 Future<void> simulateCameraCapture() async {if(!backendConnected)return;analyzingImage=true;notifyListeners();try{await _digitalTwinService.simulateCameraCapture();await fetchDigitalTwinData();}catch(e){diseaseError=e.toString();}finally{analyzingImage=false;notifyListeners();}}
 Future<void> setPump(bool on) async {if(!backendConnected)return;await _digitalTwinService.setPump(on);await fetchDigitalTwinData();}
 Future<void> refresh()=>fetchDigitalTwinData(); void clearHistory(){history.clear();notifyListeners();} void clearDiseaseResult(){diseaseResult=DiseaseResult.empty();diseaseError=null;notifyListeners();}
 @override void dispose(){_timer?.cancel();super.dispose();}
}
