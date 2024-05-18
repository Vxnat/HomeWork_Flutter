import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_date.dart';
import 'package:flutter_application_e_commerce_app/modules/banner_slider.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';
import 'package:flutter_application_e_commerce_app/modules/coupon.dart';
import 'package:flutter_application_e_commerce_app/modules/order.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';

class ProviderFood extends ChangeNotifier {
  // Tạo ra 1 instance duy nhất cho toàn bộ chương trình
  static final ProviderFood _instance = ProviderFood._();
  factory ProviderFood() => _instance;
  ProviderFood._();
  List<Cart> listCarts = [];
  List<Coupon> listCoupons = [];
  // Dùng ở home_screen cho slide
  List<BannerSlider> listBanner = [
    BannerSlider(id: '1', name: 'Pizza', imgBanner: 'img/pizza_banner.jpg'),
    BannerSlider(id: '2', name: 'Burger', imgBanner: 'img/burger_banner.jpg'),
    BannerSlider(
        id: '3', name: 'Fastfood', imgBanner: 'img/fastfood_banner.jpg')
  ];
  double couponPrice = 0;
  String coupon = '';

  // Lấy dữ liệu listCarts từ Firebase
  void getAllUserCartsFromApi() async {
    listCarts.clear();
    listCarts = await APIs.getAllUserCarts();
    notifyListeners();
  }

  // Lấy dữ liệu listCoupons từ Firebase
  void getCouponsFromApi() async {
    listCoupons = await APIs.getItemCoupon();
    notifyListeners();
  }

  // Kiểm tra tính khả dụng của coupon
  bool checkCoupon(String newCoupon) {
    // // Tra ve True tuc la coupon dung hoac chua ton tai trong mang isUse
    // // if ma bang True thi list isUse da ton tai user id va id do ko su dung duoc nua
    return listCoupons.any((element) =>
            element.coupon == newCoupon &&
            element.isUse.contains(APIs.user.uid) == false)
        ? true
        : false;
  }

  // Thêm sản phẩm vào Cart
  void addToCart(Product product, int quantity) {
    APIs.addToCart(product, quantity);
    listCarts.add(Cart(product: product, quantity: quantity));
  }

  // Cập nhật số lượng của sản phẩm trong cart , tăng , giảm , 1 quantity
  void updateQuantity(String idProduct, int quantity, bool isIncrease) {
    APIs.updateQuantity(idProduct, quantity, isIncrease);
  }

  // Cập nhật số lượng của sản phẩm trong cart , TextField
  void updateQuantityByTextField(String idProduct, int newQuantity) {
    APIs.updateQuantityByTextField(idProduct, newQuantity);
  }

  // Xóa sản phẩm trong Cart
  void removeProductFromCart(String idProduct) {
    APIs.removeProductFromCart(idProduct);
    listCarts.removeWhere((element) => element.product.id == idProduct);
    notifyListeners();
  }

  // Xác nhận Mã giảm giá
  void applyCoupon(String newCoupon) async {
    couponPrice = await APIs.getPriceCoupon(newCoupon);
    coupon = newCoupon;
    notifyListeners();
  }

  // Reset các thuộc tính của mã giảm giá
  void removeCoupon() {
    if (couponPrice != 0 && coupon != '') {
      coupon = '';
      couponPrice = 0;
      notifyListeners();
    }
  }

  // Cập nhật trạng thái sản phẩm yêu thích
  void updateFavoriteProduct(Product product) {
    APIs.updateFavoriteProduct(product);
  }

  // Xác nhận mua hàng , thêm vào danh sách mua hàng
  void addToOrder(double totalPrice) {
    final List<Cart> clonedListCarts =
        List.from(listCarts); // Tạo một bản sao của listCarts
    OrderProducts order = OrderProducts(
        id: generateRandomOrderID(),
        date: ExtensionDate.formatDateHomePage(DateTime.now()),
        listCarts: clonedListCarts,
        totalPrice: totalPrice);
    // Gửi danh sách đặt hàng lên API
    APIs.addToOrder(order);
    if (coupon != '') {
      // Cập nhật coupon thành "Đã sử dụng"
      APIs.updateIsUseCoupon(coupon);
    }
    // Cập nhật số lượng đã bán cho sản phẩm
    updateQuantitySold();
    // Xóa Cart ở trên API
    APIs.clearCart();
    // Làm rỗng dữ liệu Coupon
    removeCoupon();
    listCarts.clear();
    notifyListeners();
  }

  // Cập nhật số lượng đã bán
  void updateQuantitySold() {
    for (Cart item in listCarts) {
      APIs.updateQuantitySold(item.product.id, item.quantity);
    }
  }

  // Đặt lại
  void orderAgain(String idOrder) async {
    APIs.orderAgain(idOrder.trim());
  }

  // Tạo Id bất kì cho orderItem
  String generateRandomOrderID() {
    final random = Random();
    String result = '#';
    for (int i = 0; i < 5; i++) {
      result += random.nextInt(10).toString();
    }
    result += '-';
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(10).toString();
    }
    return result;
  }
}
