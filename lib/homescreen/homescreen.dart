import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var box = Hive.box('myBox');
  TextEditingController namecontroller = TextEditingController();
  List keylist = [];
  bool? isselected = false;
  int selectedindex = 0;
  @override
  void initState() {
    keylist = box.keys.toList();

    print(keylist);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                          label: Text("Enter any task"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2))),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.purple)),
                      onPressed: () {
                        if (namecontroller.text.isNotEmpty) {
                          box.add({
                            "title": namecontroller.text,
                            "iscompleted": false
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter any task")));
                        }
                        keylist = box.keys.toList();
                        setState(() {});
                        namecontroller.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Save"))
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("ToDo"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: keylist.length,
                itemBuilder: (context, index) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 80,
                      width: 350,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          color: Colors.purple.withOpacity(.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Text(
                              box.get(keylist[index])["title"],
                              style: TextStyle(fontSize: 20),
                            )),
                          ),
                          SizedBox(
                            width: 160,
                          ),
                          Checkbox(
                            value: box.get(keylist[index])["iscompleted"],
                            onChanged: (value) {
                              box.put(keylist[index], {
                                "title": box.get(keylist[index])["title"],
                                "iscompleted": value
                              });
                              setState(() {});
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                box.delete(keylist[index]);
                                keylist = box.keys.toList();
                                setState(() {});
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
