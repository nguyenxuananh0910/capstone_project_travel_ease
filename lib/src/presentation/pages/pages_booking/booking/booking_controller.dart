import 'package:capstone_project_travel_ease/core/constraints/Constraints.dart';
import 'package:capstone_project_travel_ease/core/utils/snack_bar_and_loading.dart';
import 'package:capstone_project_travel_ease/src/domain/models/bank_model.dart';
import 'package:capstone_project_travel_ease/src/domain/models/payment_model.dart';
import 'package:capstone_project_travel_ease/src/domain/models/room_card_model.dart';
import 'package:capstone_project_travel_ease/src/domain/requests/bodys/post_booking_body.dart';
import 'package:capstone_project_travel_ease/src/domain/services/booking_service.dart';
import 'package:capstone_project_travel_ease/src/presentation/controller/checklogin_controller.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/navigator_menu/navigator_menu_page.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_booking/booking/booking_widgets/booking_overview_page.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_booking/booking/booking_widgets/detail_customer_page.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_booking/booking/booking_widgets/finish_booking_page.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_hotel/hotel_detal/hotel_detail_controller.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_hotel/search_hotel/search_hotel_controller.dart';
import 'package:capstone_project_travel_ease/src/presentation/widgets/dia_log/dialog_successful.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  late TextEditingController nameEditController;
  late TextEditingController phoneEditController;
  late TextEditingController emailEditController;
  late TextEditingController couponEditController;
  late TextEditingController noteEditController;
  final keyForm = GlobalKey<FormState>();
  final _currentStepAndPage = 0.obs;
  final pageController = PageController();
  int get currentStepAndPage => _currentStepAndPage.value;
  final pages = const [
    DetailCustomerPage(),
    BookingOverviewPage(),
    FinishBookingPage(),
  ].obs;
  final RegExp phoneRegex = RegExp(r'^([1-9])?\d{10}$');
  final RxList<PaymentModel> listPayment = <PaymentModel>[].obs;
  final CheckLoginController checkLoginController = Get.find();
  final Rxn<PaymentModel> selectedPaymentMethod = Rxn();
  final Rxn<BanksModel> selectedPayment = Rxn();
  final BookingService _bookingService =
      Get.find(tag: Constant.bookingServiceTAG);
  RxList<RoomCardModel> roomCards = <RoomCardModel>[].obs;
  final RxInt totalPrice = 0.obs;
  late int numberRoom;
  late ArgRooms argRooms;
  final RxList<BanksModel> listBanksAccount = <BanksModel>[].obs;
  final HotelDetailController hotelDetailController = Get.find();
  final SearchHotelController searchHotelController = Get.find();
  @override
  void onInit() {
    argRooms = Get.arguments as ArgRooms;
    roomCards.value = argRooms.roomCardModel;
    totalPrice.value = argRooms.price;
    numberRoom = argRooms.numberRoom;
    pageController.addListener(
      () {
        _currentStepAndPage.value = pageController.page!.round();
      },
    );
    emailEditController = TextEditingController(
        text: checkLoginController.user.value?.email ?? '');
    nameEditController = TextEditingController(
        text: checkLoginController.user.value?.fullName ?? '');
    phoneEditController = TextEditingController(
        text: checkLoginController.user.value?.phoneNumber ?? '');
    listPayment.call(payment);
    selectPaymentMethod(listPayment.first);
    super.onInit();
  }

  void goToStepAndPage(int index) {
    pageController.jumpToPage(index);
    _currentStepAndPage.value = index;
  }

  void nextToStepAndPage() {
    final isLastPage = _currentStepAndPage.value == pages.length - 1;
    final isNextPage = _currentStepAndPage.value == pages.length - 2;
    final next = _currentStepAndPage.value + 1;
    if (isLastPage) {
      if (selectedPayment.value == null) {
        SnackBarAndLoading.showSnackBar(
          'Bạn Chưa Chọn Phương Thức Thanh Toán',
          textColor: Colors.black,
          backgroundColor: Colors.white,
        );
        return;
      }
      Get.dialog(
        DiaLogSuccessful(
          onTap: () {
            onPayment();
            Get.offAllNamed(NavigatorMenuPage.routeName);
          },
          text: 'You have successfully booked. Please check your email inbox',
        ),
      );
    } else if (isNextPage) {
      goToStepAndPage(next);
    } else {
      if (keyForm.currentState!.validate()) {
        goToStepAndPage(next);
      }
    }
  }

  void selectPaymentMethod(PaymentModel? value) async {
    if (selectedPaymentMethod.value != value) {
      selectedPaymentMethod.call(value);
      await fetchListBankAccount();
      return;
    }
  }

  Future<void> fetchListBankAccount() async {
    try {
      final res = await _bookingService.listBankAccount(
        userId: checkLoginController.userid.value,
      );
      listBanksAccount.call(res);
    } catch (error) {
      Get.log(
        error.toString(),
      );
    }
  }

  void selectPayment(BanksModel? value) {
    if (selectedPayment.value?.accountId != value?.accountId) {
      selectedPayment.value = null;
      selectedPayment.call(value);
      return;
    }
  }

  Future<void> onPayment() async {
    final List<ProductList> roomInfoList = roomCards
        .map(
          (room) => ProductList(
            roomId: room.roomId,
            roomQuantity: room.roomQuantity.toInt(),
          ),
        )
        .toList();

    try {
      await _bookingService.booking(
        body: PostBookingBody(
          hotelId: hotelDetailController.hotelId,
          checkinDate:
              searchHotelController.dateRange.value?.start ?? DateTime.now(),
          checkoutDate:
              searchHotelController.dateRange.value?.end ?? DateTime.now(),
          userId: checkLoginController.userid.toInt(),
          totalPrice: totalPrice.toInt(),
          productList: roomInfoList,
          accountId: selectedPayment.value?.accountId,
          taxes: '10',
        ),
      );
    } catch (error) {
      Get.log(
        error.toString(),
      );
    }
  }
}

class ArgRooms {
  ArgRooms({
    required this.roomCardModel,
    required this.price,
    required this.numberRoom,
  });
  final List<RoomCardModel> roomCardModel;
  final int price;
  final int numberRoom;
}
