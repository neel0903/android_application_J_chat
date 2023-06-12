import 'package:flutter/material.dart';
Widget appBarMain(BuildContext context){
  return AppBar(
    title: Text('J Chats'),
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText:hintText,
      hintStyle:TextStyle(
        color: Colors.white54,

      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.orange),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.orange),
      )
  );
}
TextStyle simpleTextFileldStyle(){
  return TextStyle(
      color: Colors.white,
    fontSize: 16,
  );
}
class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  const CustomButton({Key key,this.callback,this.text}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child:Material(
        elevation: 6.0,
        borderRadius:  BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: callback,
          minWidth: 200.0,
          height: 45.0,
          child:Text(text),
        )
      )
    );
  }
}
