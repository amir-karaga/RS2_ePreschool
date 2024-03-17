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
import '../../models/new.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewEditScreen extends StatefulWidget {
  static const String routeName = "new/edit";
  final int id;
  NewEditScreen({required this.id});

  @override
  State<NewEditScreen> createState() => _NewEditScreenState();
}

class _NewEditScreenState extends State<NewEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late New? data = null;
  TextEditingController nameController = TextEditingController();
  TextEditingController textController = TextEditingController();
  bool public = false;
  NewsProvider? _newsProvider;
  dynamic bytes = null;
  dynamic _imageFile;
  String? imageUrl = null;
  String apiUrl = "";

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
    apiUrl = dotenv.env['API_URL']!;
    _imageFile = null;
    _newsProvider = context.read<NewsProvider>();
    loadData();
  }

  Future<void> loadData() async {
    New? item = await _newsProvider?.getById(widget.id, null);
    setState(() {
      this.data = item!;
      final data = this.data;
      if (data != null) {
        nameController.text = data.name;
        textController.text = data.text;
        public = data.public;
        imageUrl = data?.image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editovanje obavijest"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: this.data != null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 200.0),
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
                                  : imageUrl != null && imageUrl != ""
                                      ? Image.network(
                                          apiUrl + data!.image,
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
                                  key: Key('favoriteCheckbox'),
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
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  labelText: 'Naziv',
                                  border: OutlineInputBorder(),
                                  hintText: 'Unesite naziv obavijesti',
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: textController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  labelText: 'Tekst',
                                  border: OutlineInputBorder(),
                                  hintText: 'Unesite tekst ovdje...',
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final Map<String, dynamic> formData = {
                                        'id': data?.id,
                                        'userId': data?.userId,
                                        'name': nameController.text,
                                        'text': textController.text,
                                        'public': public,
                                        'image': data?.image,
                                        'createdAt': data?.createdAt
                                      };
                                      if (bytes != null) {
                                        formData['file'] =
                                            http.MultipartFile.fromBytes(
                                          'file',
                                          bytes,
                                          filename: 'image.jpg',
                                        );
                                      }
                                      var result = await _newsProvider
                                          ?.updateFormData(formData);
                                      if(result!= null && result)
                                        {
                                      Fluttertoast.showToast(
                                        msg: "Obavijest uspjesno uređena",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => NewListScreen(),
                                        ),
                                      );}
                                      else{
                                        Fluttertoast.showToast(
                                          msg: "Greška prilikom uređivanja obavijesti",
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
                                  child: Text('Edituj obavijest'),
                                )
                              ],
                            ),
                          ]),
                        ),
                      ],
                    )))
            : Container(),
      ),
    );
  }
}
