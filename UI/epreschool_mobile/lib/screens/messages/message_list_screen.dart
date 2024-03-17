import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/providers/messages_provider.dart';
import 'package:epreschool_mobile/screens/messages/message_add_screen.dart';
import 'package:epreschool_mobile/screens/messages/message_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';

class MessageListScreen extends StatefulWidget {
  static const String routeName = "messages";

  final int userId;
  const MessageListScreen({required this.userId}) : super();

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  MessagesProvider? _messagesProvider = null;
  List<Message> data = [];
  TextEditingController _searchController = TextEditingController();
  final scrollController = ScrollController();
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  int numberOfPages = 2;
  int currentPage = 1;
  bool isLoading = true;
  bool isSender = true;
  int? fromUserId = null;
  int? toUserId = null;
  int selectedTab = 0;
  bool deleteList = false;

  @override
  void initState() {
    super.initState();
    _messagesProvider = context.read<MessagesProvider>();
    scrollController.addListener(_scrollListener);
    toUserId = widget.userId;
    fromUserId = LoginProvider.authResponse!.userId;
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _messagesProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'FromUserId': fromUserId.toString(),
      'ToUserId': toUserId.toString()
    });
    setState(() {
      if (searchFilter != '' || deleteList) {
        data = response?.items as List<Message>;
        if(searchFilter == '')
        {
          deleteList = false;
        }
      } else {
        data.addAll(response?.items as List<Message>);
      }
    });
    totalRecordCounts = response?.totalCount as int;
    numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poruke"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedTab = 0;
                    });
                    fromUserId = LoginProvider.authResponse!.userId;
                    toUserId = widget.userId;
                    setState(() {
                      page = 1;
                      data = [];
                    });
                    loadData(searchFilter, page, pageSize);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTab == 0 ? Colors.blue : Colors.white,
                  ),
                  child: Text(
                    "Poslane poruke",
                    style: TextStyle(
                        color: selectedTab == 0 ? Colors.white : Colors.black),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedTab = 1;
                    });
                    fromUserId = widget.userId;
                    toUserId = LoginProvider.authResponse!.userId;
                    setState(() {
                      page = 1;
                      data = [];
                    });
                    loadData(searchFilter, page, pageSize);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTab == 1 ? Colors.blue : Colors.white,
                  ),
                  child: Text(
                    "Primljene poruke",
                    style: TextStyle(
                        color: selectedTab == 1 ? Colors.white : Colors.black),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sadržaj: ${data[index].text.length > 20 ? data[index].text.substring(0, 20) + '...' : data[index].text}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                    ),
                                    Row(children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MessagePreviewScreen(message: data[index]),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.arrow_forward_ios_outlined),
                                        label: Text('Pregled', style: TextStyle(fontSize: 12)),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                                          foregroundColor: MaterialStateProperty.all(Colors.white),
                                          elevation: MaterialStateProperty.all(0),
                                          mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
                                        ),
                                      )
                                    ],)
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Poslano od: ${data[index].fromUser.firstName.length > 10 ? data[index].fromUser.firstName.substring(0, 10) + '...' : data[index].fromUser.firstName} ${data[index].fromUser.lastName.length > 10 ? data[index].fromUser.lastName.substring(0, 10) + '...' : data[index].fromUser.lastName}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Vrijeme: " +
                                      DateFormat('dd.MM.yyyy HH:mm').format(
                                          DateTime.parse(
                                              data[index].createdAt!)),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageAddScreen(toUserId: widget.userId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Poruke",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      data = data;
    }
  }
}
