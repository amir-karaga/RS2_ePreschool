import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/providers/messages_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_previews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';

class MessagePreviewScreen extends StatefulWidget {
  static const String routeName = "message/preview";
  final Message message;
  MessagePreviewScreen({required this.message});

  @override
  State<MessagePreviewScreen> createState() =>
      _MessagePreviewScreenState();
}

class _MessagePreviewScreenState extends State<MessagePreviewScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  MessagesProvider? _messagesProvider;

  @override
  void initState() {
    super.initState();
    _messagesProvider = context.read<MessagesProvider>();
    textController.text = widget.message.text;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pregled sadržaja poruke"),
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
                        enabled: false,
                        maxLines: 5,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              labelText: 'Tekst poruke',
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
