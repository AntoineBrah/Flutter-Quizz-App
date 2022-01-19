import 'package:firequiz/blocs/theme.dart';
import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22),
      children: const <TextSpan>[
        TextSpan(
            text: 'Questions/Réponses',
            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
      ],
    ),
  );
}

Widget blueButton(
    {required BuildContext context, required String label, width,}) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      width: width != null ? width : MediaQuery.of(context).size.width - 48,
      child: Text(label, style: TextStyle(color: Colors.white, fontSize: 14)));
}

Widget customButton({required BuildContext context, required String label, required ThemeChanger themeChanger, width}) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: themeChanger.getToggled()? Colors.blue:Colors.white, borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      width: width != null ? width : MediaQuery.of(context).size.width - 48,
      child: Text(label, style: TextStyle(color: themeChanger.getToggled()? Colors.white:Colors.black, fontSize: 14)));
}

AppBar newAppBar(BuildContext context, ThemeChanger themeChanger) {

  return new AppBar(
    centerTitle: true, 
    title: appBar(context),
    actions: [
      IconButton(
        onPressed: () {
          if(themeChanger.getToggled()) {
            themeChanger.isToggled = true;
            return themeChanger.setTheme(ThemeData.dark());
          }
          else {
            themeChanger.isToggled = false;
            return themeChanger.setTheme(ThemeData.light());
          }
        },
        icon: themeChanger.getToggled() ? Icon(
          Icons.brightness_2_sharp,
          color: Colors.white,
        ) : Icon(Icons.brightness_4, color: Colors.white)
      )
    ]);
}