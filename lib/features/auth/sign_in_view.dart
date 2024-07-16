import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/common/widgets/loading_widget.dart';
import 'package:schedule_management/common/widgets/text_button_widget.dart';
import 'package:schedule_management/common/widgets/text_form_field.dart';
import 'package:schedule_management/service/auth_service.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'package:schedule_management/utils/routes/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final AuthService _authService = AuthService();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingWidget();
        },
      );

      try {
        final response = await _authService.loginUser(email, password);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['msg']),
        ));
        Routes.goToBottomNavigatorScreen(context);
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to login user'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 20).r,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Schedule Management',
                  style: TextStyle(
                      color: ColorUtils.primaryColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Enter your account to continue',
                  style: TextStyle(
                    color: ColorUtils.textColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormFieldCustomWidget(
                  hint: 'Your email address',
                  label: "Email address",
                  inputAction: TextInputAction.next,
                  controller: _emailController,
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormFieldCustomWidget(
                  hint: 'Your password',
                  label: "Password",
                  controller: _passwordController,
                  inputAction: TextInputAction.done,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                TextButtonWidget(
                  label: 'Login',
                  onPressed: _login,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ColorUtils.textColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        "Or login with",
                        style: TextStyle(
                          color: ColorUtils.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: ColorUtils.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t you have an account? ',
                        style: TextStyle(
                          color: ColorUtils.textColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Routes.goToSignUpScreen(context),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: ColorUtils.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
