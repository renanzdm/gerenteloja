import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';

class OrdersHeader extends StatelessWidget {

  final DocumentSnapshot order;
  OrdersHeader({this.order});
  
  @override
  Widget build(BuildContext context) {

final _userBloc = BlocProvider.getBloc<UserBloc>();
final _user = _userBloc.getUser(order.data['clienteId']);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Nome:${_user['name']}'),
              Text('Endereço: ${_user['address']}'),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Produtos:  R\$${order.data['productsPrice'].toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text('Total: R\$${order.data['totalPrice'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500))
          ],
        ),
      ],
    );
  }
}
