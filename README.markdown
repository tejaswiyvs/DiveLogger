**README**
-----------

This is an app that lets you log your scuba dives while complying with the standards that various certification agencies like NAUI / PADI require. Current solution seems to be to buy books / add pages and carry them around to show to dive shops if they ask for a log of your dives. This obviously makes it much much easier.

This is currently part of a challenge I threw down for myself called the "OneDayApp". As you might've guessed, I am (was) looking to go from scratch to a fully functioning app in a day. The code quality therefore took a hit as I was pretty much coding in the evenings - late night. I'll work on cleaning the code up as soon as I can get a decent looking app out to the App Store. 

From a technical perspective, here's what it does:

 - `Home` - Initial screen with a list of all the dives in a UITableView. 
 - `DiveMap` - Plots all your dives on a MKMapView.

The two screens above are a part of UITabBarController. 

 - `DiveDetails` - Screen that lets you add details of your dive.
 - `DiveLocationPicker` - Displays a map on which the user can press & hold to drop a pin indicating their dive.

 - `Dive` - Model object for dive
 - `Tank` - Model object indicating a diving tank.

 - `Utils/` - Holds general utilities used as a part of the project