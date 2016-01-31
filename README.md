# calendar-ios
First page of the Sunrise iPhone app, with the calendar view and the agenda view

New feature – Weather for events in a different city:
I added a new feature, the weather will be displayed for events that are not close to you current position.
Indeed "Morning" and "Afternoon" cells display the weather at the user's current location but you may take a train during your day and go to a city where the weather is different.
Another option would be to track the location of events in each period of the day and display the weather on the period cell accordingly but that might not be perfectly understandable, and it wouldn't work if you have an appointment at midday in Paris and one at 4 in London as they would both be during the afternoon period.
For now the distance criteria I used is 100km.

I also implemented a quick onboarding design if you click on the design icon in the navigation bar.
I only did the second half of the onboarding, about connecting and setting up the user, not the first part about letting the user dive into sunrise's universe.
I changed the connect with email (you may use registered@email.com to try an already registered account), and how authorizations are asked.

As it was developed only with demo data, there might be performances issues with real data, specifically with the loading and ordering of saved events.

The pod I installed raises a fatal error if there is no network, so I commented the fatalerror line in SwiftOpenWeatherMapAPI/API/WAPIManager.swift and replaced it with a return.

There seem to be a bug with UICollectionView's methods scrollToItem for the UIScrollPosition.Top (slight offset, if you use .None which picks between .Top and .Bottom there is always a problem in the top direction only) so I scrolled the collectionView to .Bottom all the time even though it makes much more sense to display the days to some by default than the past days.
