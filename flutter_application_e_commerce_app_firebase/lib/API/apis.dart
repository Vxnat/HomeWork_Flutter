import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';
import 'package:flutter_application_e_commerce_app/modules/coupon.dart';
import 'package:flutter_application_e_commerce_app/modules/order.dart';
import 'package:flutter_application_e_commerce_app/modules/product.dart';
import 'package:flutter_application_e_commerce_app/modules/user_food.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static late UserFood me;

  // Dữ liệu cho profile_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .snapshots();
  }

  // Dữ liệu cho product_details_screen để load trái tim yêu thích
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFavorite(String id) {
    return firestore
        .collection('favorites/${user.uid}/product/')
        .where('id', isEqualTo: id)
        .limit(1)
        .snapshots();
  }

  // Dữ liệu cho favorite_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFavorites() {
    return firestore.collection('favorites/${user.uid}/product/').snapshots();
  }

  // Dữ liệu cho home_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() {
    return firestore.collection('products').snapshots();
  }

  // Dữ liệu cho home_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() {
    return firestore.collection('categories').snapshots();
  }

  // Dữ liệu cho coupon_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCoupons() {
    return firestore.collection('coupons').snapshots();
  }

  // Dữ liệu cho filter_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFilterData() {
    return firestore.collection('products').snapshots();
  }

  // Dữ liệu cho cart_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllSeftCarts() {
    return firestore.collection('carts/${user.uid}/products').snapshots();
  }

  // Dữ liệu cho order_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllSeftOrders() {
    return firestore.collection('orders/${user.uid}/products').snapshots();
  }

  // Dữ liệu cho listCarts trong Provider
  static Future<List<Cart>> getAllUserCarts() async {
    final cartRef =
        FirebaseFirestore.instance.collection('carts/${user.uid}/products');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef.get();

      List<Cart> carts = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        // Extract product and quantity data from the document
        Product product = Product.fromJson(data['product']);
        int quantity = data['quantity'];

        // Create a Cart object
        Cart cart = Cart(product: product, quantity: quantity);

        // Add to the list of carts
        carts.add(cart);
      }

      return carts;
    } catch (e) {
      rethrow;
    }
  }

  // Dữ liệu người dùng
  static Future<void> getSelfInfor() async {
    return await firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = UserFood.fromJson(user.data()!);
      }
    });
  }

  // static Future<void> addAllCategories(List<Category> listCategories) async {
  //   final ref = FirebaseFirestore.instance.collection('categories');
  //   for (var product in listCategories) {
  //     await ref.doc().set(product.toJson());
  //   }
  // }

  // Cập nhật sản phẩm yêu thích của người dùng
  static Future<void> updateFavoriteProduct(Product product) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('favorites/${user.uid}/product/')
        .where('id', isEqualTo: product.id)
        .get();
    if (querySnapshot.docs.isEmpty) {
      final ref = FirebaseFirestore.instance
          .collection('favorites/${user.uid}/product/');
      await ref.doc().set(product.toJson());
    } else {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((doc) async {
        // Lấy reference đến document cần xóa
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('favorites/${user.uid}/product/')
            .doc(doc.id);

        // Thực hiện xóa document
        await docRef.delete();
      });
    }
  }

  // Dữ liệu cho listCoupon trong Provider
  static Future<List<Coupon>> getItemCoupon() async {
    try {
      final couponRef = firestore.collection('coupons');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await couponRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Tạo một đối tượng Coupon từ QueryDocumentSnapshot
        List<Coupon> listCoupons = [];
        // Trả về đối tượng Coupon tương ứng
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          Coupon coupon = Coupon.fromDocument(doc);
          listCoupons.add(coupon);
        }
        return listCoupons;
      } else {
        // Không tìm thấy sản phẩm nào sử dụng coupon này
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Lấy ra Price của Coupon khi người dùng Apply Coupon
  static Future<double> getPriceCoupon(String newCoupon) async {
    try {
      final couponRef = firestore.collection('coupons');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await couponRef.where('coupon', isEqualTo: newCoupon).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        Coupon coupon = Coupon.fromDocument(doc);
        if (coupon.isUse.contains(user.uid) == false) {
          return coupon.price;
        }
        return 0.0;
      } else {
        // Không tìm thấy sản phẩm nào sử dụng coupon này
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  // Kiểm tra tình trạng sử dụng của Coupon
  static Future<bool> getIsUseCoupon(String newCoupon) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection('coupons')
          .where('coupon', isEqualTo: newCoupon)
          .limit(1);

      QuerySnapshot querySnapshot = await ref.get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        // Tạo một đối tượng Coupon từ QueryDocumentSnapshot
        Coupon coupon = Coupon.fromDocument(doc);
        if (coupon.isUse.contains(user.uid)) {
          return true;
        }
        // Trả về đối tượng Coupon tương ứng
        return false;
      } else {
        // Không tìm thấy sản phẩm nào sử dụng coupon này
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  // Cập nhật tình trạng tình trạng sử dụng của Coupon
  static Future<void> updateIsUseCoupon(String coupon) async {
    try {
      final couponRef = firestore.collection('coupons');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await couponRef.where('coupon', isEqualTo: coupon).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy DocumentReference của tài liệu cần cập nhật
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        DocumentReference docRef = couponRef.doc(doc.id);
        Coupon coupon = Coupon.fromDocument(doc);

        // Thực hiện cập nhật trường 'quantity' của sản phẩm trong giỏ hàng
        coupon.isUse.contains(user.uid)
            ? null
            : await docRef.update({
                'is_use': FieldValue.arrayUnion([user.uid])
              });
      } else {
        // Trường hợp không tìm thấy sản phẩm có idProduct trong giỏ hàng của người dùng
        throw Exception('Product with ID not found in the user\'s coupon.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Thêm sản phẩm vào giỏ hàng người dùng
  static Future<void> addToCart(Product product, int quantity) async {
    try {
      final ref = firestore.collection('carts/${user.uid}/products/');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await ref.where('product.id', isEqualTo: product.id).limit(1).get();
      // Nếu docs rỗng : Trong cart chưa có product nào giống với product chuẩn bị được thêm vào
      // Ta tiến thành thêm mới product
      if (querySnapshot.docs.isEmpty) {
        final Cart newProduct = Cart(product: product, quantity: quantity);
        ref.doc().set(newProduct.toJson());
      } else {
        // Nếu docs tồn tại : Trong carts đã chứa product chuẩn bị được thêm vào
        // Ta cập nhật quantity mới cho sản phẩm đó
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        // Lấy DocumentReference của tài liệu cần cập nhật
        DocumentReference docRef = ref.doc(doc.id);
        Cart cart = Cart.fromDocument(doc);

        // Thực hiện cập nhật trường 'quantity' của sản phẩm trong giỏ hàng
        docRef.update({'quantity': cart.quantity + quantity});
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Làm rỗng giỏ hàng
  static Future<void> clearCart() async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lặp qua danh sách các tài liệu trong giỏ hàng của người dùng hiện tại
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          // Xóa từng tài liệu (sản phẩm trong giỏ hàng)
          await doc.reference.delete();
        }
      } else {
        // Giỏ hàng của người dùng là trống
        throw Exception('User\'s cart is already empty.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Cập nhật số lượng tăng giảm cho sản phẩm trong giỏ hàng
  static Future<void> updateQuantity(
      String idProduct, int quantity, bool isIncrease) async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products/');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef
          .where('product.id', isEqualTo: idProduct)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        DocumentReference docRef = cartRef.doc(doc.id);

        // Thực hiện cập nhật trường 'quantity' của sản phẩm trong giỏ hàng
        if (isIncrease) {
          quantity < 100 ? await docRef.update({'quantity': ++quantity}) : null;
        } else {
          quantity--;
          quantity == 0
              ? await docRef.delete()
              : await docRef.update({'quantity': quantity});
        }
      } else {
        // Trường hợp không tìm thấy sản phẩm có idProduct trong giỏ hàng của người dùng
        throw Exception(
            'Product with ID $idProduct not found in the user\'s cart.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Cập nhật số lượng sản phầm qua TextField
  static Future<void> updateQuantityByTextField(
      String idProduct, int newQuantity) async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products/');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef
          .where('product.id', isEqualTo: idProduct)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        await cartRef.doc(doc.id).update({'quantity': newQuantity});
      }
    } catch (e) {
      rethrow;
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  static Future<void> removeProductFromCart(String idProduct) async {
    try {
      final cartRef = firestore.collection('carts/${user.uid}/products/');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await cartRef
          .where('product.id', isEqualTo: idProduct)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        // Lấy DocumentReference của tài liệu cần cập nhật
        DocumentReference docRef = cartRef.doc(doc.id);

        await docRef.delete();
      } else {
        // Trường hợp không tìm thấy sản phẩm có idProduct trong giỏ hàng của người dùng
        throw Exception(
            'Product with ID $idProduct not found in the user\'s cart.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }

  // Thêm listCart của người dùng vào danh sách mua hàng
  static Future<void> addToOrder(OrderProducts order) async {
    final ref = firestore.collection('orders/${user.uid}/products/');
    final OrderProducts newProduct = order;
    ref.doc(order.id).set(newProduct.toJson());
  }

  // Đặt lại sản phẩm tại trang order
  static Future<void> orderAgain(String idOrder) async {
    try {
      final orderRef = firestore.collection('orders/${user.uid}/products/');
      final cartRef = firestore.collection('carts/${user.uid}/products/');
      final productRef = firestore.collection('products');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await orderRef.where('id', isEqualTo: idOrder).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          OrderProducts orderDocument = OrderProducts.fromDocument(doc);

          for (var cartItem in orderDocument.listCarts) {
            QuerySnapshot<Map<String, dynamic>> cartQuerySnapshot =
                await cartRef
                    .where('product.id', isEqualTo: cartItem.product.id)
                    .get();
            // Check if the product already exists in the cart
            if (cartQuerySnapshot.docs.isNotEmpty) {
              QueryDocumentSnapshot<Map<String, dynamic>> cartItemDoc =
                  cartQuerySnapshot.docs.first;
              int currentQuantity = cartItemDoc.data()['quantity'] ?? 0;
              await cartRef.doc(cartItemDoc.id).update({
                'quantity': currentQuantity + cartItem.quantity,
              });
            } else {
              // Add a new cart item if it doesn't exist
              QuerySnapshot<Map<String, dynamic>> productQuerySnapshot =
                  await productRef
                      .where('id', isEqualTo: cartItem.product.id)
                      .limit(1)
                      .get();
              if (productQuerySnapshot.docs.isNotEmpty) {
                await cartRef.doc().set(cartItem.toJson());
              }
            }
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Cập nhật số lượng đã bán cho sản phẩm
  static Future<void> updateQuantitySold(String idProduct, int quantity) async {
    try {
      final productRef = firestore.collection('products');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await productRef.where('id', isEqualTo: idProduct).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        // Lấy DocumentReference của tài liệu cần cập nhật
        DocumentReference docRef = productRef.doc(doc.id);
        Product product = Product.fromDocument(doc);
        // Thực hiện cập nhật trường 'quantity' của sản phẩm trong giỏ hàng
        await docRef.update({'quantity_sold': product.quantitySold + quantity});
      } else {
        // Trường hợp không tìm thấy sản phẩm có idProduct trong giỏ hàng của người dùng
        throw Exception(
            'Product with ID $idProduct not found in the user\'s cart.');
      }
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở phía gọi hàm
    }
  }
}
