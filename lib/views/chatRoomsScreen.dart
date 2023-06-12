import 'package:flutter/material.dart';
import 'package:j_chat/helper/authenticate.dart';
import 'package:j_chat/helper/constants.dart';
import 'package:j_chat/helper/helperfunctions.dart';
import 'package:j_chat/services/auth.dart';
import 'package:j_chat/services/database.dart';
import 'package:j_chat/views/conversation_Screen.dart';
import 'package:j_chat/views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods _authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  Stream chatRoomsStream;
  Widget chatRoomList(){
    return StreamBuilder(
      stream:  chatRoomsStream,
      builder: (context,snapshot){
        return  snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
          return ChatRoomTile(
           snapshot.data.documents[index].data["chatRoomId"]
               .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
              snapshot.data.documents[index].data["chatRoomId"],
            );
           }):Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo()async{
    Constants.myName= await HelperFunctions.getUserNameSharedPreference();
    dataBaseMethods.getChatRoom(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Chats',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.black),
        ),

        actions:[
          GestureDetector(
            onTap: (){
              _authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>Authenticate()
              ));
              },
              child: Container(
            padding:EdgeInsets.symmetric(horizontal: 16),
            child:  Icon(Icons.exit_to_app, color: Colors.deepOrange,size: 40),
          )
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.deepOrange,
        child: Icon(Icons.search,),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Search()));
        },
      ),
    );
  }
}



class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId)));
      },
      child: Container(

          padding :EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black,),
          bottom: BorderSide(
            color: Colors.black,
          )
        ),
          color: Colors.blueGrey[100],

        ),

        child:Row(
          children:[
            Container(

              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),

              child:Text("${userName !=null ?userName.substring(0,1).toUpperCase(): ''}",
              ),
            ),

              SizedBox(width:8,),
              Text(userName !=null ? userName:'',)
          ]
        )
      ),
    );
  }
}
