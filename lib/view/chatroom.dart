import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/helper/authenticate.dart';
import 'package:firebase_chat/helper/constant.dart';
import 'package:firebase_chat/helper/helperfunctions.dart';
import 'package:firebase_chat/helper/theme.dart';
import 'package:firebase_chat/services/auth.dart';
import 'package:firebase_chat/services/database.dart';
import 'package:firebase_chat/values/colors.dart';
import 'package:firebase_chat/view/search.dart';
import 'package:firebase_chat/widget/widget.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
     Stream<QuerySnapshot>? chatRooms;
    @override
    void initState() {
      getUserInfogetChats();
      super.initState();
    }

    getUserInfogetChats() async {
      Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
      DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
        setState(() {
          chatRooms = snapshots;
          print(
              "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
        });
      });
    }
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data!.docs[index]['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data!.docs[index]['chatRoomId'],
                  );
                })
            : Container();
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('ChatRoom',style: titleTextStyle(),),
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: indigoAccent100,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: indigoAccent100,
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
