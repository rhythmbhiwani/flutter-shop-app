import './helpers/custom_route.dart';

import './screens/splash_screen.dart';

import './providers/auth.dart';
import './screens/orders_screen.dart';

import './providers/orders.dart';
import 'screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './screens/manage_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: null,
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (ctx, authData, previousOrder) => Orders(
              authData.token,
              authData.userId,
              previousOrder == null ? [] : previousOrder.items,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'Amazing Shop',
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              accentColor: Colors.cyanAccent,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder()
              }),
            ),
            home: authData.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, data) =>
                        data.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrdersScreen.routeName: (_) => OrdersScreen(),
              ManageProductScreen.routeName: (_) => ManageProductScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
            },
          ),
        ));
  }
}
