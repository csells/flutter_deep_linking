# Flutter Deep Linking sample
This sample app shows off current best practices for handling deep linking, navigation and routing when using Flutter, including the web, where you have to worry about people editing route names
directly in the address bar.

This code also has [a blog post](https://sellsbrothers.com/understanding-flutter-deep-links-on-the-web) that describes the principles used to produce it. I recommend starting there.

## Demo
You can try this sample app [here](https://csells.github.io/flutter_deep_linking/).

## Files
- **main.dart**: where the page widgets are defined, e.g. `PersonPage`
- **routing.dart**: where the app-specific routing is defined, e.g. `AppRouteConfig`
- **data.dart**: the simple data model that goes with this app

## Usage
To take advantage of this code, I recommend coping `routing.dart` into your project, tailoring it to fit your routable pages and then using those classes to `MaterialApp.router`.

Enjoy.

# TODO
- take the # out of the URL
- test different route groups, e.g. not logged in vs. logged in
- test async id => object lookup
- make routing a separate package
- BUG: navigating back too fast crashes
