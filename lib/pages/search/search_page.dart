import 'package:car_app/components/snack_bar/td_snack_bar.dart';
import 'package:car_app/components/snack_bar/top_snack_bar.dart';
import 'package:car_app/constants/app_color.dart';
import 'package:car_app/pages/home/product/item_product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:car_app/models/product_model.dart';
import 'package:car_app/components/text_field/cr_search_box.dart';
import 'package:car_app/models/cart_model.dart';
import 'package:car_app/resources/double_extension.dart';
import 'package:car_app/services/remote/cart_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  final CartService _cartService = CartService();
  String searchQuery = "";
  bool _isAddingToCart = false; // State to manage cart adding

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fetch products based on search query
  Stream<QuerySnapshot> fetchProducts(String query) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots();
  }

  // Method to handle adding product to cart
  Future<void> _handleAddToCart(ProductModel product) async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      CartModel cartModel = CartModel(
        userId: _cartService.userId,
        productId: product.id,
        productName: product.name,
        productImage: product.image,
        productPrice: product.price,
        quantity: 1,
      );
      String response = await _cartService.addToCart(cartModel);
      showTopSnackBar(
        context,
        TDSnackBar.success(message: response),
      );
    } catch (error) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Failed to add to cart: $error'),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              CrSearchBox(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: fetchProducts(searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error loading products'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }
                    var products = snapshot.data!.docs;
                    return DynamicHeightGridView(
                      builder: (context, index) {
                        var product = products[index];
                        var productData = ProductModel.fromJson(
                            product.data() as Map<String, dynamic>);
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemProduct(
                                    product: productData,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(2, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0)
                                        .copyWith(top: 10),
                                    child: Container(
                                      height: 100,
                                      width: size.width,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          productData.image ?? '-',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          maxLines: 1,
                                          productData.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          productData.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: _isAddingToCart
                                            ? null
                                            : () {
                                                _handleAddToCart(productData);
                                              },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: _isAddingToCart
                                                ? const CircularProgressIndicator()
                                                : Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.grey[800],
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40.0,
                                        width: 92.0,
                                        decoration: BoxDecoration(
                                          color: AppColor.blue,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            maxLines: 1,
                                            productData.price.toVND(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: products.length,
                      crossAxisCount: 2,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
