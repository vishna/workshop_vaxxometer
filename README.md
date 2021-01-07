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