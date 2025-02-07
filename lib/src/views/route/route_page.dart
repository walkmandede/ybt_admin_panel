import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/src/models/m_bus_line_model.dart';
import 'package:ybt_admin/src/views/route/c_route_page_controller.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late RoutePageController routePageController;

  @override
  void initState() {
    routePageController = Get.put(RoutePageController());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route"),
        centerTitle: false,
        actions: [
          TextButton.icon(
              onPressed: () {
                routePageController.updateRoute();
              },
              icon: const Icon(Icons.save),
              label: const Text("Save")),
        ],
      ),
      body: SizedBox.expand(
        child: GetBuilder<RoutePageController>(
          builder: (controller) {
            return ValueListenableBuilder(
              valueListenable: controller.appDataController.myBusLine,
              builder: (context, myBusLine, child) {
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          mapWidget(),
                          Align(
                            alignment: Alignment.topRight,
                            child: mapController(),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: busStopWidget(),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget mapController() {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.basePadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("All Stops"),
            Switch(
                value: routePageController.xShowOnlyMyStops,
                activeColor: Theme.of(context).primaryColor,
                activeTrackColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.5),
                onChanged: (value) {
                  routePageController.xShowOnlyMyStops = value;
                  routePageController.update();
                }),
            const Text("Only My Stops"),
          ],
        ),
      ),
    );
  }

  Widget mapWidget() {
    final busLine = routePageController.appDataController.myBusLine.value;

    return FlutterMap(
      mapController: routePageController.mapController,
      options: const MapOptions(
          initialZoom: 12,
          initialCenter: LatLng(16.775545012652657, 96.1670323640905)),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.kphkph.ybtadmin',
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 45,
            size: const Size(100, 40),
            markers: routePageController.appDataController.allBusStops.value
                .where((eachStop) {
              if (routePageController.xShowOnlyMyStops) {
                return busLine.busStopIds.contains(eachStop.id);
              } else {
                return true;
              }
            }).map((eachStop) {
              bool xContained = busLine.busStopIds.contains(eachStop.id);
              return Marker(
                  width: Get.width * 0.09,
                  height: Get.width * 0.03,
                  point: eachStop.location,
                  child: InkWell(
                    onTap: () {
                      if (xContained) {
                        routePageController
                            .appDataController.myBusLine.value.busStopIds
                            .remove(eachStop.id);
                      } else {
                        routePageController
                            .appDataController.myBusLine.value.busStopIds
                            .add(eachStop.id);
                      }
                      routePageController.update();
                    },
                    child: Card(
                      elevation: 0,
                      color: !xContained
                          ? Theme.of(context).cardColor.withValues(alpha: 0.8)
                          : Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.8),
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.005),
                        child: FittedBox(
                          child: Text(
                            eachStop.stopNameEn,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ));
            }).toList(),
            polygonOptions: PolygonOptions(
              borderColor: Theme.of(context).primaryColor,
              color: Theme.of(context).primaryColor.withAlpha(100),
              borderStrokeWidth: 2,
            ),
            builder: (context, markers) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).cardColor.withValues(alpha: 0.8),
                ),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget busStopWidget() {
    final busLine = routePageController.appDataController.myBusLine.value;
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (a1, c1) {
          return Padding(
            padding: EdgeInsets.all(min(c1.maxHeight, c1.maxWidth) * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bus stops - Total ${busLine.busStopIds.length}",
                  style: const TextStyle(fontSize: AppConstants.baseFontSizeXL),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: busLine.busStopIds.length,
                    itemBuilder: (context, index) {
                      final eachBusStopId = busLine.busStopIds[index];
                      final eachBusStop = routePageController.appDataController
                          .getBusStopModelById(id: eachBusStopId);
                      if (eachBusStop == null) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        leading: Text("${index + 1}."),
                        title: Text(eachBusStop.stopNameEn),
                        subtitle: Text(eachBusStop.roadNameEn),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
