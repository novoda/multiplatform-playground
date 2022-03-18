# News

This is a News feed application written on Flutter. 

## What this is

This is our first approach on learning Flutter as a team @ Novoda. We are using https://newsapi.org/ as a source for news and the idea is to build a beautiful application that gives the user the possibility of searching and reading news. 
Currently working on the set of functionalities that we want as an MVP

## How we work

We are trying to give this project a sense of real project by:
* Using the current industry coding standards / libraries for writting beautiful Flutter Applications
* We try to leverage team collaboration. Feel free to ask questions whenever you see an opened PR; we can all learn together. 
* We try to keep an eye on security, scalability and testing.

## How can I contribute?

* Add yourself to a watcher for this repository
* Collaborate on Pull Requests whenever possible
* Feel free to take any of the issues marked as `good-first-issue` in the ![project board](https://github.com/novoda/multiplatform-playground/projects/1)

## Development Guidelines:
### Pre-requisites:

* `NEWS_API_KEY`: You have two options:
** a) Get a free API KEY from https://newsapi.org/ then add `NEWS_API_KEY=your-key` on a file named `.secrets_env`
** b) If you are a member of Novoda, request permissions to juanky@novoda.com, after granted run the script `./fetch_secrets.sh`. This will create `.secrets_env` for you.

### On Active Coding:

* We are following ![Trunk Based Development](https://trunkbaseddevelopment.com/) (Perhaps not the most pure approach, but an approximation)
* We are currently trying to use ![BLOC](https://bloclibrary.dev/#/) alongisde with a ![Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html). A good representation of what we want to achieve is described here on the following resources:
** https://resocoder.com/2020/03/09/flutter-firebase-ddd-course-1-domain-driven-design-principles/
** https://dev.to/george_andronchik/clean-architecture-of-flutter-application-part-1-theory-3b6p
* We are trying to actively test our code, using `mockito`: https://pub.dev/packages/mockito
* We are using `retrofit` for implementing `API Clients`: https://pub.dev/packages/retrofit
* We are currently using `GitHub Actions` for the CI

Ideally soon we'll be using:
* `RxDart` as a way of extending the native ![Dart Streams](https://api.dart.dev/stable/dart-async/Stream-class.html): https://pub.dev/packages/rxdart
* `Drift` for the data persistency: https://pub.dev/packages/drift 
* ...

More to be added here as we advance on this project
