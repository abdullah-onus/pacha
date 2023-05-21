import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/participants.dart';
import 'package:pacha/pacha_api.dart';

class PeoplePicker extends StatefulWidget {
  const PeoplePicker({Key? key}) : super(key: key);
  @override
  State<PeoplePicker> createState() => _PeoplePickerState();
}

enum Status { none, running, done, error }

class _PeoplePickerState extends State<PeoplePicker> {
  Status status = Status.none;
  List<dynamic> listItems = [];
  final textEditingControllerSearch = TextEditingController();
  IconButton icon = const IconButton(onPressed: null, icon: Icon(Icons.search));
  Set<int> selectedPeople = {};
  List<String> selectedPeopleNames = [];
  int? category;
  List<String> dum = [];
  _userList({String? name, int? category}) {
    status = Status.running;
    PaChaAPI().userList(challenge: Globals.challenge!.id!, name: name, category: category).then((response) {
      Map<String, dynamic> json = (response as Map)['json'];
      setState(() {
        listItems.addAll((json['users'] as List));
        status = Status.done;
      });
    }).onError((error, stackTrace) {
      setState(() {
        listItems.clear();
        status = Status.error;
      });
    });
  }

  _PeoplePickerState() {
    _userList();
  }
  @override
  void dispose() {
    listItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Participants;
    selectedPeople = args.selectedPeople;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      if ((selectedPeople.isEmpty && selectedPeopleNames.isEmpty)) {
                      } else {
                        for (var id in selectedPeople) {
                          for (int i = 0; i < listItems.length; i++) {
                            if (id == listItems[i]['id']) {
                              selectedPeopleNames.add(listItems[i]['fullname']);
                            }
                          }
                        }
                      }
                      Navigator.of(context).pop(selectedPeopleNames);
                      listItems.clear();
                    },
                    icon: const Icon(Icons.check)),
              ],
              leading: IconButton(
                  onPressed: () {
                    listItems.clear();
                    Navigator.of(context).pop(dum);
                  },
                  icon: const Icon(Icons.close)),
              title: Globals.pageIndex == 1
                  ? Text(AppLocalizations.of(context).screenPeoplePickerAppBarTitleText)
                  : Globals.pageIndex == 2
                      ? Text(AppLocalizations.of(context).screenPeoplePickerAppBarTitleText2)
                      : Globals.pageIndex == 3
                          ? Text(AppLocalizations.of(context).screenPeoplePickerAppBarTitleText3)
                          : const Text("")),
          body: status == Status.error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).screenChallengeSelectionLoseInternetConnection,
                          maxLines: 2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
                      Padding(
                          padding: EdgeInsets.all(Constants().padding),
                          child: IconButton(
                            iconSize: Constants().padding * 4,
                            icon: const Icon(
                              Icons.refresh_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                status = Status.running;
                              });
                              _userList();
                            },
                          )),
                    ],
                  ),
                )
              : Column(children: [
                  Padding(
                    padding: EdgeInsets.all(Constants().padding),
                    child: TextFormField(
                      controller: textEditingControllerSearch,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: Constants().padding),
                            child: icon,
                          ),
                          labelText: AppLocalizations.of(context).screenPeoplePickerTextFormFieldLabelTextSearch,
                          border: const OutlineInputBorder()),
                      onChanged: (value) {
                        setState(() {
                          listItems.clear();
                          _userList(name: textEditingControllerSearch.text, category: category);
                          textEditingControllerSearch.text.isEmpty
                              ? icon = const IconButton(onPressed: null, icon: Icon(Icons.search))
                              : icon = IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    textEditingControllerSearch.clear();
                                    listItems.clear();
                                    _userList(name: textEditingControllerSearch.text, category: category);
                                    setState(() => icon = const IconButton(onPressed: null, icon: Icon(Icons.search)));
                                  },
                                );
                        });
                      },
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
                        setState(() {
                          category = value == '' ? null : AppLocalizations.of(context).screenCalendarCategoryList.split(",").indexOf(value!);
                          listItems.clear();
                          _userList(name: textEditingControllerSearch.text, category: category);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Constants().padding, bottom: Constants().padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: Constants().padding, right: Constants().padding),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  for (var person in listItems) {
                                    selectedPeople.remove(person['id']);
                                  }
                                });
                              },
                              child: Text(AppLocalizations.of(context).screenPeoplePickerElevatedButtonTextUncheckAll),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: Constants().padding, right: Constants().padding),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  for (var person in listItems) {
                                    selectedPeople.add(person['id']);
                                  }
                                });
                              },
                              child: Text(AppLocalizations.of(context).screenPeoplePickerElevatedButtonTextSelectAll),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Expanded(
                    child: status == Status.running
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: listItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: Constants().padding),
                                child: CheckboxListTile(
                                    subtitle: Text(AppLocalizations.of(context).screenCalendarCategoryList.split(",")[listItems[index]['category']]),
                                    secondary: CircleAvatar(
                                      backgroundImage: NetworkImage(listItems[index]['avatar']),
                                    ),
                                    title: Text('${listItems[index]['fullname']}'),
                                    onChanged: (key) {
                                      setState(() {
                                        if (key!) {
                                          selectedPeople.add(listItems[index]['id']);
                                        } else {
                                          selectedPeople.remove(listItems[index]['id']);
                                        }
                                      });
                                    },
                                    value: selectedPeople.contains(listItems[index]['id'])),
                              );
                            }),
                  )
                ])),
    );
  }
}
