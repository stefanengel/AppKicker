# AppKicker

![](Icon.png)

AppKicker is a macOS application that can restart another app with a specific time interval. Optionally, the restart can be based on conditions.

Currently, two types of conditions are supported:

* Execute a command (that may execute a script) and perform a restart if it returns anything else than 0
* Send a request to an url and perform a restart if it does not return any data

When both conditions are specified, the restart is performed if at least one of them triggers it.

When no conditions are specified, the restart is always triggered.

![](Screenshot.png)

## Why is there an app for that?
Sometimes, you might have a server that runs on macOS and uses special software to provide a service. And sometimes, that software is buggy but there are no alternatives and you cannot fix it by yourself. It might stop working at some random point in time and the service you depend on is not available anymore until you restart that app.

AppKicker is a workaround that allows you to restart a specific app when a certain amount of time has passed. You can also specify conditions to check if the restart is required. A condition might be the availability of a specific website. More specialized conditions can be implemented by running a script.

## How to build
To build AppKicker, you need Carthage and Xcode 10.

Run:
`carthage update --platform Mac`

Then open `AppKicker.xcodeproj` in Xcode and hit `CMD + R`.