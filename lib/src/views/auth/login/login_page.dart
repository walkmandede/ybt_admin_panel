import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ybt_admin/config/constants/app_constants.dart';
import 'package:ybt_admin/config/constants/app_extensions.dart';
import 'package:ybt_admin/config/constants/app_functions.dart';
import 'package:ybt_admin/config/constants/app_svgs.dart';
import 'package:ybt_admin/config/constants/app_theme.dart';
import 'package:ybt_admin/config/route/route_names.dart';
import 'package:ybt_admin/core/api/api_repo.dart';
import 'package:ybt_admin/core/api/api_request_model.dart';
import 'package:ybt_admin/core/api/api_service.dart';
import 'package:ybt_admin/core/shared_preferances/sp_keys.dart';
import 'package:ybt_admin/core/utils/dialog_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ybt_admin/src/controllers/app_data_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  ValueNotifier<bool> xObsecuredPassword = ValueNotifier(false);
  ValueNotifier<bool> xRememberLogin = ValueNotifier(false);

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

  initLoad() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    txtEmail.text = sharedPreferences.getString(SpKeys.loginEmail) ?? "";
    txtPassword.text = sharedPreferences.getString(SpKeys.loginPassword) ?? "";

    if (txtEmail.text.isNotEmpty && txtPassword.text.isNotEmpty) {
      xRememberLogin.value = true;
    }
  }

  Future<void> proceedLogin() async {
    DialogService().showLoadingDialog(context: context);
    ApiRepoController apiRepoController = Get.find();
    AppDataController appDataController = Get.find();
    final response = await apiRepoController.postLogin(
        email: txtEmail.text, password: txtPassword.text);
    DialogService().dismissDialog(context: context);

    if (response.xSuccess) {
      if (xRememberLogin.value) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString(SpKeys.loginEmail, txtEmail.text);
        await sharedPreferences.setString(
            SpKeys.loginPassword, txtPassword.text);
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.remove(SpKeys.loginEmail);
        await sharedPreferences.remove(SpKeys.loginPassword);
      }
      //
      appDataController.apiToken =
          response.bodyData["data"]["token"].toString();
      Get.offAllNamed(RouteNames.dashboardPage);
    } else {
      DialogService()
          .showConfirmDialog(label: response.message, context: Get.context!);
    }
  }

  Future<void> proceedOnClickRegister() async {
    Get.toNamed(RouteNames.registerPage);
  }

  Future<void> toggleCheckBox({required bool value}) async {
    xRememberLogin.value = value;
  }

  Future<void> togglePasswordVisibility() async {
    xObsecuredPassword.value = !xObsecuredPassword.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.basePadding),
          child: Column(
            spacing: AppConstants.basePadding / 2,
            children: [
              const Spacer(),
              const Text(
                "Welcome to Yangon Bus Tracking System",
                style: TextStyle(fontSize: AppConstants.baseFontSizeXL),
              ),
              (20).heightBox(),
              SizedBox(
                height: AppConstants.baseButtonHeight,
                child: TextField(
                  controller: txtEmail,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: xObsecuredPassword,
                builder: (context, xObsecuredPassword, child) {
                  return SizedBox(
                    height: AppConstants.baseButtonHeight,
                    child: TextField(
                      controller: txtPassword,
                      obscureText: xObsecuredPassword,
                      decoration: InputDecoration(
                          labelText: "Password",
                          suffix: InkWell(
                            onTap: () {
                              togglePasswordVisibility();
                            },
                            child: AppFunctions.getSvgIcon(
                                svgData: xObsecuredPassword
                                    ? AppSvgs.showPassword
                                    : AppSvgs.hidePassword,
                                color: AppTheme.darkTheme.primaryColor,
                                size: const Size(25, 25)),
                          )),
                    ),
                  );
                },
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder(
                    valueListenable: xRememberLogin,
                    builder: (context, xRememberLogin, child) {
                      return Checkbox(
                        value: xRememberLogin,
                        onChanged: (value) => toggleCheckBox(value: value!),
                      );
                    },
                  ),
                  const Text("Remember Me?")
                ],
              ),
              SizedBox(
                  width: double.infinity,
                  height: AppConstants.baseButtonHeight,
                  child: OutlinedButton(
                      onPressed: () {
                        proceedLogin();
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          side: BorderSide(color: AppTheme.primary)),
                      child: Text(
                        "Log In Now",
                        style: TextStyle(
                            color: AppTheme.darkTheme.colorScheme.onPrimary),
                      ))),
              SizedBox(
                  width: double.infinity,
                  height: AppConstants.baseButtonHeight,
                  child: OutlinedButton(
                      onPressed: () {
                        proceedOnClickRegister();
                      },
                      child: Text(
                        "Register",
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
