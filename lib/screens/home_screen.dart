import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenteloja/blocs/orders_bloc.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';
import 'package:gerenteloja/tabs/orders_tab.dart';
import 'package:gerenteloja/tabs/products_tab.dart';
import 'package:gerenteloja/tabs/users_tab.dart';
import 'package:gerenteloja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
          onTap: (page) {
            _pageController.animateToPage(page,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          currentIndex: _page,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text('Clientes'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              title: Text('Pedidos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered),
              title: Text('Produtos'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          blocs: [
            Bloc((i) => UserBloc()),
            Bloc((i) => OrdersBloc()),
          ],
          child: PageView(
            controller: _pageController,
            onPageChanged: (indexPage) {
              setState(() {
                _page = indexPage;
              });
            },
            children: <Widget>[
              UsersTab(),
              OrdersTab(),
              ProductsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    final _ordersBloc = BlocProvider.getBloc<OrdersBloc>();
    switch (_page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: 'Concluidos abaixo',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: 'Concluidos acima',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EditCategoryDialog(),
            );
          },
        );
    }
  }
}
