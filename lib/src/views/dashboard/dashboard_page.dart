import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/src/controllers/app_data_controller.dart';
import 'package:ybt_admin/src/views/dashboard/dashboard_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ValueNotifier<bool> xLoading = ValueNotifier(false);

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> initLoad() async {
    xLoading.value = true;
    ApiRepoController apiRepoController = Get.find();
    AppDataController appDataController = Get.find();

    try {
      superPrint(appDataController.apiToken);
      await Future.value([
        apiRepoController.getUpdateBusStops(),
        apiRepoController.postUpateMe(),
      ]);
    } catch (e) {
      superPrint(e, title: "Dashboard Init Load");
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDataController appDataController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: appDataController.myBusLine,
          builder: (context, myBusLine, child) {
            return Text("Yangon Bus Tracking System ( ${myBusLine.name} )");
          },
        ),
        centerTitle: false,
      ),
      endDrawer: const DashboardDrawer(),
    );
  }
}
