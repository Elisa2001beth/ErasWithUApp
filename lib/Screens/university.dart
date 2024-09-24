import 'dart:ui';

import 'package:eraswithu/Screens/add_university_screen.dart';
import 'package:eraswithu/data/city.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/views/events_main.dart';
import 'package:eraswithu/model.dart';
import 'package:eraswithu/presenters/presenter_university_page.dart';
import 'package:eraswithu/views/i_university_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'home.dart';

class MyUniversity extends StatefulWidget {
  const MyUniversity({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyUniversity> createState() => _MyUniversityState(user);
}

class _MyUniversityState extends State<MyUniversity>
    implements IUniversityPageView {
  late PresenterUniversityPage presenter;

  late List<City> cities = <City>[];
  late List<String> universities;

  City? selectedCity;
  String? selectedCityName;
  String? selectedUniversity;

  final User user;

  _MyUniversityState(this.user);

  final _cityKey = GlobalKey<FormState>();
  final _universityKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    presenter = PresenterUniversityPage(this, Model());
    Future.delayed(Duration.zero,() async {
      //your async 'await' codes goes here
      cities = await presenter.getAllCities();
      setState(() {});
    });
    universities = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 110),
            child: SvgPicture.asset("assets/logowithsub.svg"),
          ),
          Container(
              padding: const EdgeInsets.only(top: 100, bottom: 10),
              child: const Text(
                'University Selection',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    color: Color(0xff0077B6)),
              )),

          // City Dropdown
          Form(
            key: _cityKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                validator: (value) => value == null ? '' : null,
                hint: const Text('Select City'),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff0077B6), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff0077B6), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorStyle: const TextStyle(height: 0),
                ),
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    color: Color(0xff0077B6)),
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                value: selectedCityName,
                isExpanded: true,
                items: City.GetCitiesNames(cities).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (city) {
                  selectedCity = presenter.getCityByName(city!);
                  selectedCityName = city;

                  universities = selectedCity!.universities;
                  setState(() {
                    selectedUniversity = null;
                    selectedCityName = city;
                  });
                },
              ),
            ),
          ),

          // University Dropdown
          Form(
            key: _universityKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                validator: (value) => value == null ? '' : null,
                hint: const Text('Select University'),
                decoration: InputDecoration(
                  // contentPadding: const EdgeInsets.all(1.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff0077B6), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff0077B6), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorStyle: const TextStyle(height: 0),
                ),

                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    color: Color(0xff0077B6)),
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                value: selectedUniversity,
                isExpanded: true,
                items: universities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (province) {
                  setState(() {
                    print(province);
                    selectedUniversity = province;
                  });
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0077B6),
                  minimumSize: const Size(100, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              onPressed: onProceedClicked,
              child: const Text('Proceed'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                      width: 2, // the thickness
                      color: Color(0xff0077B6) // the color of the border
                      ),
                  backgroundColor: Colors.white,
                  minimumSize: const Size(100, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              onPressed: onAddUniButton,
              child: const Text('Add Missing University',
                  style: TextStyle(color: Color(0xff0077B6))),
            ),
          ),
        ],
      )),
    ));
  }

  onProceedClicked() {
    presenter.onProceedClicked(selectedCity, selectedUniversity, user);
  }

  void onAddUniButton() {
    presenter.onAddUniButton();
  }

  //region View Functions
  @override
  toEventsPage(User user, City city) {
    //print("To next Screen with user: ${user.name} and city: ${city.name}");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home(user: user)));
  }

  @override
  bool warnUIEmptyData() {
    bool b1 = _cityKey.currentState!.validate();
    bool b2 = _universityKey.currentState!.validate();

    return b1 && b2;
  }

  @override
  void toAddUniPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddUniversity(user: user)));
  }
  //endregion
}
