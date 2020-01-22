import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/orders_bloc.dart';
import 'package:gerenteloja/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
     final _orderBloc = BlocProvider.getBloc<OrdersBloc>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
          stream: _orderBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              );
            else if (snapshot.data.length == 0)
              return Center(
                child: Text('Nenhum dado encontrado'),
              );
            else
              return ListView.builder(
                itemBuilder: (context, index) {
                  return OrdersTile(order: snapshot.data[index],);
                },
                itemCount: snapshot.data.length,
              );
          }),
    );
  }
}
