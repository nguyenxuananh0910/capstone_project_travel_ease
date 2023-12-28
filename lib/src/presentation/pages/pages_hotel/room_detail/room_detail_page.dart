import 'package:capstone_project_travel_ease/core/gen/assets.gen.dart';
import 'package:capstone_project_travel_ease/core/utils/extension.dart';
import 'package:capstone_project_travel_ease/src/domain/models/facilities_model.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_booking/booking/booking_page.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_hotel/room_detail/room_detail_controller.dart';
import 'package:capstone_project_travel_ease/src/presentation/pages/pages_hotel/search_hotel/search_hotel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RoomDetailPage extends GetView<RoomDetailController> {
  static const String routeName = '/RoomDetailPage';
  const RoomDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SafeArea(
                  child: Obx(() => CarouselSlider.builder(
                        itemCount: controller.listImage.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            SizedBox(
                          width: Get.width,
                          child: ExtendedImage.network(
                            controller.listImage[itemIndex],
                            fit: BoxFit.cover,
                            shape: BoxShape.rectangle,
                            loadStateChanged: (ExtendedImageState state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.loading:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case LoadState.completed:
                                  return null;

                                case LoadState.failed:
                                  return Image.asset(
                                    Assets.images.noImage.path,
                                  );
                              }
                            },
                          ),
                        ),
                        options: CarouselOptions(
                            viewportFraction: 1,
                            // pageSnapping: false,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) =>
                                controller.activeIndex.value = index),
                      )),
                ),
                Positioned(
                  top: 60,
                  left: 10,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      size: 30,
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 10,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          size: 40,
                          Icons.bookmark_outline_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 150,
                  child: Obx(
                    () => AnimatedSmoothIndicator(
                      activeIndex: controller.activeIndex.value,
                      count: controller.listImage.length,
                      effect: const ExpandingDotsEffect(
                          dotColor: Colors.white,
                          activeDotColor: Colors.deepOrangeAccent,
                          dotHeight: 10,
                          dotWidth: 10),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.room.value?.roomName ?? '',
                      style: Get.textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => TienIch(
                                textTile: 'Room Size',
                                text: controller.room.value?.roomSize ?? '',
                                icon: const Icon(
                                  Icons.square_foot_outlined,
                                ),
                              ),
                            ),
                            Obx(
                              () => TienIch(
                                textTile: 'Guest(s)',
                                text:
                                    "${controller.room.value?.roomCapacity.toString()} guest",
                                icon: const Icon(
                                  Icons.square_foot_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Obx(
                          () => TienIch(
                            textTile: 'Bed Type',
                            text:
                                "${controller.room.value?.roomBedQuantity.toString()}  king bed ",
                            icon: const Icon(
                              Icons.square_foot_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Text(
                    'Room Facilities',
                    style: Get.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => controller.room.value?.facilities != null
                        ? Facilities(
                            facilitiesModel:
                                controller.room.value?.facilities ?? [])
                        : const SizedBox.shrink(),
                  ),
                  Text(
                    'About this room',
                    style: Get.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: controller.isExpanded.value
                                      ? controller.room.value?.roomDescription
                                      : ((controller
                                                      .room
                                                      .value
                                                      ?.roomDescription!
                                                      .length ??
                                                  -1) >
                                              200
                                          ? controller
                                              .room.value!.roomDescription
                                              ?.substring(0, 200)
                                          : controller
                                              .room.value?.roomDescription),
                                  style:
                                      Get.theme.textTheme.bodyMedium?.copyWith(
                                    color: Get.theme.colorScheme.onSurface,
                                  ),
                                ),
                                if ((controller.room.value?.roomDescription!
                                            .length ??
                                        -1) >
                                    200)
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = controller.toggleExpanded,
                                    text: controller.isExpanded.value
                                        ? ' Read Less'
                                        : ' Read More..',
                                    style: Get.theme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const GetFooter(),
    );
  }
}

class Facilities extends StatelessWidget {
  const Facilities({Key? key, required this.facilitiesModel}) : super(key: key);
  final List<FacilitiesModel> facilitiesModel;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: facilitiesModel.length,
      itemBuilder: (context, index) {
        final item = facilitiesModel[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            item.facilityName ?? '',
            style: Get.textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}

class GetFooter extends GetView<RoomDetailController> {
  const GetFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: DataSearch(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.toNamed(BookingPage.routeName, arguments: {
                      "roomId": controller.room.value?.roomId ?? -1
                    }),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 40),
                        child: Text(
                          'Book Room',
                          style: Get.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Total Price \n ',
                            style: Get.textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: controller.room.value?.roomPrice != null
                                ? NumberFormat.currency(
                                        locale: 'vi_VN', symbol: 'VND')
                                    .format(controller.room.value?.roomPrice)
                                : "",
                            style: Get.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: '\n/per night',
                              style: Get.textTheme.bodySmall!),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends GetView<SearchHotelController> {
  const DataSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: controller.dateRange.value?.start.formatDateToString(),
            style: Get.textTheme.bodySmall
                ?.copyWith(color: Colors.black, fontSize: 13),
          ),
          TextSpan(
            text: ' - ',
            style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: controller.dateRange.value?.end.formatDateToString(),
            style: Get.textTheme.bodySmall
                ?.copyWith(color: Colors.black, fontSize: 13),
          ),
          TextSpan(
            text: ', ${controller.numberRoom.value} Night(s)',
            style: Get.textTheme.bodySmall
                ?.copyWith(color: Colors.black, fontSize: 13),
          ),
          TextSpan(
            text: ', ${controller.numberAdult.value} Room(s)',
            style: Get.textTheme.bodySmall
                ?.copyWith(color: Colors.black, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class TienIch extends StatelessWidget {
  const TienIch(
      {Key? key,
      required this.textTile,
      required this.text,
      required this.icon})
      : super(key: key);
  final String textTile;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textTile,
              style: Get.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              text,
              style: Get.textTheme.bodyMedium!.copyWith(),
            ),
          ],
        )
      ],
    );
  }
}
