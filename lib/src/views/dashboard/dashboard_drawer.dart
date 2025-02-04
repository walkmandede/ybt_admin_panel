import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/config/constants/app_svgs.dart';
import 'package:ybt_admin/config/constants/app_theme.dart';
import 'package:ybt_admin/config/route/route_names.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width * 0.25,
        height: Get.height,
        child: LayoutBuilder(
          builder: (a1, c1) {
            return Card(
              margin: EdgeInsets.only(
                  top: c1.maxWidth * 0.05,
                  bottom: c1.maxWidth * 0.05,
                  right: c1.maxWidth * 0.05),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: c1.maxWidth * 0.05,
                    vertical: c1.maxWidth * 0.05),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...[
                        [
                          AppSvgs.routeIcon,
                          "Routes",
                          () {
                            Get.toNamed(RouteNames.busListPage);
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
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
