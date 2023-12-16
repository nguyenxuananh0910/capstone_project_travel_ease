import 'package:capstone_project_travel_ease/core/constrants/Constant.dart';
import 'package:capstone_project_travel_ease/src/domain/models/user_model.dart';
import 'package:capstone_project_travel_ease/src/domain/services/user_service.dart';
import 'package:capstone_project_travel_ease/src/presentation/controller/checklogin_controller.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/notification/notification_page.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_user/login/login_page.dart';
import 'package:capstone_project_travel_ease/src/presentation/widgets/dia_log/dialog_notification.dart';
import 'package:get/get.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

class HomeController extends GetxController {
  final UserService _userService = Get.find(tag: Constant.uerSerServiceTAG);
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxList<String> listImage = <String>[].obs;
  final RxBool isLoading = false.obs;
  int userId = 0;
  final CheckLoginController checkLoginController = Get.find();
  List<String> dsImage = [
    'https://www.hotelgrandsaigon.com/wp-content/uploads/sites/227/2017/12/GRAND_SEDK_01.jpg',
    'https://images.squarespace-cdn.com/content/v1/5aadf482aa49a1d810879b88/1626698419120-J7CH9BPMB2YI728SLFPN/1.jpg',
    'https://asiky.com/files/images/Article/tin-tuc/chup-anh-khach-san.jpg',
    'https://cf.bstatic.com/xdata/images/hotel/max1024x768/382586584.jpg?k=c615c33d39628661129df3581cdf4eacc434cccdd69ed4fc62be839d28f526af&o=&hp=1'
  ];

  @override
  void onInit() {
    loadDataImage();
    // checkLoginController.checkLogin();
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    final prefs = await SecureSharedPref.getInstance();
    userId = await prefs.getInt(Constant.userId) ?? -1;
    fetchUser(userId: userId);
  }

  Future<void> fetchUser({required int userId}) async {
    try {
      final res = await _userService.getUser(userId: userId);
      user.call(res);
    } catch (e) {
      Get.log(e.toString());
    }
    isLoading.call(false);
  }

  Future<void> loadDataImage() async {
    listImage.call(dsImage);
  }

  Future<void> pushLogin() async {
    String previousRoute = Get.currentRoute;
    await Get.toNamed(LoginView.routeName);
    await checkLoginController.checkLogin();
    Get.offNamedUntil(previousRoute, (route) => false);
  }

  Future<void> geToNotification() async {
    if (checkLoginController.isLogin.value == false) {
      Get.dialog(
        DiaLogNotification(
          onTap: () async {
            await Get.toNamed(LoginView.routeName);
            await checkLoginController.checkLogin();
            Get.back();
          },
          title: 'Thông Báo',
          content: 'Đăng nhập để sử dụng chức năng !',
          okText: 'Đăng Nhập',
        ),
      );
    } else {
      Get.toNamed(NotificationPage.routeName);
    }
  }
}
