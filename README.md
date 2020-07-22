# CoreDataCodables

Swift demo app that demonstrates models that are codables and ready to be used in core data.

## Overview

This sample project demonstrates Codable models that are modified to be used in core data. This project consumes data in the Github users API and saves it in the core data.  This app has the capabilities to work offlin if data has been previously loaded.

## Build and Runtime Requirements

  * Xcode 11.x.x
  * iOS 13.5
  
 ## Written in
 
  * Swift 5.1
  * MVVM

## Cocoapods used(links for reference)

  * Reachability  : https://cocoapods.org/pods/Reachability
  * SkeletonView  : https://cocoapods.org/pods/SkeletonView
  
## Features

  * APIManager          : handles the API Consumption.
  
  * CoreDataManager     : handles all the functionalities in Creating, Reading, Updating and deleting managed objects in core data.
  
  * ReachabiliyHandler  : observes if app has network or not.
  
  * UserList            : Shows the list of github users.
  
  * UserProfile         : Shows the profile of the selected github user.
