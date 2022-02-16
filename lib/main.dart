import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'eth.dart';
import 'widgets.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: ContactsApp(),
  ));
}

class ContactsApp extends StatefulWidget {
  @override
  _ContactsAppState createState() => _ContactsAppState();
}

class _ContactsAppState extends State<ContactsApp> {
  late List<ContactModel> contacts;
  late ContactsApi contactsApi;
  bool loading = true;

  getAllContacts() async {
    setState(() {
      loading = true;
    });
    contactsApi = new ContactsApi();
    List<ContactModel> cs = await contactsApi.getAllContacts();
    setState(() {
      contacts = cs;
      loading = false;
    });
  }

  @override
  void initState() {
    getAllContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(
          child: Text(
            "Contacts",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
      body: Container(
        width: w,
        height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * .07,
            ),
            addButton(),
            renderContacts(),
            SizedBox(
              height: h * .03,
            ),
          ],
        ),
      ),
    );
  }

  Widget addButton() {
    return GestureDetector(
      onTap: () async {
        List<String> vars = await createNewContact(context);
        if (vars.length > 0) {
          await contactsApi.createContact(vars[0], vars[1], vars[2]);
          getAllContacts();
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        height: 40,
        width: MediaQuery.of(context).size.width * .4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            Spacer(),
            Text("Add Contact"),
            Spacer(),
            Icon(Icons.add),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget renderContacts() {
    if (!loading) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: contacts.length > 0
              ? Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(width: 2.0, color: Colors.grey),
                  children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.grey),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Name",
                                textScaleFactor: 1,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Phone",
                                textScaleFactor: 1,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Description",
                                textScaleFactor: .8,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Remove",
                                textScaleFactor: 1,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Edit",
                                textScaleFactor: 1,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                      for (ContactModel contac in contacts)
                        contactItemVeiw(contac)
                    ])
              : Center(
                  child: Text("No contacts yet!"),
                ));
    } else {
      return Container(
          margin: EdgeInsets.only(
              top: 40, left: MediaQuery.of(context).size.width * .48),
          width: 30,
          height: 30,
          child: Center(child: CircularProgressIndicator()));
    }
  }

  TableRow contactItemVeiw(ContactModel contactModel) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          contactModel.name!,
          textScaleFactor: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          contactModel.phone.toString(),
          textScaleFactor: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          contactModel.desc!,
          textScaleFactor: 1,
        ),
      ),
      GestureDetector(
          onTap: () async {
            bool del = await deleteContact(context, contactModel);
            if (del) {
              await contactsApi.deleteContact(contactModel);
              getAllContacts();
            }
          },
          child: Icon(Icons.delete)),
      GestureDetector(
          onTap: () async {
            List<String> editContactsVar =
                await editContact(context, contactModel);
            if (editContactsVar.length > 0) {
              if (editContactsVar[0] != contactModel.name ||
                  editContactsVar[1] != contactModel.phone ||
                  editContactsVar[2] != contactModel.desc) {
                contactModel.name = editContactsVar[0];
                contactModel.phone = editContactsVar[1];
                contactModel.desc = editContactsVar[2];
                var res = await contactsApi.editContact(contactModel);
                getAllContacts();
              }
            }
          },
          child: Icon(Icons.edit)),
    ]);
  }
}

class ContactModel {
  BigInt? id;
  String? name, phone, desc;
  ContactModel(var res) {
    id = res[0];
    name = res[1];
    phone = res[2];
    desc = res[3];
  }
}
