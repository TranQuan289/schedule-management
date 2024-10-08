import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/common/widgets/loading_widget.dart';
import 'package:schedule_management/common/widgets/text_button_widget.dart';
import 'package:schedule_management/common/widgets/text_form_field.dart';
import 'package:schedule_management/model/user_model.dart';
import 'package:schedule_management/service/auth_service.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'package:schedule_management/utils/routes/routes.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _userService = AuthService();
  bool _isPasswordVisible = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      User user = User(
        id: "",
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
        dateOfBirth: DateTime.now().toString(),
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingWidget();
        },
      );
      try {
        final response = await _userService.registerUser(user);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['msg']),
        ));
        Routes.goToSignInScreen(context);
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Đăng ký thất bại'),
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
                  'Rất vui được biết bạn!',
                  style: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nhập tài khoản của bạn để tiếp tục',
                  style: TextStyle(
                    color: ColorUtils.textColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormFieldCustomWidget(
                  hint: 'Tên đầy đủ của bạn',
                  label: "Tên đầy đủ",
                  controller: _nameController,
                  inputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormFieldCustomWidget(
                  hint: 'Địa chỉ email của bạn',
                  label: "Địa chỉ email",
                  inputAction: TextInputAction.next,
                  controller: _emailController,
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormFieldCustomWidget(
                  hint: 'Số điện thoại của bạn',
                  label: "Số điện thoại",
                  inputAction: TextInputAction.next,
                  controller: _phoneController,
                  textInputType: TextInputType.phone,
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormFieldCustomWidget(
                  hint: 'Mật khẩu của bạn',
                  label: "Mật khẩu",
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
                  height: 20.h,
                ),
                TextButtonWidget(
                  label: 'Đăng ký',
                  onPressed: _register,
                ),
                SizedBox(
                  height: 10.h,
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
                        "Hoặc đăng ký bằng",
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
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn đã có tài khoản? ',
                        style: TextStyle(
                          color: ColorUtils.textColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Routes.goToSignInScreen(context),
                        child: Text(
                          'Đăng nhập',
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
