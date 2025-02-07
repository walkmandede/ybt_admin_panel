import 'package:flutter/material.dart';
import 'package:ybt_admin/src/views/auth/buses/create/bus_create_page.dart';
import 'package:ybt_admin/src/views/auth/buses/list/bus_list_page.dart';
import 'package:ybt_admin/src/views/auth/drivers/create/driver_create_page.dart';
import 'package:ybt_admin/src/views/auth/drivers/list/driver_list_page.dart';
import 'package:ybt_admin/src/views/auth/login/login_page.dart';
import 'package:ybt_admin/src/views/auth/register/register_page.dart';
import 'package:ybt_admin/src/views/dashboard/dashboard_page.dart';
import 'package:ybt_admin/src/views/route/route_page.dart';
import 'route_names.dart';

class RouteUtils {
  final routes = {
    RouteNames.loginPage: (context) {
      return const LoginPage();
    },
    RouteNames.registerPage: (context) {
      return const RegisterPage();
    },
    RouteNames.dashboardPage: (context) {
      return const DashboardPage();
    },
    RouteNames.createABusPage: (context) {
      return const BusCreatePage();
    },
    RouteNames.busListPage: (context) {
      return const BusListPage();
    },
    RouteNames.createADriverPage: (context) {
      return const DriverCreatePage();
    },
    RouteNames.driverListPage: (context) {
      return const DriverListPage();
    },
    RouteNames.routePgae: (context) {
      return const RoutePage();
    },
  };
}
