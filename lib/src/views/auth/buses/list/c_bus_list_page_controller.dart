import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/core/utils/dialog_service.dart';
import 'package:ybt_admin/src/models/m_bus_driver_model.dart';
import 'package:ybt_admin/src/models/m_bus_vehicle_model.dart';

class BusListPageController extends GetxController {
  bool xLoading = false;
  List<BusVehicleModel> allData = [];
  List<BusDriverModel> allDrivers = [];

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
      allData = await apiRepoController.getAllBuses();
      superPrint(allData);
      allDrivers = await apiRepoController.getAllBusDrivers();
    } catch (e) {
      superPrint(e);
    }
    xLoading = false;
    update();
  }

  Future<void> changeBusDriver(
      {required String busVehicleId, required String? busDriverId}) async {
    DialogService().showLoadingDialog();
    await apiRepoController.patchUpdateABus(
        busVehicleId: busVehicleId, driverId: busDriverId);
    DialogService().dismissDialog();
    await initLoad();
  }

  Future<void> proceedDeleteBus({required String busVehicleId}) async {
    DialogService().showLoadingDialog();
    await apiRepoController.deleteABus(busVehicleId: busVehicleId);
    DialogService().dismissDialog();
    await initLoad();
  }
}
