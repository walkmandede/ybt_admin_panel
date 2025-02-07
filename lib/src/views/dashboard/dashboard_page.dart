import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/config/constants/app_svgs.dart';
import 'package:ybt_admin/config/route/route_names.dart';
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
        apiRepoController.postUpdateMe(),
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
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...[
              [
                AppSvgs.routeIcon,
                "Routes",
                () {
                  Get.toNamed(RouteNames.routePgae);
                }
              ],
              [
                AppSvgs.busIcon,
                "Buses",
                () {
                  Get.toNamed(RouteNames.busListPage);
                }
              ],
              [
                AppSvgs.driverIcon,
                "Drivers",
                () {
                  Get.toNamed(RouteNames.driverListPage);
                }
              ],
              [
                AppSvgs.logout,
                "LogOut",
                () {
                  Get.offAllNamed(RouteNames.loginPage);
                }
              ],
            ].map((each) {
              String svgIcon = each[0].toString();
              String label = each[1].toString();
              Function() function = each[2] as Function();
              return ListTile(
                onTap: () {
                  function();
                },
                leading: AppFunctions.getSvgIcon(
                    svgData: svgIcon,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text(
                  label,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              );
            })
          ],
        ),
      ),
      // endDrawer: const DashboardDrawer(),
    );
  }
}
