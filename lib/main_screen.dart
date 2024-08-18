import 'package:bucketlist/add_bucket_list.dart';
import 'package:bucketlist/viewitems.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          "https://flutterapitest-8530b-default-rtdb.firebaseio.com/bucketlist.json");

      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }
      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});

      print("Error in URL");
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget errorWidhet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning),
          const Text("Error-404"),
          ElevatedButton(onPressed: getData, child: const Text("Try Again! "))
        ],
      ),
    );
  }

  Widget listDataWidget() {
    List<dynamic> filteredList = bucketListData
        .where((element) => (!element?["completed"] ?? false))
        .toList();
    return filteredList.length < 1
        ? const Center(child: Text("No Tasks in the Bucket"))
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext context, int index) {
              return (bucketListData[index] is Map &&
                      ((!bucketListData[index]?["completed"] ?? false)))
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewItemsScreen(
                              index: index,
                              title: bucketListData[index]["item"] ?? " ",
                              image: bucketListData[index]["image"] ?? " ",
                            );
                          })).then((value) {
                            if (value == "refresh") {
                              getData();
                            }
                          });
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              bucketListData[index]?['image'] ?? ""),
                        ),
                        title: Text(bucketListData[index]?['item'] ?? ""),
                        trailing: Text(
                            bucketListData[index]?['cost'].toString() ?? ""),
                      ),
                    )
                  : const SizedBox();
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return addBucketListScreen(
              newIndex: bucketListData.length,
            );
          })).then((value) {
            if (value == "refresh") {
              getData();
            }
          });
        },
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Bucket List"),
        actions: [
          InkWell(
              onTap: getData,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.refresh),
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isError
                ? errorWidhet()
                : listDataWidget(),
      ),
    );
  }
}
