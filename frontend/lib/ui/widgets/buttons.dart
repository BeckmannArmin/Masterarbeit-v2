import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/service/SizeConfig.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {
  const MyRaisedButton({@required this.buttonText, @required this.onPressed, this.width});

  final String buttonText;
  final VoidCallback onPressed;
  final double width;


 //child: BrownText(buttonText),
        //onPressed: onPressed,

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: kSecondaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: BrownText(buttonText, isBold: true,) ,
      ),
    );
  }
}

class MyFlatButton extends StatelessWidget {
  const MyFlatButton({@required this.buttonText, @required this.onPressed, this.width});

  final String buttonText;
  final VoidCallback onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: BrownText(buttonText, isBold: true,) ,
      ),
    );
  }
}


class RoundedInput extends StatefulWidget {

  const RoundedInput({
    Key key,
    @required this.size,
     @required this.labelText,
     this.controller, this.validator, @required this.icon,
  }) : super(key: key);

  final Size size;
  final String labelText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final IconData icon;

  @override
  _InputFieldState createState() => _InputFieldState();

}

class _InputFieldState extends State<RoundedInput> {

  @override
  Widget build(BuildContext context) {
   return InputContainer(
     child: TextFormField(
       validator: widget.validator,
        cursorColor: kPrimaryColor,
        controller: widget.controller,
        decoration: InputDecoration(
          icon: Icon(widget.icon, color: kPrimaryColor,),
          border: InputBorder.none,
          labelText: widget.labelText
        ),
      )
   );
}
}

class InputContainer extends StatelessWidget {

  const InputContainer({
    Key key,
    @required this.child
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: kPrimaryColor.withAlpha(15)
      ),
      child: child,
    );
  }
}

class CustomInputFieldFb1 extends StatelessWidget {
  final TextEditingController inputController;
  final Color primaryColor;
  final String labelText;

  const CustomInputFieldFb1(
      {Key key,
      @required this.inputController,
      @required this.labelText,
      this.primaryColor = Colors.indigo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        controller: inputController,
        onChanged: (value) {
          //Do something wi
        },
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
        ),
      ),
    );
  }
}
