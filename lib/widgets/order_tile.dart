import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/widgets/order_header.dart';

class OrdersTile extends StatelessWidget {
  final DocumentSnapshot order;
  OrdersTile({this.order});

  final states = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando Entrega',
    'Entregue'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
     
          initiallyExpanded:  order.data['status'] != 4,
          title: Text(
            '#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - ${states[order.data['status']]}',
            style: TextStyle(
                color: order.data['status'] != 4
                    ? Colors.grey[750]
                    : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrdersHeader(
                    order: order,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data['products'].map<Widget>((p) {
                      return ListTile(
                        title: Text(p['product']['title'] + '-' + p['size']),
                        subtitle: Text(p['category'] + '/' + p['idProduct']),
                        trailing: Text(
                          p['quantity'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Firestore.instance
                              .collection('users')
                              .document(order['clienteId'])
                              .collection('orders')
                              .document(order.documentID)
                              .delete();
                          order.reference.delete();
                        },
                        child: Text('Excluir'),
                        textColor: Colors.red,
                      ),
                      FlatButton(
                        onPressed: order.data['status'] > 1
                            ? () {
                                order.reference.updateData(
                                    {'status': order.data['status'] - 1});
                              }
                            : null,
                        child: Text('Regredir'),
                        textColor: Colors.grey[750],
                      ),
                      FlatButton(
                        onPressed: order.data['status'] < 4
                            ? () {
                                order.reference.updateData(
                                    {'status': order.data['status'] + 1});
                              }
                            : null,
                        child: Text('Avançar'),
                        textColor: Colors.green,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
