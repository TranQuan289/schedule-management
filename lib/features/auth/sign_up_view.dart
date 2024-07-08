import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_management/common/widgets/text_button_widget.dart';
import 'package:schedule_management/common/widgets/text_form_field.dart';
import 'package:schedule_management/utils/color_utils.dart';
import 'package:schedule_management/utils/routes/routes.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

final TextEditingController emailController = TextEditingController();

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 20).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nice to know you!',
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
              TextFormFieldCustomWidget(
                hint: 'Your full name',
                label: "Full name",
                controller: emailController,
                inputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormFieldCustomWidget(
                hint: 'Your email address',
                label: "Email address",
                inputAction: TextInputAction.next,
                controller: emailController,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormFieldCustomWidget(
                hint: 'Your phone number',
                label: "Phone number",
                inputAction: TextInputAction.next,
                controller: emailController,
                textInputType: TextInputType.phone,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormFieldCustomWidget(
                hint: 'Your password',
                label: "Password",
                controller: emailController,
                inputAction: TextInputAction.done,
                obscureText: true,
                suffixIcon: IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.visibility),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              TextButtonWidget(
                label: 'Register',
                onPressed: () {},
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
                      "Or register with",
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
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have a account? ',
                      style: TextStyle(
                        color: ColorUtils.textColor,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Routes.goToSignInScreen(context),
                      child: Text(
                        'Login',
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
    );
  }
}
