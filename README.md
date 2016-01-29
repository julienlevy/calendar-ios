# calendar-ios
First page of the Sunrise iPhone app, with the calendar view and the agenda view

New feature – Weather for events in a different city:
I added a new feature, the weather will be displayed for events that are not close to you current position.
Indeed "Morning" and "Afternoon" cells display the weather at the user's current location but you may take a train during your day and go to a city where the weather is different.
Another option would be to track the location of events in each period of the day and display the weather on the period cell accordingly but that might not be perfectly understandable, and it wouldn't work if you have an appointment at midday in Paris and one at 4 in London as they would both be during the afternoon period.
For now the distance criteria I used is 100km.

As it was developed only with demo data, there might be performances issues with real data, specifically with the loading and ordering of saved events.

The pod I installed raises a fatal error if there is no network, so I commented the fatalerror line in SwiftOpenWeatherMapAPI/API/WAPIManager.swift and replaced it with a return.
