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

Acceptance Criteria:

- Vaccination Data is fetched from RKI servers: https://rki-vaccination-data.vercel.app/api
- If data is loaded display it as a list
- If data is being fetched display loading spinner
- If data failed to load, display error message
- Add button allowing toggling between alphabetical order and order based on vaccination progress
- Tapping on an item should display a tapped item in detail view (see screenshot)

Design by Łukasz Designs™:

<img width="240" alt="Screenshot 2021-01-07 at 23 14 07" src="https://user-images.githubusercontent.com/121164/103950969-21b0f700-513e-11eb-9604-eb689984aa09.png"><img width="240" alt="Screenshot 2021-01-07 at 23 14 11" src="https://user-images.githubusercontent.com/121164/103950979-27a6d800-513e-11eb-8e20-114f81bb7170.png">


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

This is what this class looks like in dart:

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

We need to add factory method to parse following json:

```json
{"total": 3644826, "rs": "11", "vaccinated": 24159, "difference_to_the_previous_day": 2204, "vaccinations_per_1000_inhabitants": 6.583746901136969, "quote": 0.66}
```

Let's quickly add that factory and then a test method:

```dart
  factory VaccineStatus.fromJson(Map<String, dynamic> json) {
    return VaccineStatus(
      total: json['total'],
      vaccinated: json['vaccinated'],
      difference_to_the_previous_day: json['difference_to_the_previous_day'],
      quote: json['quote'],
    );
  }
```

```dart
test('json parsing Berlin', () {
    final mock_data_berlin_decoded = jsonDecode(mock_data_berlin);
    final berlinStatus = VaccineStatus.fromJson(mock_data_berlin_decoded);
    expect(berlinStatus.total, 3644826);
    expect(berlinStatus.vaccinated, 24159);
    expect(berlinStatus.quote, 0.66);
  });
```

### Parse the rest of the json

The `VaccineStatus` doesn't contain name of the state, instead the name of the state is used as a key in the json map. This is rather inconvienent but nothing that we cannot handle.

Let's create a class for that:

```dart
class StateEntry {
  StateEntry({this.status, this.name});
  final VaccineStatus status;
  final String name;
}

List<StateEntry> parseResponse(String jsonStr) {
  throw UnimplementedError();
}
```

### Let's write another test for this:

```dart
  test('make a list from json', () {
    final states = parseResponse(full_json);
    expect(states.isNotEmpty, true);
  });
```

### Provide parseResponse implementation

```dart
List<StateEntry> parseResponse(String jsonStr) {
  final json = jsonDecode(jsonStr);
  final statesMap = json["states"] as Map<String, dynamic>;
  return statesMap.keys.map((key) {
    final vaccineStatusJson = statesMap[key];
    return StateEntry(
      status: VaccineStatus.fromJson(vaccineStatusJson),
      name: key,
    );
  }).toList();
}
```

### Let's improve our fetchData method

```dart
Future<List<StateEntry>> fetchData() async {
  final response =
      await http.get('https://rki-vaccination-data.vercel.app/api');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseResponse(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load vaccination data');
  }
}
```

### Wrap our existing body with a FutureBuilder widget

We want to display a loading state for our list, the list or error. We'll use FutureBuilder widget for this (explainer in video below):

[![](https://img.youtube.com/vi/ek8ZPdWj4Qo/0.jpg)](https://www.youtube.com/watch?v=ek8ZPdWj4Qo)


```dart
      body: FutureBuilder<List<StateEntry>>(
        future: fetchData(),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          );
        }
      ),
```

...and remove other fetch from `main`

### Handle respective states

```dart
        FutureBuilder<List<StateEntry>>(
          future: fetchData(),
          builder: (context, snapshot) {
            // an error occured
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'An error occured ${snapshot.error}',
                    ),
                  ],
                ),
              );
            }

            // there's no data yet
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text(
                      'Loading',
                    ),
                  ],
                ),
              );
            }

            // we have data
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'We have data ${snapshot.data}',
                  ),
                ],
              ),
            );
          })
```

### Add ListView widget

We have a list of elements, it would be cool if we displayed them as a scrollable list.

[![](https://img.youtube.com/vi/KJpkjHGiI5A/0.jpg)](https://www.youtube.com/watch?v=KJpkjHGiI5A)

```dart
            // we have data
            final items = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) => Text(items[index].name),
              itemCount: items.length,
            );
```

### Create Dedicated Widget for the list view item

```dart
class StateEntryWidget extends StatelessWidget {
  final StateEntry entry;

  const StateEntryWidget({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(entry.name);
  }
}
```

### Add some more information to the list cell

```dart
class StateEntryWidget extends StatelessWidget {
  final StateEntry entry;

  const StateEntryWidget({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(entry.name),
            Text(
                "${entry.status.vaccinated} out of ${entry.status.total} vaccinted"),
          ],
        ),
        Text("${entry.status.quote}")
      ],
    );
  }
}
```

### Making it look pretty

- [Deep Dive in Rows & Columns](https://medium.com/jlouage/flutter-row-column-cheat-sheet-78c38d242041)
- [Applying Theme to Text](https://flutter.dev/docs/cookbook/design/themes)

[![](https://img.youtube.com/vi/_rnZaagadyo/0.jpg)](https://www.youtube.com/watch?v=_rnZaagadyo)
[![](https://img.youtube.com/vi/CI7x0mAZiY0/0.jpg)](https://www.youtube.com/watch?v=CI7x0mAZiY0)
[![](https://img.youtube.com/vi/oD5RtLhhubg/0.jpg)](https://www.youtube.com/watch?v=oD5RtLhhubg)

```dart
class StateEntryWidget extends StatelessWidget {
  final StateEntry entry;

  const StateEntryWidget({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                    "${entry.status.vaccinated} out of ${entry.status.total} vaccinted"),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${entry.status.quote}%",
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ],
    );
  }
}
```

### Add sorting

We want to be able to sort:
- byName
- byQuota
- byVaccinatedCount

```dart
List<StateEntry> sortByQuotaDesc(List<StateEntry> input) {
  final output = List<StateEntry>.from(input);
  output.sort((a, b) => b.status.quote.compareTo(a.status.quote));
  return output;
}

List<StateEntry> sortByVaccinatedDesc(List<StateEntry> input) {
  final output = List<StateEntry>.from(input);
  output.sort((a, b) => b.status.vaccinated.compareTo(a.status.vaccinated));
  return output;
}

List<StateEntry> sortByNameAsc(List<StateEntry> input) {
  final output = List<StateEntry>.from(input);
  output.sort((a, b) => a.name.compareTo(b.name));
  return output;
}
```

### Make sorting use extension

```dart
extension StateEntrySortingExtensions on List<StateEntry> {
  List<StateEntry> sortedByQuotaDesc() {
    final output = List<StateEntry>.from(this);
    output.sort((a, b) => b.status.quote.compareTo(a.status.quote));
    return output;
  }

  List<StateEntry> sortedByVaccinatedDesc() {
    final output = List<StateEntry>.from(this);
    output.sort((a, b) => b.status.vaccinated.compareTo(a.status.vaccinated));
    return output;
  }

  List<StateEntry> sortedByNameAsc() {
    final output = List<StateEntry>.from(this);
    output.sort((a, b) => a.name.compareTo(b.name));
    return output;
  }
}
```

### Let's toggle sorting mode using floating action button

We need different icons

[Material Icon Set](https://material.io/resources/icons/?style=baseline)

We'll use:

- `sort_by_alpha` for for name sorting
- `accessibility/family_restroom` for vaccinated count sorting
- `trending_up` for quota sorting

Check with hot reload if the icons are there!

### Define enum class for possible sorting types

```dart
enum SortingType { byQuota, byVaccinated, byName }
```

Replace `counter` value with sortingType, add extension method accepting enum:

```dart
  List<StateEntry> sortedBy(SortingType sortingType) {
    switch (sortingType) {
      case SortingType.byQuota:
        return sortedByQuotaDesc();
      case SortingType.byVaccinated:
        return sortedByVaccinatedDesc();
      case SortingType.byName:
        return sortedByNameAsc();
    }
  }
```

Add extension method on enum to display proper tooltip and icon for the floating action button

```dart
extension SortingTypeExt on SortingType {
  IconData get iconData {
    switch (this) {
      case SortingType.byQuota:
        return Icons.trending_up;
      case SortingType.byVaccinated:
        return Icons.family_restroom;
      case SortingType.byName:
        return Icons.sort_by_alpha;
    }
  }

  String get tooltip {
    switch (this) {
      case SortingType.byQuota:
        return "Sort by Percentage";
      case SortingType.byVaccinated:
        return "Sort by Vaccinated Count";
      case SortingType.byName:
        return "Sort by Name";
    }
  }
}
```

Finally make the floating action button callback update widget's state:

```dart
void _switchSortingType() {
    setState(() {
      final nextIndex = SortingType.values.indexOf(sortingType) + 1;
      sortingType = SortingType.values[nextIndex % SortingType.values.length];
    });
  }

floatingActionButton: FloatingActionButton(
        onPressed: _switchSortingType,
        tooltip: sortingType.tooltip,
        child: Icon(sortingType.iconData),
      )
```

### Make items on the list clickable

Wrap item with InkWell and display message saying e.g. `Hello from Berlin!` using SnackBar:

[![](https://img.youtube.com/vi/zpO6n_oZWw0/0.jpg)](https://www.youtube.com/watch?v=zpO6n_oZWw0)

```dart
class StateEntryWidget extends StatelessWidget {
  final StateEntry entry;

  const StateEntryWidget({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Hello from ${entry.name}!")));
      },
      child: Row(
      /// ...
```

### Navigate To Detail View

Create a screen and navigate to it instead of displaying snack bar:
https://flutter.dev/docs/cookbook/navigation/navigation-basics

```dart
class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

```dart
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondRoute()),
  );
}
```

### Send data to a new screen

Pass argument to your new route

```dart
onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondRoute(
              entry: entry,
            ),
          ),
        );
      },
```

Display place name in the app bar:

```dart
class SecondRoute extends StatelessWidget {
  const SecondRoute({Key key, this.entry}) : super(key: key);
  final StateEntry entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.name),
      ),
      /// put any kind of widget you wish here
      body: Placeholder(),
    );
  }
}
```

### Publish your work to codemagic.io as a static page

https://docs.codemagic.io/publishing/publishing-to-codemagic-static-pages/