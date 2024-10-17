import 'package:car_app/components/snack_bar/td_snack_bar.dart';
import 'package:car_app/components/snack_bar/top_snack_bar.dart';
import 'package:car_app/constants/app_color.dart';
import 'package:car_app/models/cart_model.dart';
import 'package:car_app/models/category_model.dart';
import 'package:car_app/models/product_model.dart';
import 'package:car_app/pages/home/product/item_product.dart';
import 'package:car_app/pages/home/video/box_video.dart';
import 'package:car_app/resources/double_extension.dart';
import 'package:car_app/services/remote/cart_service.dart';
import 'package:car_app/services/remote/category_service.dart';
import 'package:car_app/services/remote/product_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  late Future<List<CategoryModel>> _categories;
  late Future<List<ProductModel>> _products;
  String? _selectedCategoryId; // Biến để lưu trữ id category được chọn

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Hàm để lấy dữ liệu ban đầu
  void _fetchData() {
    _categories = _categoryService.fetchCategories().then((categories) {
      // Thêm mục "All" vào vị trí 0 của danh sách categories
      return [CategoryModel(id: 'all', name: 'All', image: '')] + categories;
    });
    _products = _productService.fetchProducts();
    _selectedCategoryId = 'all'; // Mặc định lấy tất cả sản phẩm
  }

  // Hàm để làm mới dữ liệu khi kéo xuống
  Future<void> _refresh() async {
    setState(() {
      _fetchData();
    });
    // Chờ cho cả hai Future hoàn thành
    await Future.wait([_categories, _products]);
  }

  // Hàm để thêm sản phẩm vào giỏ hàng
  Future<void> _addProductToCart(ProductModel product) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Nếu người dùng chưa đăng nhập, thông báo

        showTopSnackBar(
          context,
          const TDSnackBar.error(message: 'Please log in to add items to cart'),
        );
        return;
      }

      // Tạo một đối tượng CartModel
      CartModel cartItem = CartModel(
        userId: user.uid,
        productId: product.id.toString(), // Giả sử product có trường 'id'
        productName: product.name,
        productImage: product.image,
        productPrice: product.price,
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
    }
  }

  // Hàm để tải sản phẩm theo categoryId
  void _loadProductsByCategory(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      if (categoryId == 'all') {
        _products = _productService.fetchProducts();
      } else {
        _products = _productService.fetchProductsByCategory(categoryId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Đảm bảo Scrollable để kích hoạt RefreshIndicator
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: BoxVideo(),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Category',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            _futureCategory(),
            _futureProduct(size)
          ]),
        ),
      ),
    );
  }

  Padding _futureProduct(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Product',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 10.0),
          FutureBuilder<List<ProductModel>>(
            future: _products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No products found'));
              }

              final products = snapshot.data!;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  mainAxisExtent: 260,
                ),
                itemBuilder: (_, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemProduct(
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0)
                                    .copyWith(top: 10),
                            child: Container(
                              height: 100,
                              width: size.width,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              maxLines: 2,
                              product.description,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _addProductToCart(product);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Container(
                                height: 40.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: AppColor.blue,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
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
                                    product.price.toVND(),
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
                  );
                },
                itemCount: products.length,
              );
            },
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<CategoryModel>> _futureCategory() {
    return FutureBuilder<List<CategoryModel>>(
      future: _categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        final categories = snapshot.data!;

        return SizedBox(
          height: 100, // Increased height for larger CircleAvatar
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 5.0),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => _loadProductsByCategory(category.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: category.image != null &&
                                  category.image!.isNotEmpty
                              ? NetworkImage(category.image!)
                              : const AssetImage(
                                      'assets/images/dummy_category.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: _selectedCategoryId == category.id
                              ? Colors.teal
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          category.name ?? 'Unknown Category',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
