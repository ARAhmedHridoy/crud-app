import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  static const String routeName = '/add-new-product';

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  // controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // add product in progress
  bool _addProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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
            visible: _addProductInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
              child: const Text('Add Product'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addProduct();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addProduct() async {
    // set add product in progress
    _addProductInProgress = true;
    setState(() {});

    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');

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

    //print(response.statusCode);
    //print(response.body);

    _addProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      // clear text form
      _clearTextForm();
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product added successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      // redirect to product list after successful add
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    } else {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to add product!',
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
