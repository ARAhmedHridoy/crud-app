import 'package:crud/models/product.dart';
//import 'package:crud/ui/screens/product_list_screen.dart';
import 'package:crud/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.image ?? 'https://fakeimg.pl/400x400',
        width: 60,
      ),
      title: Text(product.productName ?? 'N/A'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code : ${product.productCode ?? 'N/A'}'),
          Text('Quantity : ${product.quantity ?? 'N/A'}'),
          Text('Price : ${product.unitPrice ?? 'N/A'}'),
          Text('Total Price : ${product.totalPrice ?? 'N/A'}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.routeName,
                arguments: product,
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              // delete product
              //_deleteProduct(context, product);
              _confirmationDelete(context, product);
            },
          ),
        ],
      ),
    );
  }
}

void _confirmationDelete(BuildContext context, ProductModel product) {
  // show confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              // delete product
              _deleteProduct(context, product);
            },
          ),
        ],
      );
    },
  );
}

// delete product function
Future<void> _deleteProduct(BuildContext context, ProductModel product) async {
  // delete product
  Uri uri = Uri.parse(
    'https://crud.teamrabbil.com/api/v1/DeleteProduct/${product.id}',
  );

  Response response = await get(uri);

  if (response.statusCode == 200) {
    // show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Product deleted successfully.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
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
          'Failed to delete product.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
