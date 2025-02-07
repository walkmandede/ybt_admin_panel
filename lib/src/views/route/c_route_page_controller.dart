import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/core/utils/dialog_service.dart';
import 'package:ybt_admin/src/controllers/app_data_controller.dart';
import 'package:ybt_admin/src/models/m_bus_stop_model.dart';

class RoutePageController extends GetxController {
  bool xLoading = false;
  ApiRepoController apiRepoController = Get.find();
  AppDataController appDataController = Get.find();
  MapController mapController = MapController();
  bool xShowOnlyMyStops = true;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> initLoad() async {
    await apiRepoController.getUpdateBusStops();
  }

  Future<void> updateRoute() async {
    DialogService().showLoadingDialog();
    final response = await apiRepoController.patchUpdateBusLineBusStops(
        stops: appDataController.myBusLine.value.busStopIds
            .map((each) => appDataController.getBusStopModelById(id: each)!)
            .toList());
    DialogService().dismissDialog();
    DialogService().showConfirmDialog(label: response.message);
  }
}
