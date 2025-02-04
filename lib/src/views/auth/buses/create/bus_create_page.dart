import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_theme.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/core/utils/dialog_service.dart';
import 'package:ybt_admin/src/views/auth/buses/list/c_bus_list_page_controller.dart';

class BusCreatePage extends StatefulWidget {
  const BusCreatePage({super.key});

  @override
  State<BusCreatePage> createState() => _BusCreatePageState();
}

class _BusCreatePageState extends State<BusCreatePage> {
  TextEditingController txtRegisterNumber = TextEditingController(text: "");

  Future<void> proceedCreate() async {
    DialogService().showLoadingDialog(context: context);
    ApiRepoController apiRepoController = Get.find();
    final result =
        await apiRepoController.postCreateABus(regNo: txtRegisterNumber.text);
    DialogService().dismissDialog();
    if (result.xSuccess) {
      DialogService().showConfirmDialog(label: "Successfully created a bus!");
      txtRegisterNumber.clear();
      BusListPageController busListPageController = Get.find();
      busListPageController.initLoad();
    } else {
      DialogService().showConfirmDialog(label: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create A Bus"),
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
                  controller: txtRegisterNumber,
                  decoration:
                      const InputDecoration(labelText: "Bus Register Number"),
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
