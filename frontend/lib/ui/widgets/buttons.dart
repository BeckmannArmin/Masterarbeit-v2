import 'package:beebusy_app/constants/app_constants.dart';
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
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: width * 0.6,
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
        width: width * 0.6,
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
     this.controller, this.validator,
  }) : super(key: key);

  final Size size;
  final String labelText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

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
          icon: const Icon(Icons.mail, color: kPrimaryColor,),
          hintText: widget.labelText,
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
      width: size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: kPrimaryColor.withAlpha(15)
      ),
      child: child,
    );
  }
}
