import 'package:crud/models/product.dart';
import 'package:crud/ui/screens/add_new_product_screen.dart';
import 'package:crud/ui/screens/product_list_screen.dart';
import 'package:crud/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';

class CRUDApp extends StatelessWidget {
  const CRUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;

        if (settings.name == '/') {
          widget = const ProductListScreen();
        } else if (settings.name == AddNewProductScreen.routeName) {
          widget = const AddNewProductScreen();
        } else if (settings.name == UpdateProductScreen.routeName) {
          final ProductModel product = settings.arguments as ProductModel;
          widget = UpdateProductScreen(
            product: product,
          );
        }
        return MaterialPageRoute(builder: (context) {
          return widget;
        });
      },
    );
  }
}
