import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/core/utils/dialog_service.dart';
import 'package:ybt_admin/src/models/m_bus_driver_model.dart';
import 'package:ybt_admin/src/models/m_bus_vehicle_model.dart';

class DriverListPageController extends GetxController {
  bool xLoading = false;
  List<BusDriverModel> allData = [];
  ApiRepoController apiRepoController = Get.find();

  @override
  void onInit() {
    initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  initLoad() async {
    xLoading = true;
    update();
    try {
      allData = await apiRepoController.getAllBusDrivers();
    } catch (e) {
      superPrint(e);
    }
    xLoading = false;
    update();
  }
}
