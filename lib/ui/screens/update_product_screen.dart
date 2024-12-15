import 'dart:convert';

import 'package:crud/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});

  static const String routeName = '/update-product';

  final ProductModel product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  // controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  bool _updateProductInProgress = false;

  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // set initial values
    _productNameController.text = widget.product.productName ?? '';
    _productCodeController.text = widget.product.productCode ?? '';
    _unitPriceController.text = widget.product.unitPrice ?? '';
    _quantityController.text = widget.product.quantity ?? '';
    _totalPriceController.text = widget.product.totalPrice ?? '';
    _imageController.text = widget.product.image ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildProductForm(),
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _productNameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a product name',
              labelText: 'Product Name',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter a product name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _productCodeController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a product code',
              labelText: 'Product Code',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter a product code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _unitPriceController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a unit price',
              labelText: 'Unit Price',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter a unit price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a quantity',
              labelText: 'Quantity',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter a quantity';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _totalPriceController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a total price',
              labelText: 'Total Price',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter a total price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _imageController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter an image URL',
              labelText: 'Image URL',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter an image URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: _updateProductInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
              child: const Text('Update Product'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // update product
                  _updateProduct();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProduct() async {
    // update product
    _updateProductInProgress = true;
    setState(() {});

    // update product in progress
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}');
    Map<String, dynamic> requestBody = {
      'ProductName': _productNameController.text.trim(),
      'ProductCode': _productCodeController.text.trim(),
      'UnitPrice': _unitPriceController.text.trim(),
      'Qty': _quantityController.text.trim(),
      'TotalPrice': _totalPriceController.text.trim(),
      'Img': _imageController.text.trim(),
    };
    Response response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    _updateProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      // clear text form
      _clearTextForm();

      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product updated successfully.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // navigate to product list screen after successful update
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (arguments) => false,
      );
    } else {
      // show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update product.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearTextForm() {
    _productNameController.clear();
    _productCodeController.clear();
    _unitPriceController.clear();
    _quantityController.clear();
    _totalPriceController.clear();
    _imageController.clear();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productCodeController.dispose();
    _unitPriceController.dispose();
    _quantityController.dispose();
    _totalPriceController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
