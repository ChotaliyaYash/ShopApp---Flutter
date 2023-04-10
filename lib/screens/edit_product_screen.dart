import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/modules/product.dart';
import 'package:shopapp/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // key
  final _formKey = GlobalKey<FormState>();

  // focose Node
  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();

  // TextEditing Controller
  final _imageUrlController = TextEditingController();
  // final _titleController = TextEditingController();
  // final _priceController = TextEditingController();
  // final _descriptionController = TextEditingController();

  // Loading
  bool isLoading = false;
  // Product
  // ignore: prefer_final_fields
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    imageUrl: '',
    description: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    // _titleController.dispose();
    // _priceController.dispose();
    // _descriptionController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  // update on change focus
  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        if (isEditing) {
          await Provider.of<ProductsProvider>(context, listen: false)
              .updateProduct(_editedProduct.id, _editedProduct);
        } else {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_editedProduct);
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? "Product updated successfully!"
                  : "Product added successfully",
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Some error occoured"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      return;
    }
  }

  var appBarTitle = '';

  bool isInit = true;
  bool isEditing = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final data = ModalRoute.of(context)!.settings.arguments as List;
      if (data.length > 1) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .productFindById(data[1]);
        appBarTitle = data[0];
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        isEditing = true;
        _imageUrlController.text = _editedProduct.imageUrl;
      } else {
        appBarTitle = data[0];
        isEditing = false;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(data[0]),
        title: Text(appBarTitle),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      // controller: _titleController,
                      // onFieldSubmitted: (_) =>
                      //     FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          isFavorait: _editedProduct.isFavorait,
                          id: _editedProduct.id,
                          title: newValue!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        // debugPrint(value);
                        if (value!.isEmpty) {
                          return 'Please provide a title.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      keyboardType: TextInputType.number,
                      // controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: "Price",
                      ),
                      textInputAction: TextInputAction.next,
                      // focusNode: _priceFocusNode,
                      // onFieldSubmitted: (_) =>
                      //     FocusScope.of(context).requestFocus(_descriptionFocusNode),
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          isFavorait: _editedProduct.isFavorait,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue!),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        // debugPrint(value);
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        } else if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        } else if (double.parse(value) <= 0) {
                          return 'Please enter a price greater then 0.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                      // controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      // focusNode: _descriptionFocusNode,
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          isFavorait: _editedProduct.isFavorait,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        // debugPrint(value);
                        if (value!.isEmpty) {
                          return 'Please provide a description.';
                        } else if (value.length < 10) {
                          return 'Should be atleast 10 characters.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // Image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // Image Preview
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(
                                  child: Text(
                                    "Enter Your Url",
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        // Text Urlinput
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Image Url",
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                isFavorait: _editedProduct.isFavorait,
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue!,
                              );
                            },
                            validator: (value) {
                              // debugPrint(value);
                              if (value!.isEmpty) {
                                return 'Please provide a image url.';
                              } else if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              } else if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter valid image URL';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
