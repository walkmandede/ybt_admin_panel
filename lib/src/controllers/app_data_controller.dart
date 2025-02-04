import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ybt_admin/src/models/m_bus_line_model.dart';
import 'package:ybt_admin/src/models/m_bus_stop_model.dart';

class AppDataController extends GetxController {
  //variables
  String apiToken = "";
  ValueNotifier<List<BusStopModel>> allBusStops = ValueNotifier([]);
  ValueNotifier<BusLineModel> myBusLine =
      ValueNotifier(BusLineModel.getInstance());

  //functions
  BusStopModel? getBusStopModelById({required String id}) {
    for (final each in allBusStops.value) {
      if (each.id == id) {
        return each;
      }
    }
    return null;
  }
}
