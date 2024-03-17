import 'package:epreschool_mobile/models/employeeReview.dart';
import 'package:epreschool_mobile/providers/employee_reviews_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/providers/messages_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_previews_screen.dart';
import 'package:epreschool_mobile/screens/parents/parent_previews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../models/message.dart';

class MessageAddScreen extends StatefulWidget {
  static const String routeName = "message/add";
  final int toUserId;
  MessageAddScreen({required this.toUserId});

  @override
  State<MessageAddScreen> createState() => _MessageAddScreenState();
}

class _MessageAddScreenState extends State<MessageAddScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  MessagesProvider? _messagesProvider;
  int _rating = 0;

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  void initState() {
    super.initState();
    _messagesProvider = context.read<MessagesProvider>();
  }

  Future<bool?> addNewMessage() async {
    Message message = new Message();
    message.id = 0;
    message.fromUserId = LoginProvider.authResponse!.userId;
    message.toUserId = widget.toUserId;
    message.text = textController.text;
    return (await _messagesProvider?.insert(message));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodavanje poruke"),
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: textController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Tekst poruke',
                          border: OutlineInputBorder(),
                          hintText: 'Unesite poruku ...',
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool? result = await addNewMessage();
                          if (result != null && result) {
                            Fluttertoast.showToast(
                              msg: "Poruka uspješno poslana",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginProvider
                                        .authResponse!.isParent!
                                    ? EmployeePreviewScreen(id: widget.toUserId)
                                    : ParentPreviewScreen(id: widget.toUserId),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Greška prilikom slanja poruke",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Text('Dodaj poruku'),
                      )
                    ],
                  ),
                ],
              )),
        ),
      )),
    );
  }
}
