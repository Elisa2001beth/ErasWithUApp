import 'package:eraswithu/data/city.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/views/events_main.dart';
import 'package:eraswithu/model.dart';
import 'package:eraswithu/presenters/presenter_add_university_page.dart';
import 'package:eraswithu/views/i_add_university_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'home.dart';

class AddUniversity extends StatefulWidget {
  final User user;

  const AddUniversity({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _AddUniversityState(user);
}

class _AddUniversityState extends State<AddUniversity>
    implements IAddUniPageView {
  static const String TOP_MSG = 'Where is your University?';
  static const String SELECT_CITY = 'Select City';
  static const String CITY = 'Enter the City Name';
  static const String CITY_ERROR = 'Enter the City';
  static const String CITY_EXITS_ERROR = 'That City already exists';
  static const String UNIVERSITY = 'Enter University Name';
  static const String UNIVERSITY_ERROR = 'Enter the University Name';
  static const String PROCEED_BUTTON = 'Add University';
  static const String ANOTHER_CITY = 'Add a University from Another City';

  final User user;

  _AddUniversityState(this.user);

  late PresenterAddUniversityPage presenter;

  final _citySelectorKey = GlobalKey<FormState>();
  final _universityKey = GlobalKey<FormState>();

  final cityController = TextEditingController();
  final universityController = TextEditingController();

  late List<City> cities = [];

  City? selectedCity;
  String? selectedCityName;

  bool citySelectorVisible = true;
  bool cityWritingVisible = false;
  bool anotherCityButtonVisible = true;

  @override
  bool writingCity = false;
  @override
  bool cityExists = false;

  @override
  initState() {
    super.initState();
    presenter = PresenterAddUniversityPage(this, Model());
    Future.delayed(Duration.zero,() async {
      //your async 'await' codes goes here
      cities = await presenter.getAllCities();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // logo on top
              Container(
                padding: const EdgeInsets.only(top: 100),
                child: SvgPicture.asset("assets/logowithsub.svg"),
              ),

              // message on top
              Container(
                  padding: const EdgeInsets.only(top: 100, bottom: 10),
                  child: const Text(
                    TOP_MSG,
                    style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                        color: Color(0xff0077B6)),
                  )),

              //Dropdown select city
              Visibility(
                visible: citySelectorVisible,
                child: Form(
                  key: _citySelectorKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButtonFormField<String>(
                      validator: (value) => value == null ? '' : null,
                      hint: const Text(SELECT_CITY),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff0077B6), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff0077B6), width: 2),
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

                        setState(() {
                          selectedCityName = city;
                        });
                      },
                    ),
                  ),
                ),
              ),

              //write city
              Visibility(
                visible: cityWritingVisible,
                child: Form(
                  key: _citySelectorKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: cityController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CITY_ERROR;
                        }
                        if (cityExists) {
                          return CITY_EXITS_ERROR;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff0077B6), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: CITY,
                        //hintText: 'Enter your secure password'
                      ),
                    ),
                  ),
                ),
              ),

              //write university
              Form(
                key: _universityKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: universityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return UNIVERSITY_ERROR;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      //contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff0077B6), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: UNIVERSITY,
                    ),
                  ),
                ),
              ),

              //add uni button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0077B6), // backgroung
                      minimumSize: const Size(100, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      )),
                  onPressed: onAddUni,
                  child: const Text(PROCEED_BUTTON),
                ),
              ),

              //another city button
              Visibility(
                visible: anotherCityButtonVisible,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                            width: 2, // the thickness
                            color: Color(0xff0077B6) // the color of the border
                            ),
                        backgroundColor: Colors.white,
                        minimumSize: Size(100, 50),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                    onPressed: onAnotherCityButton,
                    child: const Text(ANOTHER_CITY,
                        style: TextStyle(color: Color(0xff0077B6))),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onAnotherCityButton() {
    presenter.onAnotherCityButton();
  }

  Future<void> onAddUni() async {
    await presenter.onAddUni(
        selectedCity, cityController.text, universityController.text, user);
  }

  //region ViewFunctions
  @override
  void changeVisibilities() {
    setState(() {
      citySelectorVisible = !citySelectorVisible;
      cityWritingVisible = !cityWritingVisible;
      anotherCityButtonVisible = !anotherCityButtonVisible;

      writingCity = !writingCity;
    });
  }

  @override
  bool warnUI() {
    bool b1 = _citySelectorKey.currentState!.validate();
    bool b2 = _universityKey.currentState!.validate();

    return b1 && b2;
  }

  @override
  void toEventsPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home(user: user)));
  }
//endregion
}
