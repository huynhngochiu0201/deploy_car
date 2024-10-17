import 'package:car_app/components/snack_bar/td_snack_bar.dart';
import 'package:car_app/components/snack_bar/top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_app/components/button/cr_elevated_button.dart';
import 'package:car_app/constants/app_color.dart';
import 'package:car_app/models/cart_model.dart';
import 'package:car_app/pages/cart/checkout/checkout_page.dart';
import 'package:car_app/resources/double_extension.dart';
import 'package:car_app/services/remote/cart_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Stream<List<CartModel>> _cartItems;

  // Biến trạng thái để quản lý loading
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() {
    _cartItems = _cartService.getCartStream();
  }

  // Hàm để làm mới dữ liệu khi kéo xuống
  Future<void> _refreshCart() async {
    setState(() {
      _fetchCartItems();
    });
    _cartItems;
  }

  // Hàm để xóa sản phẩm khỏi giỏ hàng
  Future<void> _removeItem(String productId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await _cartService.removeFromCart(productId);
      showTopSnackBar(
        context,
        TDSnackBar.success(message: res),
      );
      _fetchCartItems();
    } catch (e) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Error: ${e.toString()}'),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm để cập nhật số lượng sản phẩm (tăng hoặc giảm)
  Future<void> _updateQuantity(CartModel cartItem, int newQuantity) async {
    if (newQuantity < 1) return;

    setState(() {
      _isLoading = true;
    });
    try {
      await _cartService.updateQuantity(cartItem.productId, newQuantity);
      // showTopSnackBar(
      //   context,
      //   const TDSnackBar.success(message: 'Quantity updated '),
      // );

      _fetchCartItems();
    } catch (e) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Error: ${e.toString()}'),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<List<CartModel>>(
            stream: _cartItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Giỏ hàng của bạn trống'));
              }

              final cartItems = snapshot.data!;

              return RefreshIndicator(
                onRefresh: _refreshCart,
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cartItem = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Container(
                        height: 120.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 20.0,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: AppColor.white,
                                image: DecorationImage(
                                  image: NetworkImage(cartItem.productImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      cartItem.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      cartItem.productPrice.toVND(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (cartItem.quantity > 1) {
                                              _updateQuantity(cartItem,
                                                  cartItem.quantity - 1);
                                            }
                                          },
                                          child: const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.teal,
                                            child: Icon(
                                              FontAwesomeIcons.minus,
                                              color: Colors.white,
                                              size: 12.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            cartItem.quantity.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _updateQuantity(cartItem,
                                                cartItem.quantity + 1);
                                          },
                                          child: const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.teal,
                                            child: Icon(
                                              FontAwesomeIcons.plus,
                                              color: Colors.white,
                                              size: 12.0,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Xác nhận'),
                                                content: const Text(
                                                    'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _removeItem(
                                                          cartItem.productId);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Xóa'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/delete.svg',
                                            height: 20.0,
                                            width: 20.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          StreamBuilder<List<CartModel>>(
            stream: _cartItems,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox.shrink();
              }

              final cartItems = snapshot.data!;
              double productCost = cartItems.fold(
                  0.0, (sum, item) => sum + item.productPrice * item.quantity);
              int totalQuantity =
                  cartItems.fold(0, (sum, item) => sum + item.quantity);

              double totalCost = productCost;

              return DraggableScrollableSheet(
                initialChildSize: 0.2,
                minChildSize: 0.08,
                maxChildSize: 0.4,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, -1),
                            blurRadius: 20.0)
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 40),
                              child: Container(
                                height: 6,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Product Quantity',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  totalQuantity.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Divider(
                              color: Colors.grey[300],
                              thickness: 1.0,
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Cost',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  totalCost.toVND(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            CrElevatedButton(
                              height: 60.0,
                              borderRadius: BorderRadius.circular(25.0),
                              text: 'Check Out',
                              onPressed: () {
                                // Kiểm tra giỏ hàng không trống
                                if (cartItems.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Giỏ hàng trống')),
                                  );
                                  return;
                                }

                                // Chuyển hướng đến trang thanh toán hoặc xử lý thanh toán
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckoutPage(
                                            cartData: cartItems,
                                            totalPrice: totalCost,
                                            totalProduct: totalQuantity,
                                          )),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
