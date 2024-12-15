import 'dart:convert';

import 'package:crud/models/product.dart';
import 'package:crud/ui/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> productList = [];
  bool _getProductListInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _getProductList();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getProductList();
        },
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          ),
          child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return ProductItem(
                product: productList[index],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/add-new-product');
        },
      ),
    );
  }

  Future<void> _getProductList() async {
    productList.clear();
    _getProductListInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      for (Map<String, dynamic> products in decodedData['data']) {
        ProductModel product = ProductModel(
          id: products['_id'],
          productName: products['ProductName'],
          productCode: products['ProductCode'],
          unitPrice: products['UnitPrice'],
          quantity: products['Qty'],
          totalPrice: products['TotalPrice'],
          image: products['Img'],
          createdDate: products['createdDate'],
        );
        productList.add(product);
        setState(() {});
      }
    }

    _getProductListInProgress = false;
    setState(() {});
  }
}
