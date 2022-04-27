# Akcošky

## Preparation

## Scenario

App where user can create an event and others should be able to react to this created event in form of attendance. Basic functions should be: login, register, handling event. Event creation should consist of: name, description, time, location, wanted group 
or selected individuals from specific group. Other users could make some adjustments like change time or change location and other users should be able to vote how they are satisfied with the adjustment. 

## Questions

## Technologies

* Frontend and backend - Flutter (https://flutter.dev/)
  
* Database - Amazon DynamoDB (https://aws.amazon.com/dynamodb/)

* Notifications handler service - Firebase Cloud Messaging (https://firebase.google.com/products/cloud-messaging)


## Time schedule

* 1st week 
  * Project setup
  * Database creation and setup connection
  * Login UI
  * Register UI

* 2nd week
  * Login and Register backend

* 3rd week
  * Groups UI frontend + backend

* 4th week
  * Finishing Groups backend

* 5th week
  * Event creation UI + backend

* 6th week
  * Event list UI, Event detail UI

* 7th week
  * Event interaction of other users

* 8th week
  * Finishing event interactions of other users

* 9th week
  * Catching up with every necessary function from previous weeks

* 10th week
  * Firebase cloud messaging setup + implementation

* 11th week
  * Forget password UI + backend

## Midterm review

I would say, I'm following the plan well enough. I counted with the fact that I will not be able to make it in the 40 hours which will this lessons take because I chose technology I haven't worked with yet. Flutter uses state management system with I haven't work with either. The adaptation was more difficult than I expected. I have worked with the DynamoDB, but through library. This time I had to use low-level API with which I battled a few times too. I don't have to change my plan for now.

## How clean is my code

* to manage widget states I use package named cubit which helps make the code more readable and dependencies are splitted between more cubits
* I would say it could be even better If I would split the dependencies of some selected cubits even more
* I'm using extended repository pattern - presentation layer (UI), business layer (cubit), repository and data source (database)

## Matej's clean code
* I would say Matej's code is not clean. There is some structure which seems OK for me, but I would say there could be a lot of improvements.
* For user who is not familiar with the technology it is hard to read and hard to understand the flow.

