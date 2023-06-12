import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:j_chat/helper/authenticate.dart';
import 'package:j_chat/helper/helperfunctions.dart';
import 'package:j_chat/services/auth.dart';
import 'package:j_chat/services/database.dart';
import 'package:j_chat/views/signup.dart';
import 'package:j_chat/widgets/widgets.dart';

import 'chatRoomsScreen.dart';
class SignIn extends StatefulWidget {

  final  Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  final formKey= GlobalKey<FormState>();
String error;
bool iserror = false;
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  AuthMethods authMethods=new AuthMethods();
  DataBaseMethods dataBaseMethods= new DataBaseMethods();





  signIn() {
    setState(() {
      iserror=false;
    });
    if (formKey.currentState.validate()) {
      try{
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

        dataBaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
          snapshotUserInfo = val;
          HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data["name"]);
        });

        setState(() {
          isLoading = true;
        });
        authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
            .then((val) {
          if (val != null){
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>ChatRoom()
            ));
          }
          else{
            setState(() {
              iserror= true;
            });

          }


        });

      }
       catch (e){
setState(() {
  iserror = true;
});



      }


    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  SingleChildScrollView(
        child: Container(

          height:MediaQuery.of(context).size.height -50 ,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child:Column(

            children:[

              Expanded(
                child:Hero(
                  tag:'logo',
                  child:Container(
                    child:Image.asset('assets/images/logo.jpeg')
                  )
                )
              ),
SizedBox(
 height: 20,
  child: Text(iserror ? 'error':'',style:TextStyle(color: Colors.white) ,),
),

            Form(
              key: formKey,
              child: Column(
                children:[
                  TextFormField(
                      validator:(val){
                        return  RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val) ? null :'Please provide valid email Id ';

                      },
                      controller: emailTextEditingController,
                      style: simpleTextFileldStyle(),
                      decoration: textFieldInputDecoration('Email')
                  ),
                  TextFormField(
                    obscureText: true,
                    validator:(val){
                      return val.isEmpty || val.length < 6?'Please provide Password 6+ character ' :null ;
                    },
                    controller: passwordTextEditingController,
                    style: simpleTextFileldStyle(),
                    decoration: textFieldInputDecoration('Password'),
                  ),
                ],
              ),
            ),
              SizedBox(height: 8,),
              Container(
                alignment: Alignment.centerRight,

                child:Container(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Text('Forgot Password?',style: simpleTextFileldStyle(),),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                child: CustomButton(
                  text:'Sign In',
                      callback: (){
                       signIn();
                       },
                ),

              ),
              Container(
               child:CustomButton(
                 text:'Register',
                 callback: (){

                 },
               ),
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account? ",style: simpleTextFileldStyle()) ,
                  GestureDetector(
                        onTap: (){
                          widget.toggle();
                        },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Register now',style: simpleTextFileldStyle(),)),
                  )
                ],
              ),
            SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
  Widget showerror(){
    if(error != null)
      {
        return SizedBox(height:30,width: 50,
        child: Text(error),);
      }
    else
      {
        return SizedBox(height: 20,);
      }
  }
}
