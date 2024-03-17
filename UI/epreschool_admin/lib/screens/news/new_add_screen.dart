import 'dart:html' as html;
import 'dart:typed_data';
import 'package:epreschool_admin/providers/news_provider.dart';
import 'package:epreschool_admin/screens/news/new_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NewAddScreen extends StatefulWidget {
  static const String routeName = "new/add";
  const NewAddScreen({super.key});

  @override
  State<NewAddScreen> createState() => _NewAddScreenState();
}

class _NewAddScreenState extends State<NewAddScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController textController = TextEditingController();
  bool public = false;
  NewsProvider? _newsProvider;
  dynamic bytes = null;
  dynamic _imageFile;

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      final buffer = Uint8List.fromList(bytes).buffer;

      setState(() {
        _imageFile = html.File([buffer], pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _newsProvider = context.read<NewsProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj obavijest"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 200.0),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                //padding: EdgeInsets.symmetric(horizontal: 200.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    onChanged: () {
                      _formKey.currentState!.validate();
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: _imageFile != null
                                  ? Image.network(
                                      html.Url.createObjectUrlFromBlob(
                                          html.Blob([_imageFile])),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 100,
                                    )
                                  : Image.network(
                                      "assets/images/new_default.png",
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 100,
                                    ),
                            ),
                            SizedBox(
                              width: 16,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _selectImage,
                                  child: Text('Odaberi sliku'),
                                ),
                              ],
                            ),
                          ],
                        )),
                        Expanded(
                          child: Column(children: [
                            Row(
                              children: [
                                Text('Javna obavijest'),
                                Checkbox(
                                  key: Key('isPublicCheckbox'),
                                  value: public,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      public = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Naziv',
                                border: OutlineInputBorder(),
                                hintText: 'Unesite naziv obavijesti',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Molimo unesite naziv';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: textController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Sadržaj',
                                border: OutlineInputBorder(),
                                hintText: 'Unesite tekst ovdje...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Molimo unesite sadržaj';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final Map<String, dynamic> formData = {
                                        'id': '0',
                                        'name': nameController.text,
                                        'text': textController.text,
                                        'public': public,
                                        'image': ""
                                      };
                                      if (bytes != null) {
                                        formData['file'] =
                                            http.MultipartFile.fromBytes(
                                          'file',
                                          bytes,
                                          filename: 'image.jpg',
                                        );
                                      }
                                      bool? result = await _newsProvider
                                          ?.insertFormData(formData);
                                      if (result != null && result) {
                                        Fluttertoast.showToast(
                                          msg: "Obavijest uspješno dodana",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewListScreen(),
                                          ),
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Greška prilikom dodavanja",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                    }
                                  },
                                  child: Text('Dodaj obavijest'),
                                )
                              ],
                            ),
                          ]),
                        ),
                      ],
                    )))),
      ),
    );
  }

  void submitData(data) async {
    await _newsProvider?.insert(data);
  }
}
