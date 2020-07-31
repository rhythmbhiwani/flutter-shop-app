import '../providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import 'package:flutter/material.dart';
import '../screens/manage_product_screen.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ManageProductScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ],
    ));
  }
}
