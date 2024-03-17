import 'package:epreschool_mobile/models/new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NewPreviewScreen extends StatefulWidget {
  static const String routeName = "message/preview";
  final New newItem;
  NewPreviewScreen({required this.newItem});

  @override
  State<NewPreviewScreen> createState() => _NewPreviewScreenState();
}

class _NewPreviewScreenState extends State<NewPreviewScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    titleController.text = widget.newItem.text;
    textController.text = widget.newItem.text;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pregled obavijesti"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Form(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.validate();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Container(
                            child: widget.newItem.image != null && widget.newItem.image != ""
                                ? Image.network(
                                widget.newItem.image ?? '',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover)
                                : Image.asset(
                              "assets/images/user.png",
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            )),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Vrijeme: " +
                        DateFormat('dd.MM.yyyy HH:mm').format(
                            DateTime.parse(
                                widget.newItem.createdAt)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: titleController,
                        readOnly: true,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: 'Naslov',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: textController,
                        readOnly: true,
                        maxLines: 5,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: 'Tekst obavijesti',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              )),
        ),
      )),
    );
  }
}
