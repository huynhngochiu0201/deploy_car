import 'package:car_app/services/remote/cart_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:car_app/models/product_model.dart';
import 'package:car_app/resources/double_extension.dart';

import '../../../components/button/cr_elevated_button.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../models/cart_model.dart';

class ItemProduct extends StatefulWidget {
  final ProductModel product;

  const ItemProduct({super.key, required this.product});

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  bool isExpanded = false;
  final CartService _cartService = CartService();
  bool _isAddingToCart = false;

  Future<void> _addProductToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Nếu người dùng chưa đăng nhập, thông báo
        setState(() {
          _isAddingToCart = false;
        });
        showTopSnackBar(
          context,
          const TDSnackBar.error(message: 'Please log in to add items to cart'),
        );
        return;
      }

      // Tạo một đối tượng CartModel
      CartModel cartItem = CartModel(
        userId: user.uid,
        productId:
            widget.product.id.toString(), // Giả sử product có trường 'id'
        productName: widget.product.name,
        productImage: widget.product.image,
        productPrice: widget.product.price,
        quantity: 1, // Mặc định thêm 1 sản phẩm
      );

      // Gọi phương thức addToCart từ CartService
      String res = await _cartService.addToCart(cartItem);

      // Hiển thị phản hồi cho người dùng
      showTopSnackBar(
        context,
        TDSnackBar.success(message: res),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Error: ${e.toString()}'),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProductImage(),
                  const SizedBox(height: 20.0),
                  _buildProductName(),
                  const SizedBox(height: 10.0),
                  _buildProductQuantity(),
                  const SizedBox(height: 10.0),
                  _buildProductDescription(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 40.0),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 411,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.network(
                widget.product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.error)),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 10,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        widget.product.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProductQuantity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Quantity: ${widget.product.quantity.toString()}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProductPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.product.price.toVND(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProductDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RichText(
        text: TextSpan(
          text: isExpanded || widget.product.description.length <= 200
              ? widget.product.description
              : '${widget.product.description.substring(0, 200)}...',
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            if (!isExpanded && widget.product.description.length > 200)
              TextSpan(
                text: ' Read more',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
              ),
            if (isExpanded && widget.product.description.length > 200)
              TextSpan(
                text: ' Show less',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProductPrice(),
          CrElevatedButton(
            onPressed: _isAddingToCart ? null : _addProductToCart,
            text: _isAddingToCart ? 'Adding...' : 'Add to Cart',
          ),
        ],
      ),
    );
  }
}
