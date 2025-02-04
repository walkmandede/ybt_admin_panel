import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/config/route/route_names.dart';
import 'package:ybt_admin/src/views/auth/buses/create/bus_create_page.dart';
import 'package:ybt_admin/src/views/auth/buses/list/c_bus_list_page_controller.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({super.key});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  late BusListPageController busLisPageController;

  @override
  void initState() {
    busLisPageController = Get.put(BusListPageController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BusListPageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Buses"),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              busLisPageController.initLoad();
            },
            label: const Text("Refresh"),
            icon: const Icon(Icons.refresh_rounded),
          ),
          TextButton.icon(
            onPressed: () {
              Get.toNamed(RouteNames.createABusPage);
            },
            label: const Text("Add new bus"),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.basePadding,
              vertical: AppConstants.basePadding),
          child: GetBuilder<BusListPageController>(
            builder: (controller) {
              if (controller.xLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                if (controller.allData.isEmpty) {
                  return const Center(
                    child: Text("No buses yet!"),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columns: [
                          "Service Status",
                          "Reg No",
                          "Driver",
                          "Location",
                          "Last Updated At",
                          "Actions"
                        ].map((each) {
                          return DataColumn(label: Text(each));
                        }).toList(),
                        rows: controller.allData.map((each) {
                          return DataRow(cells: [
                            DataCell(Text(each.enumBusServiceStatus.label)),
                            DataCell(Text(each.regNo)),
                            DataCell(DropdownButton(
                              onChanged: (value) {
                                controller.changeBusDriver(
                                    busVehicleId: each.id, busDriverId: value);
                              },
                              value: each.driverId,
                              hint: const Text("Select driver"),
                              items: [
                                ...controller.allDrivers.map((each) {
                                  return DropdownMenuItem(
                                    value: each.id,
                                    child: Text(each.name),
                                  );
                                }).toList()
                              ],
                            )),
                            DataCell(Text(
                                AppFunctions.convertLatLng2InstanceToString(
                                    latLng2Instance: each.location))),
                            DataCell(Text(each.lastLocationUpdatedAt)),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      controller.proceedDeleteBus(
                                          busVehicleId: each.id);
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ))
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
