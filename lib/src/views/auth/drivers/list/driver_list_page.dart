import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/config/route/route_names.dart';
import 'package:ybt_admin/src/views/auth/buses/list/c_bus_list_page_controller.dart';
import 'package:ybt_admin/src/views/auth/drivers/list/c_drier_list_controller.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  State<DriverListPage> createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  late DriverListPageController driverListPageController;

  @override
  void initState() {
    driverListPageController = Get.put(DriverListPageController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<DriverListPageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Drivers"),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              driverListPageController.initLoad();
            },
            label: const Text("Refresh"),
            icon: const Icon(Icons.refresh_rounded),
          ),
          TextButton.icon(
            onPressed: () {
              Get.toNamed(RouteNames.createADriverPage);
            },
            label: const Text("Add new driver"),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.basePadding,
              vertical: AppConstants.basePadding),
          child: GetBuilder<DriverListPageController>(
            builder: (controller) {
              if (controller.xLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                if (controller.allData.isEmpty) {
                  return const Center(
                    child: Text("No drivers yet!"),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columns: [
                          "Name",
                          "Phone",
                        ].map((each) {
                          return DataColumn(label: Text(each));
                        }).toList(),
                        rows: controller.allData.map((each) {
                          return DataRow(cells: [
                            DataCell(Text(each.name)),
                            DataCell(Text(each.phone)),
                          ]);
                        }).toList()),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
