# altayerCS
Al Tayyer Case Study. Lists and shows detail products of **Nisnass** application.
Followed **MVVM** architectural pattern.

**[Application Video](https://youtu.be/gqE50MPtSqA)**

## Guide
  You will be able to find:
  - UITest under **AltayerCSUITests**,
  - Unit Tests under **AltayerCSTests**,
  - Some Extension classes and other helper under **Utilities**
  - Whole API Call related classes under **Network**
  - Whole Custom Views including UITableViewCell, UICollectionViewCell etc. under **Views**

## Installation
 1. Download/Clone project
 2. `pod install`
 3. Manage signing, change bundle identifier if needed than run the project.

## Notes About Project

### Why you have selected that design pattern?

 - **ViewModels** are using factory pattern. I don't want let know my UIViewController to whats happening in ViewModels. That is the main reason we seperate them. VC handles UI problems and others in VM.

 - **Providers** are singleton. Because, they consist most important data for the app. I would like to reach from everywhere no data missing. In this example, we have BagProvider that holds what user added his products.

### Which software design principles you have followed in your project?

  - I’ve used single responsibility principles to hold every class has its own issue to solve. In this way, I be able to use each of them in anywhere when needed.

### Any assumptions/comments/notes about any particular decision?

  - In BagProvider, I’ve created observable value to subscribe bags items value change. In that way, I populate badge count of UITabbarItem from BaseVC.

### What would you change if you had more time?

  - Write better UI tests
  - Move some logic from cells to corresponding ViewModels
  - Hold bag data in NSUserdefaults to use in production

### Does your project require any particular tool to be able to run?
  - Cocoapods as dependency manager
