# SunWeb coding challenge

## How to install the project

- Clone the repository on your computer, 
- Go inside the *TestSunWeb* folder and run pod install.
- Open the *TestSunWeb.xcworkspace* file with Xcode.
- Go to the *TestSunWeb* target, click on *Signin & Capabilities*, change the *Team* and *Bundle Identifier*.
- Run the project.

# The project

This project has been integrated with *XCode 12.4*.

## Design Pattern

To do this project, I've choosed MVVM design pattern.

The idea is simple, every ViewController, has its own ViewModel. The ViewModel processes the data, and when it finishes, notifies the ViewController via Protocols that it has to update it's UI.

# Files in the project

# UI

# ViewControllers and ViewModels

## LoadingVC

VC that takes up the whole screen using constraints based on the device screen size, and always checks if there is another instance of itself in so as to not overlap.

## Navigation

File in charge of the navigation inside the App, when the App starts, sets the desired root VC (in this case, fakeSplashVC).

## BaseVC

Father of all VCs, it contains common methods, that can be reusable, like "startWaiting", "stopWaiting", "showPopup", etc... All the other VCs have to heredate from this VC.

## FakeSplashVC

This file acts like a splash screen, showing an activity indicator while it's ViewModel the data from the API.


## FakeSlashVM

Loads the data from the API using concurrent API calls, and notifies the FakeSplashVC via protocol oriented programming, when the loading is done.

It first loads all the airlines airlines from the API, and replaces all the airlines in the local storage, from the airlines that it got from the API.
Then it loads the flights, from the API, and compares them with the ones that are in the local storage, and processes them. Then, when all the processing is done,
it notifies the FakeSplashVC.

## HomeVC

ViewController that has a UITableView, which contains 2 sections. One section containing a list of outbound flights and an another section wich containts a list
of inboundFlights. It also shows a view indicating the route price, if available.

## HomeVM

File in charge of processing all the selected outbound flights and inbound flights, and to return the calculated route price of the selected route. If the
app is started for the first time, it automatically selects the cheapest outbound flight and its related cheapest inbound flight. Then, if the user "kills"
the App, it sets his previous selected outbound and inbound flights.

## AirlineVC

ViewController that shows the detail of the airline chosen in HomeVC.  It contains a UITableView with 3 sections:

- Top Section: Section that shows two images: one with the airline's logo, and another image that contains a photo of the company's plane.
- Headline Section: Section showing the headline of the airline (a short description of who they are, or what you can expect from them).
- Description Section: Section showing the detailed description of the airline.

## AirlineVM

ViewModel in charge of loading the airline information from the local storage. It has one method:

- loadData: requests the airline's information from the local storage, and sets this information to its private attribute. Then it has other public getter
attributes that return that information in order to be displayed in the AirlineVC.

# Components

## Toast

Simple view that shows the selected route price.

## Section Header

Simple view that is used to display the header of each section in the HomeVC, to differentiate between outbound flights and inbound flights.

## FlightTVC

UITableViewCell that displays the flight departure airport code, the arrival airport code, the airline, and the price of the flight.

## TopTVC

UITableViewCell that is placed in the first section of the AirlineVC. It shows an image containing the logo of the Airline, and another image containing the 
airline's plane.

## HeaderTVC

UITableViewCell that shows the headline of the Airline.

## DescriptionTVC

UITableViewCell that shows the description of the Airline.

# Helpers, SubClasses and Enums

## Enums

Type to display custom error messages.

# Utils

## UIView+Utils

Extiension of the UIView class, that adds a method called *addConstraints*, that makes a given view, have the same size of another given view.

## String+Utils

Extension of the String class, that adds a method called *localized*, which returns a localized string in the *Localizable.strings* file.

# Networking Layer

## APIClient

File with a method that does a generic API Call in order to leave the network layer as simple and as scalable as possible. When you call this method, 
you must specify the model that will be used to decode the json object that the API will return and wich this method will return.

## APIRouter

Enum to construct all the urls and its parameters, in the most reusable and scalable way.

## MockAPI

Class that is used to mock the API, until the Back-End team finishes building the real API.

## flights.json

File to mock the flights that will come from the API once completed.

## airlines.json

File to mock the airlines that will come from the API once completed.

## Flights Model

The Flights object model, used to decode the json object that the API returns.

## Airlines Model

The Airlines object model, used to decode the json object that the API returns.

# Resources

## Localizable.strings

File containing all the literals of the App.

# Constants

## UI

User interface related constants.

## API

SunWeb's API related constants.

## Core Data



# Unit Tests

## TestFakeSplashVM 

Class that tests all the concurrent API calls that the App does to the Mock API in order to load the flights and the airlines. It tests that the FakeSplashVM has the correct behaviour, and processes the correct data.

## TestHomeVC

Class that tests all of the different components of the HomeVC, making sure that the HomeVC has the right amount of sections, that has the correct literals, and that all the sections and its TableViewCells, render properly. 

## TestHomeVM

Class that tests, that the HomeVM processes the correct data when the user selects one outbound flight.

## TestHomeVMInbound

Class that tests, that the HomeVM processes the correct data when the user selects one inbound flight.

## TestHomeVMNoInbound

Class that tests, that the HomeVM processes the correct data when the user selects one outbound flight, that doesn't have any possible related inbound flights.

## TestAirlineVC

Class that tests all of the different components of the AirlineVC, making sure that the AirlineVC has the right amount of sections, that has the correct literals, and that all the sections and its TableViewCells render properly.

## TestAirlineVM

Class that tests that the AirlineVM behaves as expected whether one correct airline is selected or an incorrect airline is selected.

# Third Party Libraries

## Kingfisher

I used Kingfisher in order to make image managment and caching much easier and efficient.
