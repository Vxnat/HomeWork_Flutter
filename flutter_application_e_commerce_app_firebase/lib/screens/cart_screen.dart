import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late TextEditingController couponController;
  final foodModel = ProviderFood();
  final Map<String, TextEditingController> textEditingControllerMap = {};
  final successNoti = const SnackBar(
    content: Text('Success Checkout'),
    duration: Duration(milliseconds: 800),
  );
  final correctCoupon = const SnackBar(
    content: Text('Success Apply Coupon'),
    duration: Duration(milliseconds: 800),
  );
  final incorrectCoupon = const SnackBar(
    content: Text('Sorry ! A Coupon Is Incorrect Or Expire'),
    duration: Duration(milliseconds: 800),
  );
  final emptyCart = const SnackBar(
    content: Text('Sorry ! Your cart is empty'),
    duration: Duration(milliseconds: 800),
  );
  @override
  void initState() {
    super.initState();
    couponController = TextEditingController();
  }

  void updateQuantity(String idProduct, int quantity, bool isIncrease) {
    // isIncrease
    //     ? textEditingControllerMap[idProduct]!.text =
    //         (int.parse(textEditingControllerMap[idProduct]!.text) + 1)
    //             .toString()
    //     : (int.parse(textEditingControllerMap[idProduct]!.text) - 1).toString();
    foodModel.updateQuantity(idProduct, quantity, isIncrease);
  }

  void updateQuantityByTextField(String idProduct, int newQuantity) {
    // if (newQuantity > 0 && newQuantity <= 100) {
    //   textEditingControllerMap[idProduct]!.text = newQuantity.toString();

    // }
    foodModel.updateQuantityByTextField(idProduct, newQuantity);
  }

  void removeProductFromCart(String idProduct) {
    foodModel.removeProductFromCart(idProduct);
  }

  void applyCoupon(String coupon) {
    if (foodModel.listCarts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(emptyCart);
    } else {
      if (foodModel.checkCoupon(coupon)) {
        foodModel.applyCoupon(coupon);
        ScaffoldMessenger.of(context).showSnackBar(correctCoupon);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(incorrectCoupon);
      }
    }
  }

  void removeCoupon() {
    foodModel.removeCoupon();
  }

  void checkout(double totalPrice) {
    if (foodModel.listCarts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(emptyCart);
    } else {
      foodModel.addToOrder(totalPrice);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> showAlertMessage(double totalPrice) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm Checkout',
            style: TextStyle(color: Color.fromARGB(255, 255, 94, 0)),
          ),
          content: const Text('Are you sure you want to checkout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                checkout(totalPrice);
                Navigator.pop(context);
              },
              child: const Text(
                'Checkout',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        leading: IconButton(
            hoverColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 255, 208, 137),
            onPressed: () {
              Navigator.pop(context);
              removeCoupon();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.orange,
            )),
        title: const Text(
          'My Cart',
          style: TextStyle(
              color: Color.fromARGB(255, 235, 141, 0),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: const Color.fromARGB(255, 235, 235, 235),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                    height: mq.height * .625,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 197, 197, 197)
                              .withOpacity(
                                  0.5), // Màu của boxShadow và độ trong suốt
                          spreadRadius: 5, // Bán kính mở rộng của boxShadow
                          blurRadius: 7, // Bán kính mờ của boxShadow
                          offset: const Offset(0,
                              3), // Độ dịch chuyển của boxShadow theo trục x và y
                        ),
                      ],
                    ),
                    child: StreamBuilder(
                      stream: APIs.getAllSeftCarts(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            );
                          case ConnectionState.done:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final data = snapshot.data?.docs;
                              final list = data
                                      ?.map((e) => Cart.fromJson(e.data()))
                                      .toList() ??
                                  [];
                              if (list.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'Your cart is empty',
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                );
                              }
                              foodModel.listCarts.clear();
                              context
                                  .read<ProviderFood>()
                                  .listCarts
                                  .addAll(list);
                              return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final item = list[index];
                                  textEditingControllerMap.clear();
                                  if (!textEditingControllerMap
                                      .containsKey(item.product.id)) {
                                    textEditingControllerMap[item.product.id] =
                                        TextEditingController(
                                            text: item.quantity.toString());
                                  }
                                  final controller =
                                      textEditingControllerMap[item.product.id];
                                  return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    key: Key(item.product.id),
                                    onDismissed: (direction) {
                                      removeProductFromCart(item.product.id);
                                    },
                                    background: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                              255, 255, 72, 0)),
                                      child: const Icon(
                                        CupertinoIcons.bin_xmark_fill,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 5,
                                          left: 10,
                                          right: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 197, 197, 197)
                                                .withOpacity(
                                                    0.5), // Màu của boxShadow và độ trong suốt
                                            spreadRadius:
                                                5, // Bán kính mở rộng của boxShadow
                                            blurRadius:
                                                7, // Bán kính mờ của boxShadow
                                            offset: const Offset(0,
                                                3), // Độ dịch chuyển của boxShadow theo trục x và y
                                          ),
                                        ],
                                      ),
                                      height: mq.height * .13,
                                      width: mq.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  item.product.imgProduct,
                                                  fit: BoxFit.fill,
                                                  width: 150,
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: mq.width * .2,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        item.product.name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          updateQuantity(
                                                              item.product.id,
                                                              item.quantity,
                                                              false);
                                                        },
                                                        icon: const Icon(Icons
                                                            .remove_circle),
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 115, 0),
                                                      ),
                                                      // TODO
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 13),
                                                        width: 40,
                                                        height: 30,
                                                        child: TextField(
                                                          decoration: const InputDecoration(
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.orange))),
                                                          cursorColor:
                                                              Colors.orange,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          controller:
                                                              controller,
                                                          onSubmitted:
                                                              (newValue) {
                                                            if (controller!
                                                                        .text !=
                                                                    '' &&
                                                                int.parse(controller
                                                                        .text) >
                                                                    0 &&
                                                                int.parse(controller
                                                                        .text) <=
                                                                    100) {
                                                              updateQuantityByTextField(
                                                                  item.product
                                                                      .id,
                                                                  int.parse(
                                                                      controller
                                                                          .text));
                                                            } else {
                                                              controller.text =
                                                                  1.toString();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            if (item.quantity <
                                                                100) {
                                                              updateQuantity(
                                                                  item.product
                                                                      .id,
                                                                  item.quantity,
                                                                  true);
                                                            }
                                                          },
                                                          icon: const Icon(
                                                            Icons.add_circle,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    115,
                                                                    0),
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 0),
                                                  child: SizedBox(
                                                    width: mq.width * .12,
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      const TextSpan(
                                                          text: '\$ ',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .orange)),
                                                      TextSpan(
                                                          text: item
                                                              .product.price
                                                              .toString())
                                                    ])),
                                                  )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                width: mq.width * .12,
                                                child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    text: TextSpan(children: [
                                                      const TextSpan(
                                                          text: '\$ ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.orange,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text: (item.product
                                                                      .price *
                                                                  item.quantity)
                                                              .toStringAsFixed(
                                                                  2),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17))
                                                    ])),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                        }
                        return Container();
                      },
                    )),
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 197, 197, 197)
                            .withOpacity(
                                0.5), // Màu của boxShadow và độ trong suốt
                        spreadRadius: 5, // Bán kính mở rộng của boxShadow
                        blurRadius: 7, // Bán kính mờ của boxShadow
                        offset: const Offset(0,
                            3), // Độ dịch chuyển của boxShadow theo trục x và y
                      ),
                    ],
                  ),
                  child: StreamBuilder(
                    stream: APIs.getAllSeftCarts(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          );
                        case ConnectionState.done:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final data = snapshot.data?.docs;
                            final list = data
                                    ?.map((e) => Cart.fromJson(e.data()))
                                    .toList() ??
                                [];
                            double itemTotal = 0;
                            for (var i in list) {
                              itemTotal += (i.product.price * i.quantity);
                            }
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: couponController,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Enter your discount code',
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.orange,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.orange,
                                                  width: 1.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.orange,
                                                  width: 1.0),
                                            ),
                                          ),
                                          cursorColor: Colors.orange,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(60, 55),
                                              backgroundColor: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: () {
                                            applyCoupon(couponController.text);
                                          },
                                          child: const Text(
                                            'Apply',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Item Total:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          '\$ ${itemTotal.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                    Consumer<ProviderFood>(
                                      builder: (context, providerFood, child) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Tax:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '\$ ${providerFood.couponPrice != 0 ? providerFood.couponPrice.toStringAsFixed(2) : 0.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Divider(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.094),
                                                height: 1,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25),
                                                ),
                                                Text(
                                                  '\$ ${(itemTotal - providerFood.couponPrice) < 0 ? 0.toStringAsFixed(2) : (itemTotal - providerFood.couponPrice).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Center(
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          50),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      backgroundColor:
                                                          Colors.orange,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  onPressed: () {
                                                    showAlertMessage(itemTotal -
                                                        providerFood
                                                            .couponPrice);
                                                  },
                                                  child: const Text(
                                                    'Checkout',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  )),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                          return Container();
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
