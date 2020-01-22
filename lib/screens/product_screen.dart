import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/product_bloc.dart';
import 'package:gerenteloja/widgets/images_widget.dart';
import 'package:gerenteloja/widgets/products_sizes.dart';
import 'package:gerenteloja/validators/product_validators.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with productValidator {
  final ProductBloc _productBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(String categoryId, DocumentSnapshot product)
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextStyle(color: Colors.white, fontSize: 16);
    
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(
                  snapshot.data ? 'Editar um produto' : 'Criar Produto');
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
              initialData: false,
              stream: _productBloc.outCreated,
              builder: (context, snapshot) {
                if (snapshot.data)
                  return StreamBuilder<bool>(
                      stream: _productBloc.outLoading,
                      initialData: false,
                      builder: (context, snapshot) {
                        return IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: snapshot.data
                              ? null
                              : () {
                                  _productBloc.deleteProduct();
                                  Navigator.pop(context);
                                },
                        );
                      });
                else
                  return Container();
              }),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveProduct,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text(
                        'Imagens',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data['images'],
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['title'],
                        style: fieldStyle,
                        decoration: _buildDecoration('Título'),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['description'],
                        style: fieldStyle,
                        decoration: _buildDecoration('Descrição'),
                        maxLines: 6,
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data['price']?.toStringAsFixed(2),
                        style: fieldStyle,
                        decoration: _buildDecoration('Preço'),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                      SizedBox(
                        height: 24,
                        child: Text(
                          'Tamanhos',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      ProductsSize(
                        context: context,
                        initialValue: snapshot.data['sizes'],
                        onSaved: _productBloc.saveSizes,
                        // ignore: missing_return
                        validator: (v){
                          if(v.isEmpty) return 'Selecione um tamanho';
                          },
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Salvando produto....',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      bool success = await _productBloc.saveProduct();
      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Produto salvo com sucesso' : 'Falha ao salvar produto',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      Navigator.pop(context);
    }
  }


}
