import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class addBucketListScreen extends StatefulWidget {
  int newIndex;
  addBucketListScreen({super.key, required this.newIndex});

  @override
  State<addBucketListScreen> createState() => addBucketListScreenState();
}

class addBucketListScreenState extends State<addBucketListScreen> {
  Future<void> addData() async {
    Map<String, dynamic> data = {
      "item": itemText.text,
      "cost": costText.text,
      "image": imageURLText.text,
      "completed": false
    };
    try {
      Response response = await Dio().patch(
          "https://flutterapitest-8530b-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json",
          data: data);
      Navigator.pop(context, "refresh");
    } catch (e) {
      print(e);
    }
  }

  TextEditingController itemText = TextEditingController();
  TextEditingController costText = TextEditingController();
  TextEditingController imageURLText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState>();
    const urlPattern = r'(http|https):\/\/([\w\d\-]+\.)+[\w\d\-]+(\/[^\s]*)?';
    final regex = RegExp(urlPattern);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add to Bucket List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot be Empty";
                  }
                  if (value.toString().length < 5) {
                    return "Should be greater than 5";
                  }
                },
                controller: itemText,
                decoration: const InputDecoration(label: Text("Items")),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot be Empty";
                  }
                  if (num.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                },
                controller: costText,
                decoration:
                    const InputDecoration(label: Text("Estimated Cost")),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot be Empty";
                  }
                  if (!regex.hasMatch(value)) {
                    return "Enter a valid URL";
                  }
                },
                controller: imageURLText,
                decoration: const InputDecoration(label: Text("Image URL")),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (addForm.currentState!.validate()) {
                              addData();
                            }
                          },
                          child: const Text("Add Item"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
