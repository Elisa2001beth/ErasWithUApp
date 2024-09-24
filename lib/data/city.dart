class City {
  String name;
  List<String> universities;

  //constructor
  City (this.name, this.universities);

  //functions

  //static functions
  static List<String> GetCitiesNames(List<City> cities){
    List<String> names = [];

    cities.forEach((city) => names.add(city.name));

    return names;
  }
}