import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:j_chat/helper/constants.dart';
import 'package:j_chat/services/database.dart';
import 'package:j_chat/views/conversation_Screen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            useremail: searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }


  initiateSearch() {
    dataBaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    //print(val.toString());
  }

  ///create chatroom, send user to conversation screen , pushreplacment
  createChatroomAndConversation({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
        
      };


      DataBaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("You cannot send message to yourself");
    }
  }


  Widget SearchTile({ String userName,
    String useremail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(color: Colors.black),),
              Text(useremail, style: TextStyle(color: Colors.black),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text('Message'),
            ),
          )

        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,

          title: Text('search', style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
                children: [

                  Container(
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[300],
                    ) ,

                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(child: TextField(
                            controller: searchTextEditingController,
                            decoration: InputDecoration(
                                hintText: 'search username...',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                border: InputBorder.none
                            )
                        )),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      const Color.fromARGB(255, 255,98, 0),
                                      const Color.fromARGB(255, 253, 127, 44)
                                    ]

                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(Icons.search)),
                        ),

                      ],
                    ),
                  ),
                  searchList(),
                ],
              )

          ),
        )
    );
  }
}
  getChatRoomId(String a, String b){
    if(a.substring(0, 1).codeUnitAt(0)> b.substring(0, 1).codeUnitAt(0)){
      return"$b\_$a";

    }else{
      return"$a\_$b";
    }
  }








