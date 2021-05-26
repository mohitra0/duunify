import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laid/Controllers/firebaseController.dart';
import 'package:laid/Controllers/utils.dart';
import 'package:laid/group/addgroup.dart';
import 'package:laid/group/groupchat.dart';
import 'package:laid/chatbox/chat.dart';
import 'package:laid/chatbox/widget/loading.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:laid/group/joingroup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laid/group/setting.dart';

class ChatList2 extends StatefulWidget {
  ChatList2(
      Key key, this.myID, this.tabcontroller, this.controller, this.controllers)
      : super(key: key);
  TabController tabcontroller;
  final ScrollController controller;
  final PageController controllers;
  String myID;

  @override
  _ChatList2State createState() => _ChatList2State();
}

class _ChatList2State extends State<ChatList2>
    with AutomaticKeepAliveClientMixin<ChatList2> {
  @override
  bool get wantKeepAlive => true;
  String searchString;
  String useid;

  @override
  void initState() {
    super.initState();
    print('void');
  }

  @override
  void dispose() {
    super.dispose();
  }

  int countchat(myID, snapshot) {
    int resultInt = snapshot.data.documents.length;

    return resultInt;
  }

  int countchats(myID, snapshot) {
    int resultInt = snapshot.data.documents.length;

    return resultInt;
  }

  int refresh = 1000;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenSize = MediaQuery.of(context).size;
    var widthh = screenSize.width;
    var heightt = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.controllers.animateToPage(
                1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          elevation: 0,
          backgroundColor: Color(0xff21254A),
        ),
        backgroundColor: Color(0xff21254A),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
            int sensitivity = 8;
            if (details.delta.dx > sensitivity) {
              widget.controllers.animateToPage(
                1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else if (details.delta.dx < -sensitivity) {
              widget.tabcontroller.animateTo(
                1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(left: 10, top: heightt * 0.01, right: 10),
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
                      FontAwesomeIcons.search,
                      size: widthh * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                ),
              ),
              GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx > 0) {
                    widget.controllers.animateToPage(
                      1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: heightt * 0.1,
                  ),
                  child: StreamBuilder(
                    stream: (searchString == null || searchString == '')
                        ? FirebaseFirestore.instance
                            .collection('user')
                            .doc(widget.myID)
                            .collection('chatlist')
                            .orderBy('timestamp', descending: true)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('user')
                            .doc(widget.myID)
                            .collection('chatlist')
                            .where('searchIndex', arrayContains: searchString)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return new Container(
                          margin:
                              EdgeInsets.only(top: heightt * 0.04, right: 15),
                          child: Loading(),
                        );
                      } else if (snapshot.data.docs.isEmpty) {
                        return new Container(
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.forum,
                                color: Colors.white,
                                size: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'There are no chats to talk.\nPlease find new some friends to chat.',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )),
                        );
                      }
                      print('1ststreambuilder');
                      return Container(
                        // margin: EdgeInsets.only(bottom: heightt * 0.05),
                        child: ListView.builder(
                            key: widget.key,
                            shrinkWrap: true,
                            addAutomaticKeepAlives: true,
                            controller: widget.controller,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  snapshot.data.docs[index];

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      color: HexColor(
                                          "#${document.data()['color']}"),
                                      child: CachedNetworkImage(
                                        width: widthh * 0.13,
                                        height: widthh * 0.13,
                                        imageUrl: document.data()['image'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    document.data()['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: widthh * 0.04),
                                    ),
                                  ),
                                  subtitle: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(widget.myID)
                                        .collection('chatlist')
                                        .where('chatID',
                                            isEqualTo:
                                                document.data()['chatID'])
                                        .limit(1)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.connectionState ==
                                              ConnectionState.waiting)
                                        return document.data()['lastChat'] !=
                                                null
                                            ? Text(
                                                document.data()['lastChat'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Wrap(
                                                children: [
                                                  Badge(
                                                    toAnimate: false,
                                                    shape: BadgeShape.square,
                                                    badgeColor: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    badgeContent: Text('New',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ],
                                              );

                                      return Stack(
                                        children: snapshot.data.docs.map((e) {
                                          if (e.data()['typing'] == true) {
                                            return Text(
                                              '${document.data()['name']} is typing..',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          } else {
                                            return document
                                                        .data()['lastChat'] !=
                                                    null
                                                ? Text(
                                                    document.data()['lastChat'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Wrap(
                                                    children: [
                                                      Badge(
                                                        toAnimate: false,
                                                        shape:
                                                            BadgeShape.square,
                                                        badgeColor: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        badgeContent: Text(
                                                            'New',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ],
                                                  );
                                          }
                                        }).toList(),
                                      );
                                    },
                                  ),
                                  trailing: Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 4),
                                        child: (snapshot.hasData &&
                                                snapshot.data.docs.length > 0)
                                            ? StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('chatroom')
                                                    .doc(document
                                                        .data()['chatID'])
                                                    .collection(document
                                                        .data()['chatID'])
                                                    .where('idTo',
                                                        isEqualTo: widget.myID)
                                                    .where('isread',
                                                        isEqualTo: false)
                                                    .snapshots(),
                                                builder: (context,
                                                    notReadMSGSnapshot) {
                                                  return Container(
                                                    width: 70,
                                                    height: 50,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          (snapshot.hasData &&
                                                                  snapshot
                                                                          .data
                                                                          .docs
                                                                          .length >
                                                                      0)
                                                              ? readTimestamp(
                                                                  document.data()[
                                                                      'timestamp'])
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: CircleAvatar(
                                                              radius: 9,
                                                              child: Text(
                                                                (snapshot.hasData &&
                                                                        snapshot.data.docs.length >
                                                                            0)
                                                                    ? ((notReadMSGSnapshot.hasData &&
                                                                            notReadMSGSnapshot.data.docs.length >
                                                                                0)
                                                                        ? '${notReadMSGSnapshot.data.docs.length}'
                                                                        : '')
                                                                    : '',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              backgroundColor: (notReadMSGSnapshot
                                                                          .hasData &&
                                                                      notReadMSGSnapshot
                                                                              .data
                                                                              .docs
                                                                              .length >
                                                                          0 &&
                                                                      notReadMSGSnapshot
                                                                          .hasData &&
                                                                      notReadMSGSnapshot
                                                                              .data
                                                                              .docs
                                                                              .length >
                                                                          0)
                                                                  ? Colors
                                                                      .red[400]
                                                                  : Colors
                                                                      .transparent,
                                                              foregroundColor:
                                                                  Colors.white,
                                                            )),
                                                      ],
                                                    ),
                                                  );
                                                })
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _moveTochatRoom(
                                      document.data()['token'],
                                      document.data()['chatWith'],
                                      document.data()['color'],
                                      document.data()['image'],
                                      document.data()['name'],
                                      document.data()['dark'],
                                    );
                                  },
                                ),
                              );
                            }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _moveTochatRoom(
    selectedUserToken,
    selectedUserID,
    color,
    selectedUserThumbnail,
    name,
    dark,
  ) async {
    try {
      String chatID = makeChatId(widget.myID, selectedUserID);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(
                    widget.myID,
                    name,
                    selectedUserToken,
                    selectedUserID,
                    chatID,
                    color,
                    selectedUserThumbnail,
                  )));
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> group(myid, name, chatId, groupPhoto, members, show, admin,
      coadmin, token) async {
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupChat(widget.myID, name, chatId,
                  groupPhoto, members, show, admin, coadmin, token)));
    } catch (e) {
      print(e.message);
    }
  }
}
