import 'package:car_app/components/snack_bar/td_snack_bar.dart';
import 'package:car_app/components/snack_bar/top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_app/components/app_bar/custom_app_bar.dart';
import 'package:car_app/components/button/cr_elevated_button.dart';
import 'package:car_app/components/text_field/cr_text_field.dart';
import 'package:car_app/models/add_checkout_model.dart';
import 'package:car_app/models/cart_model.dart';
import 'package:car_app/resources/double_extension.dart';
import 'package:car_app/services/remote/cart_service.dart';
import 'package:car_app/services/remote/checkout_service.dart';
import 'package:car_app/utils/validator.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartModel> cartData;
  final double totalPrice;
  final int totalProduct;

  const CheckoutPage({
    super.key,
    required this.cartData,
    required this.totalPrice,
    required this.totalProduct,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final CheckoutService _checkoutService = CheckoutService();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleCheckout() async {
    final email = _emailController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (email.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
      // Show error if fields are empty

      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Please fill all the fields'),
      );

      return;
    }

    // Prepare checkout model
    final checkoutModel = AddCheckoutModel(
      userId: _checkoutService.userId,
      cartData: widget.cartData,
      totalPrice: widget.totalPrice,
      totalProduct: widget.totalProduct,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      createdAt: DateTime.now(),
    );

    // Place order
    String response = await _checkoutService.placeOrder(checkoutModel);

    // Show feedback
    showTopSnackBar(
      context,
      TDSnackBar.success(message: response),
    );

    // If the order is placed successfully, clear the cart and navigate back
    if (response == 'Order placed successfully') {
      await CartService().clearCart(); // Clear the cart
      Navigator.pop(context); // Navigate back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Checkout'),
          body: Column(
            children: [
              Expanded(
                flex: 14,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0)
                          .copyWith(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 158, 158, 158)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10.0),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Contact Information'),
                              ),
                              const SizedBox(height: 10.0),
                              CrTextField(
                                validator: Validator.email,
                                controller: _emailController,
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                              ),
                              const SizedBox(height: 10.0),
                              CrTextField(
                                controller: _phoneController,
                                hintText: 'Phone',
                                prefixIcon: const Icon(Icons.phone),
                              ),
                              const SizedBox(height: 10.0),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Address'),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              255, 158, 158, 158)
                                          .withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    controller: _addressController,
                                    maxLines: 5,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your address...',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Product Quantity',
                                  style: TextStyle(fontSize: 20.0)),
                              Text('${widget.totalProduct}',
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Divider(color: Colors.grey[300], thickness: 1.0),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Cost',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold)),
                              Text(widget.totalPrice.toVND(),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          CrElevatedButton(
                            height: 60.0,
                            borderRadius: BorderRadius.circular(25.0),
                            text: 'Check Out',
                            onPressed: _handleCheckout,
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
