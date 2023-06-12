import 'package:flutter/material.dart';
import 'package:j_chat/helper/helperfunctions.dart';
import 'package:j_chat/services/auth.dart';
import 'package:j_chat/services/database.dart';
import 'package:j_chat/views/chatRoomsScreen.dart';
import 'package:j_chat/widgets/widgets.dart';

class SignUp extends StatefulWidget {

  final  Function toggle;
  SignUp(this.toggle);


  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods=new AuthMethods();
  DataBaseMethods dataBaseMethods= new DataBaseMethods();


  final formKey= GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
PasswordReset(){
  authMethods.resetPass(emailTextEditingController.text);
}
  signMeUP(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading= true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        //print("$val");
        Map<String,String > userInfoMap={
          "name": userNameTextEditingController.text,
          "email":emailTextEditingController.text,
          "Password": passwordTextEditingController.text
        };

       HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
       HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);


       dataBaseMethods.uplodeUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=>ChatRoom()
        ));
      } );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ): SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height - 50,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                  child:Hero(
                      tag:'logo',
                      child:Container(
                          child:Image.asset('assets/images/logo.jpeg')
                      )
                  )
              ),
             Form(
               key: formKey,
               child: Column(
                 children: <Widget>[
                   TextFormField(
                     validator:(val){
                       return val.isEmpty || val.length < 2?'Please Provide name':null;
                     },
                     controller: userNameTextEditingController,
                     style: simpleTextFileldStyle(),
                     decoration: textFieldInputDecoration('UserName'),
                   ),
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
              GestureDetector(
                onTap: (){
                 PasswordReset();
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Forgot Password?', style: simpleTextFileldStyle(),),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                  child: CustomButton(
                    text: 'Sign Up',
                    callback: () {
                      signMeUP();
                    },
                  ),

              ),
              Container(
                child: CustomButton(
                  text: 'Sign Up with Google ',
                  callback: () {

                  },
                ),

              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have a account? ", style: simpleTextFileldStyle()),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('SignIn ', style: simpleTextFileldStyle(),)),
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
}
