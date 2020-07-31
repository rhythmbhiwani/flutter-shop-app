import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/side_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: SideDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An Error Occured'),
              );
            } else if (Provider.of<Orders>(context, listen: false)
                    .items
                    .length <=
                0) {
              return Center(
                child: Text('No orders yet'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, index) => OrderItem(
                    orderData.items[index],
                  ),
                  itemCount: orderData.items.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
