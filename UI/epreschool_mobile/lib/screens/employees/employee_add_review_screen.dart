import 'package:epreschool_mobile/models/employeeReview.dart';
import 'package:epreschool_mobile/providers/employee_reviews_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_previews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class EmployeeAddReviewsScreen extends StatefulWidget {
  static const String routeName = "child/edit";
  final int employeeId;
  EmployeeAddReviewsScreen({required this.employeeId});

  @override
  State<EmployeeAddReviewsScreen> createState() =>
      _EmployeeAddReviewsScreenState();
}

class _EmployeeAddReviewsScreenState extends State<EmployeeAddReviewsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController reviewCommentController = TextEditingController();
  EmployeeReviewsProvider? _employeeReviewsProvider;
  int _rating = 0;

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  void initState() {
    super.initState();
    _employeeReviewsProvider = context.read<EmployeeReviewsProvider>();
  }

  void addNewReview() async {
    EmployeeReview review = new EmployeeReview();
    review.id = 0;
    review.employeeId = widget.employeeId;
    review.reviewComment = reviewCommentController.text;
    review.reviewRating = _rating;
    review.parentReviewerId = LoginProvider.authResponse!.userId;
    await _employeeReviewsProvider?.insert(review);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodavanje recenzije"),
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
                        controller: reviewCommentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Napomena',
                          border: OutlineInputBorder(),
                          hintText: 'Unesite napomenu ...',
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ocjena:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.star,
                                color: _rating >= 1 ? Colors.orange : Colors.grey),
                            onPressed: () => _setRating(1),
                          ),
                          IconButton(
                            icon: Icon(Icons.star,
                                color: _rating >= 2 ? Colors.orange : Colors.grey),
                            onPressed: () => _setRating(2),
                          ),
                          IconButton(
                            icon: Icon(Icons.star,
                                color: _rating >= 3 ? Colors.orange : Colors.grey),
                            onPressed: () => _setRating(3),
                          ),
                          IconButton(
                            icon: Icon(Icons.star,
                                color: _rating >= 4 ? Colors.orange : Colors.grey),
                            onPressed: () => _setRating(4),
                          ),
                          IconButton(
                            icon: Icon(Icons.star,
                                color: _rating >= 5 ? Colors.orange : Colors.grey),
                            onPressed: () => _setRating(5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          addNewReview();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployeePreviewScreen(id: widget.employeeId),
                            ),
                          );
                        },
                        child: Text('Dodaj recenziju'),
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
