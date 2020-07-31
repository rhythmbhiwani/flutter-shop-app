import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                style: TextStyle(color: Colors.black),
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 10),
            Text(
              '₹${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 800,
            )
          ])),
        ],
      ),
    );
  }
}
