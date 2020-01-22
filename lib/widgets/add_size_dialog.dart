import 'package:flutter/material.dart';

class addSizeDialog extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.pinkAccent))),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
              color: Colors.pinkAccent,
              child: Text(
                'Adicionar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
