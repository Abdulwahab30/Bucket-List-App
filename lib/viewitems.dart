import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewItemsScreen extends StatefulWidget {
  String title;
  String image;
  int index;
  ViewItemsScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.index});
  @override
  State<ViewItemsScreen> createState() => ViewItemsScreenState();
}

class ViewItemsScreenState extends State<ViewItemsScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      Response response = await Dio().delete(
          "https://flutterapitest-8530b-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json");
      Navigator.pop(context, "refresh");
    } catch (e) {
      print(e);
    }
  }

  Future<void> markAsComplete() async {
    Map<String, dynamic> data = {"completed": true};
    try {
      Response response = await Dio().patch(
          "https://flutterapitest-8530b-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json",
          data: data);
      Navigator.pop(context, "refresh");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(onSelected: (value) {
            if (value == 1) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Delete Item!"),
                      actions: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        InkWell(onTap: deleteData, child: Text("Confirm"))
                      ],
                    );
                  });
            }
            if (value == 2) {
              markAsComplete();
            }

            print(value);
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(value: 1, child: Text("Delete")),
              const PopupMenuItem(value: 2, child: Text("Mark as Done"))
            ];
          })
        ],
        title: Text("${widget.title}"),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(widget.image)),
            ),
          ),
        ],
      ),
    );
  }
}
