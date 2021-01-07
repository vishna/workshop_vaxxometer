## Vaxxometer Workshop, DB, 08/01/2021

### Let's check your flutter environment first:

```
flutter doctor -v
```

### Create new project

```
flutter create vaxxometer
```

### Create a git repository in the new project

```
cd vaxxometer
```

### Open editor of your choice & run the app

<img width="1792" alt="Screenshot 2021-01-07 at 17 44 42" src="https://user-images.githubusercontent.com/121164/103919209-1515aa00-5110-11eb-85c6-6390254b96ce.png">

### Modify contents of the counter to create simple Vaxxometer

AC:

- Vaccination Data is fetched from RKI servers: https://rki-vaccination-data.vercel.app/api
- If data is loaded display it as a list
- If data is being fetched display loading spinner
- If data failed to load, display error message
- Add button allowing toggling between alphabetical order and order based on vaccination progress
- Tapping on an item should display a tapped item in detail view (see screenshot)


#### Change Title of The App Bar

Hot reload and behold.

#### Fetch Data from internet

https://flutter.dev/docs/cookbook/networking/fetch-data

Visit pub.dev, copy paste latest version into your pubspec file.

Don't forget about necessary permissions for the platform you're developing for:

https://stackoverflow.com/questions/61196860/how-to-enable-flutter-internet-permission-for-macos-desktop-app

You might need to cold restart the app after chaning platform stuff.

#### Let's fetch string data from our enpoint

Copy code snippet from this web page (including import)

https://flutter.dev/docs/cookbook/networking/fetch-data

modify it to use our endpoint:

```dart
Future<http.Response> fetchData() {
  return http.get('https://rki-vaccination-data.vercel.app/api');
}

void main() {
  fetchData().then((value) => print(value.body));

  runApp(MyApp());
}
```

__HOT RESTART__ the app and check debug console if the request response is logged:

<img width="1358" alt="Screenshot 2021-01-07 at 18 09 52" src="https://user-images.githubusercontent.com/121164/103922110-99b5f780-5113-11eb-9deb-3613feacb897.png">

### Write class for vaccination data

First inspect the response in json editor to see what you will need:

<img width="614" alt="Screenshot 2021-01-07 at 18 13 46" src="https://user-images.githubusercontent.com/121164/103922653-560fbd80-5114-11eb-8d9c-93c8daedee02.png">

we need a class, e.g. VaccineStatus that has following fields
- total, integer, number of people
- rs, unsure, let's ignore this one
- vaccinated, integer, number of people
- difference_to_the_previous_day, integer, number of people
- quote, float, looks like vaccinations per __100__ people


```dart
class VaccineStatus {
  const VaccineStatus(
      {this.total,
      this.vaccinated,
      this.difference_to_the_previous_day,
      this.quote});
  final int total;
  final int vaccinated;
  final int difference_to_the_previous_day;
  final double quote;
}
```