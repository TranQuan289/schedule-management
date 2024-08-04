import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:schedule_management/common/widgets/text_button_widget.dart';
import 'package:schedule_management/common/widgets/text_form_field.dart';
import 'package:schedule_management/service/auth_service.dart';
import 'package:schedule_management/utils/color_utils.dart';

class ProfileDetailView extends HookWidget {
  final String userId;

  const ProfileDetailView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final dobController = useTextEditingController();

    final isLoading = useState(false);
    final authService = useMemoized(() => AuthService());

    useEffect(() {
      _fetchUserData(authService, userId, nameController, phoneController,
          emailController, dobController, isLoading);
      return null;
    }, []);

    void _updateUser() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;

        var userData = {
          "name": nameController.text,
          "phone": phoneController.text,
          "email": emailController.text,
          "date_of_birth": dobController.text,
        };

        try {
          var updatedUser = await authService.updateUser(userId, userData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(updatedUser['msg'])),
          );
          Navigator.pop(context, true);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật người dùng thất bại')),
          );
        } finally {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ tài khoản'),
        backgroundColor: ColorUtils.primaryBackgroundColor,
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormFieldCustomWidget(
                      label: 'Tên',
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên của bạn';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormFieldCustomWidget(
                      label: 'Số điện thoại',
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số điện thoại của bạn';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormFieldCustomWidget(
                      label: 'Email',
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa chỉ email của bạn';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormFieldCustomWidget(
                      label: 'Ngày sinh',
                      controller: dobController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập ngày sinh của bạn';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    TextButtonWidget(
                      label: 'Cập nhật',
                      onPressed: _updateUser,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _fetchUserData(
    AuthService authService,
    String userId,
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController emailController,
    TextEditingController dobController,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    try {
      var userData = await authService.fetchUserDetails(userId);
      nameController.text = userData['name'];
      phoneController.text = userData['phone'];
      emailController.text = userData['email'];
      dobController.text = userData['date_of_birth'] != null
          ? DateTime.parse(userData['date_of_birth'])
              .toLocal()
              .toString()
              .split(' ')[0]
          : '';
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
