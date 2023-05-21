import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReadOnly extends StatefulWidget {
  const ReadOnly({Key? key}) : super(key: key);
  @override
  State<ReadOnly> createState() => _PeoplePickerState();
}

class _PeoplePickerState extends State<ReadOnly> {
  List<String> mert = [
    'http://thecaretta.com/model/photo-1.jpg',
    'http://thecaretta.com/model/photo-2.jpg',
    'http://thecaretta.com/model/photo-3.jpg',
    'http://thecaretta.com/model/photo-4.jpg',
    'http://thecaretta.com/model/photo-5.jpg',
    'http://thecaretta.com/model/photo-6.jpg',
    'http://thecaretta.com/model/photo-7.jpg',
    'http://thecaretta.com/model/photo-8.jpg',
    'http://thecaretta.com/model/photo-9.jpg',
    'http://thecaretta.com/model/photo-10.jpg',
    'http://thecaretta.com/model/photo-11.jpg',
    'http://thecaretta.com/model/photo-12.jpg',
  ];
  List<Map> people = [
    {'id': 1, 'name': "Emir"},
    {'id': 2, 'name': "Apo"},
    {'id': 3, 'name': "Mert"},
    {'id': 4, 'name': "Talha"},
    {'id': 5, 'name': "Kivanc"},
    {'id': 6, 'name': "Omer"},
    {'id': 7, 'name': "Berkay"},
    {'id': 8, 'name': "Burak"},
    {'id': 9, 'name': "Abuzer"},
  ];
  Set<int> selectedPeople = {};
  String? occupation;
  final _isconfirmation = 2;
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear_outlined)),
              title: const Text("Physical Event Participant")),
          body: Column(children: [
            Padding(
              padding: EdgeInsets.all(Constants().padding),
              child: TextFormField(
                controller: myController,
                onChanged: (text) {},
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: Constants().padding),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            myController.text = "";
                          });
                        },
                      ),
                    ),
                    labelText: "Search",
                    border: const OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Constants().padding, right: Constants().padding),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                items: AppLocalizations.of(context).screenCalendarCategoryList.split(",").map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: AppLocalizations.of(context).screenCalendarCategoryFieldText),
                onChanged: (String? value) {
                  setState(() => occupation = value);
                },
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: people.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: Constants().padding),
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(mert[index]),
                            ),
                            title: Text('name $index'),
                            trailing: _isconfirmation == 0
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : _isconfirmation == 1
                                    ? const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.access_time_outlined,
                                        color: Colors.yellow,
                                      )));
                  }),
            )
          ])),
    );
  }
}
