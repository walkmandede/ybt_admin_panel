import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_theme.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/core/utils/dialog_service.dart';
import 'package:ybt_admin/src/views/auth/buses/list/c_bus_list_page_controller.dart';
import 'package:ybt_admin/src/views/auth/drivers/list/c_drier_list_controller.dart';

class DriverCreatePage extends StatefulWidget {
  const DriverCreatePage({super.key});

  @override
  State<DriverCreatePage> createState() => _DriverCreatePageState();
}

class _DriverCreatePageState extends State<DriverCreatePage> {
  TextEditingController txtName = TextEditingController(text: "");
  TextEditingController txtPhone = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");

  Future<void> proceedCreate() async {
    if (txtPassword.text.length < 6) {
      DialogService()
          .showConfirmDialog(label: "Passwords must be at least 6 characters.");
      return;
    }
    DialogService().showLoadingDialog(context: context);
    ApiRepoController apiRepoController = Get.find();
    final result = await apiRepoController.postCreateABusDriver(
        name: txtName.text, phone: txtPhone.text, password: txtPassword.text);
    DialogService().dismissDialog();
    if (result.xSuccess) {
      DialogService()
          .showConfirmDialog(label: "Successfully created a bus driver!");
      txtName.clear();
      txtPhone.clear();
      txtPassword.clear();
      DriverListPageController driverListPageController = Get.find();
      driverListPageController.initLoad();
    } else {
      DialogService().showConfirmDialog(label: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create A Driver"),
        centerTitle: false,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.basePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppConstants.basePadding / 2,
            children: [
              const Spacer(),
              SizedBox(
                height: AppConstants.baseButtonHeight,
                child: TextField(
                  controller: txtName,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
              ),
              SizedBox(
                height: AppConstants.baseButtonHeight,
                child: TextField(
                  controller: txtPhone,
                  decoration: const InputDecoration(labelText: "Phone"),
                ),
              ),
              SizedBox(
                height: AppConstants.baseButtonHeight,
                child: TextField(
                  controller: txtPassword,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  height: AppConstants.baseButtonHeight,
                  child: OutlinedButton(
                      onPressed: () {
                        proceedCreate();
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          side: BorderSide(color: AppTheme.primary)),
                      child: Text(
                        "Create A Bus",
                        style: TextStyle(
                            color: AppTheme.darkTheme.colorScheme.onPrimary),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
