import 'package:SHOP_APP/widgets/user_product_item.dart';

import '../widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';

class ManageProductScreen extends StatelessWidget {
  static const String routeName = "/manage-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetechAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Provider.of<Products>(context, listen: false).items.length <= 0
                ? Center(
                    child: Text('You have no products, try adding one'),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) => Column(
                            children: <Widget>[
                              UserProductItem(
                                productsData.items[index].id,
                                productsData.items[index].title,
                                productsData.items[index].imageUrl,
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: SideDrawer(),
    );
  }
}
