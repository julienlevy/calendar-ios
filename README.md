# calendar-ios
First page of the Sunrise iPhone app, with the calendar view and the agenda view

As it was developped only with demo data, there might be performances issues with real data, specifically with the loading and ordering of saved events.

The pod I installed raises a fatal error if there is no network, so I commented the fatalerror line in SwiftOpenWeatherMapAPI/API/WAPIManager.swift and replaced it with a return
