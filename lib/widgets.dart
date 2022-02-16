import 'package:fluthereum/main.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

Future<List<String>> createNewContact(BuildContext context) async {
  List<String> vars = [];
  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController name = new TextEditingController();
      TextEditingController phone = new TextEditingController();
      TextEditingController desc = new TextEditingController();
      return AlertDialog(
        title: Text("Create Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            txtField('Name', name),
            SizedBox(
              height: 10,
            ),
            txtField('Phone', phone),
            SizedBox(
              height: 10,
            ),
            txtField('Description', desc),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Create"),
            onPressed: () {
              if (name.text.isEmpty) {
                Toast.show("Name is required!", context);
                return;
              }
              if (phone.text.isEmpty) {
                Toast.show("Name is required!", context);
                return;
              }
              if (desc.text.isEmpty) {
                Toast.show("Name is required!", context);
                return;
              }
              vars.add(name.text);
              vars.add(phone.text);
              vars.add(desc.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return vars;
}

Widget txtField(String hint, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: hint,
        fillColor: Colors.white70),
  );
}

Future<List<String>> editContact(
    BuildContext context, ContactModel contactModel) async {
  List<String> vars = [];
  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController name =
          new TextEditingController(text: contactModel.name);
      TextEditingController phone =
          new TextEditingController(text: contactModel.phone);
      TextEditingController desc =
          new TextEditingController(text: contactModel.desc);
      return AlertDialog(
        title: Text("Create Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            txtField('Name', name),
            SizedBox(
              height: 10,
            ),
            txtField('Phone', phone),
            SizedBox(
              height: 10,
            ),
            txtField('Description', desc),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Create"),
            onPressed: () {
              if (name.text.isEmpty) {
                Toast.show("Name is required!", context);
                return;
              }
              if (phone.text.isEmpty) {
                Toast.show("Name is required!", context);
                return;
              }
              if (desc.text.isEmpty) {
                Toast.show("Name is required!", context);
                return;
              }
              vars.add(name.text);
              vars.add(phone.text);
              vars.add(desc.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return vars;
}

Future<bool> deleteContact(
    BuildContext context, ContactModel contactModel) async {
  bool del = false;
  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete contact"),
        content: Text("Do you want to delete ${contactModel.name}?"),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              del = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return del;
}
