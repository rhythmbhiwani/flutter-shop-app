import 'package:provider/provider.dart';

import '../providers/product.dart';
import 'package:flutter/material.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() => _updateImageUrl('focusNode'));
    _imageUrlController.addListener(() => _updateImageUrl('controller'));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(() => _updateImageUrl('focusNode'));
    _imageUrlController.removeListener(() => _updateImageUrl('controller'));
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl(String action) {
    if (action == "focus") {
      if (!_imageUrlFocusNode.hasFocus) {
        setState(() {});
      }
    } else {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false).updateProduct(
        _editedProduct.id,
        _editedProduct,
      );
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error Occured'),
                  content: Text('Something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okay')),
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a title.';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: value,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          } else if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          } else if (double.parse(value) <= 0) {
                            return 'Please enter price greater than 0';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                            title: _editedProduct.title,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        focusNode: _descFocusNode,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a Description.';
                          } else if (value.length < 10) {
                            return 'Description should be atleast 10 characters long';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  description: _editedProduct.description,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a image url.';
                                } else if (!value.startsWith('http') ||
                                    !value.startsWith('https')) {
                                  return 'Enter url including https or http';
                                } else {
                                  return null;
                                }
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
