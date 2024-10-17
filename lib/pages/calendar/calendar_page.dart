import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:car_app/components/button/cr_elevated_button.dart';
import 'package:car_app/components/snack_bar/td_snack_bar.dart';
import 'package:car_app/components/snack_bar/top_snack_bar.dart';
import 'package:car_app/constants/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Lấy userId của người dùng hiện tại
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> fetchOrdersByUserId() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('uId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> _cancelOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();

      showTopSnackBar(
        context,
        const TDSnackBar.success(message: 'Order has been cancelled'),
      );
    } catch (e) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Failed to cancel order: : ${e.toString()}'),
      );
    }
  }

  // Hàm để làm mới dữ liệu
  Future<void> _refreshOrders() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchOrdersByUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          // Dữ liệu đơn hàng của người dùng hiện tại
          var orders = snapshot.data!.docs;

          return RefreshIndicator(
            onRefresh: _refreshOrders,
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                var order = orders[index];
                var cartData = order['cartData'];
                var createdAt = order['createdAt'].toDate();
                var totalPrice = order['totalPrice'];
                var status = order['status'];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Container(
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
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartData.length,
                          itemBuilder: (context, itemIndex) {
                            var product = cartData[itemIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
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
                                        image: NetworkImage(
                                            product['productImage']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['productName'],
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            NumberFormat.currency(
                                                    symbol: 'VND: ',
                                                    decimalDigits: 0)
                                                .format(product[
                                                    'productPrice']), // Định dạng giá
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            'Quantity: ${product['quantity']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        _text(createdAt, totalPrice, cartData, status, order,
                            context),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Padding _text(
      DateTime createdAt,
      double totalPrice,
      List cartData,
      String? status,
      QueryDocumentSnapshot<Object?> order,
      BuildContext context) {
    // Tạo định dạng cho ngày
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    // Định dạng giá trị
    final NumberFormat currencyFormat = NumberFormat.currency(
        symbol: 'VND: ', decimalDigits: 0); // Định dạng giá trị tiền

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 10.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Date: ${dateFormat.format(createdAt)}', // Định dạng ngày
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Price: ${currencyFormat.format(totalPrice)}', // Định dạng giá
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Total: ${cartData.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Status: ${status ?? 'Đang chờ xử lý'}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          _button(order, context),
        ],
      ),
    );
  }

  Row _button(QueryDocumentSnapshot<Object?> order, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CrElevatedButton(
          onPressed: () {},
          text: 'Support',
          color: Colors.blue,
          borderColor: Colors.white,
        ),
        CrElevatedButton(
          onPressed: () {
            String status =
                order['status'] ?? ''; // Lấy trạng thái của đơn hàng

            if (status == 'Shipped' || status == 'Delivered') {
              // Hiển thị thông báo rằng đơn hàng không thể hủy
              showTopSnackBar(
                context,
                const TDSnackBar.error(
                    message:
                        'Cannot cancel the order, it has already been shipped or delivered.'),
              );
            } else if (status == 'Cancelled') {
              // Hiển thị thông báo rằng đơn hàng đã được hủy
              showTopSnackBar(
                context,
                const TDSnackBar.error(
                    message: 'Order has already been canceled.'),
              );
            } else {
              // Hiển thị hộp thoại xác nhận hủy
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Cancellation'),
                    content: const Text(
                        'Are you sure you want to cancel this order?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Đóng hộp thoại
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Gọi logic hủy đơn hàng ở đây
                          await _cancelOrder(
                              order.id); // Sử dụng ID đơn hàng để hủy
                          Navigator.of(context).pop(); // Đóng hộp thoại

                          // Hiển thị thông báo thành công
                          showTopSnackBar(
                            context,
                            const TDSnackBar.success(
                                message:
                                    'Order has been cancelled successfully.'),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          text: 'Cancel',
          color: Colors.red,
          borderColor: Colors.white,
        ),
      ],
    );
  }
}
