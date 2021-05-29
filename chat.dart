import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(
    this.myID,
    this.myName,
    this.selectedUserToken,
    this.selectedUserID,
    this.chatID,
    this.color,
    this.selectedUserThumbnail,
  );

  String myID;
  String myName;
  String selectedUserToken;
  String selectedUserID;
  String chatID;
  String color;
  String selectedUserThumbnail;
  String usercolor;
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFF1e1c26),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          backgroundColor: Color(0XFF252331),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatroom')
                .doc(widget.chatID)
                .collection(widget.chatID)
                .orderBy('timestamp', descending: true)
                .limit(100)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: Text(
                    'this is the bug',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                );

              return Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    // width: widthh * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
                        icon: Icon(
                          Icons.search,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              );
            }));
  }
}
