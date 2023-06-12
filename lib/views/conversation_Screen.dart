import 'package:flutter/material.dart';
import 'package:j_chat/helper/constants.dart';
import 'package:j_chat/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream ;

   String get chatRoomIdhat =>widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "");

  Widget ChatMessageList(){
  return StreamBuilder(
    stream: chatMessagesStream,
    builder: (context,snapshot){
      return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return MessaageTile(snapshot.data.documents[index].data["message"],
              snapshot.data.documents[index].data["sendBy"]  ==Constants.myName,
            );
          }):Container();
    },
  );
}


  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap ={
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text ="";
    }
  }

  @override
  void initState() {
   dataBaseMethods.getConversationMessages(widget.chatRoomId).then((value){
     setState(() {
       chatMessagesStream=value;
     });
   });
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
        backgroundColor:Color.fromARGB(255, 236, 229, 221),
        title: (Text(chatRoomIdhat != null ?chatRoomIdhat:'00',style: TextStyle(color: Colors.black),)),
      ),
      body: Container(

        child: Stack(
            children:[
              ChatMessageList(),
              Container(

                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Message...',
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                )
                            )
                        ),

                      )
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(

                        onTap: () {
                          sendMessage();
                        },
                        child: Container(

                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 255, 98, 0),
                                    const Color.fromARGB(255, 253, 127, 44)
                                  ]

                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(Icons.send, color: Colors.white,)),
                      )
                    ],

                ),

              )


              )
            ]
        )
      )
    );
  }


}


class MessaageTile extends StatelessWidget {

  final String  message;
  final bool isSendByMe;
  MessaageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return
      Container(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                margin: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width,
                alignment:  isSendByMe?  Alignment.centerRight:Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSendByMe ? ([
                        const Color.fromARGB(255, 220, 248, 198),
                        const Color.fromARGB(255, 220, 248, 198)
                      ] )
                          : [
                        const Color.fromARGB(255,255,255,255),
                        const Color.fromARGB(255, 255, 255, 255),
                      ],

                    ),
                    borderRadius: isSendByMe ?
                    BorderRadius.only(topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23)
                    ):  BorderRadius.only(topRight: Radius.circular(23),
                        topLeft: Radius.circular(23),
                        bottomRight: Radius.circular(23)
                    ),
                  ),
                  child: Text(message !=null? message:'',style: TextStyle(color: Colors.black),),
                ),
              );
  }
}
