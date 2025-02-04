import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_theme.dart';
import 'package:ybt_admin/config/route/route_names.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/core/utils/dialog_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtName = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  TextEditingController txtConfirmPassword = TextEditingController(text: "");

  Future<void> proceedRegister() async {
    if (txtPassword.text != txtConfirmPassword.text) {
      DialogService()
          .showConfirmDialog(context: context, label: "Passwords do not match");
    } else {
      DialogService().showLoadingDialog(context: context);
      ApiRepoController apiRepoController = Get.find();
      final response = await apiRepoController.postRegister(
          email: txtEmail.text, password: txtPassword.text, name: txtName.text);
      DialogService().dismissDialog(context: context);

      if (response.xSuccess) {
        Get.offAllNamed(RouteNames.loginPage);
        DialogService().showConfirmDialog(
            label: "Successfully Registered", context: Get.context!);
      } else {
        DialogService()
            .showConfirmDialog(label: response.message, context: Get.context!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Now"),
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
                  decoration: const InputDecoration(labelText: "Bus Line Name"),
                ),
              ),
              SizedBox(
                height: AppConstants.baseButtonHeight,
                child: TextField(
                  controller: txtEmail,
                  decoration: const InputDecoration(labelText: "Email"),
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
                height: AppConstants.baseButtonHeight,
                child: TextField(
                  controller: txtConfirmPassword,
                  decoration:
                      const InputDecoration(labelText: "Confirm Password"),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  height: AppConstants.baseButtonHeight,
                  child: OutlinedButton(
                      onPressed: () {
                        proceedRegister();
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          side: BorderSide(color: AppTheme.primary)),
                      child: Text(
                        "Register Now",
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
