# Homework3

### Packages
- **SwiftLint**
- **SnapKit**

### Project Structure

- **Controllers**
    - `DetailsViewController`: manages the display of student details
    - `FilteredStudentsController`: displays a filtered list of students based on selected subject
    - `ScoresTableViewController`: conrtroller for TabelView inside the DetailCell
    - `StudentListController`: controller for displaying the initial list of students that we parsed from file
- **Models**
    - `Student`: structure representing student data
    - `StudentParser`: responsible for parsing student data and also getting the filtered students
- **Navigation**
    - `Coordinator`: manages navigation between screens
- **Views**
    - `DetailsCell`: cell for displaying student details
    - `ScoresTableView`: tableView for displaying scores inside DetailCell
    - `StudentCell`: cell for displaying student data in the list

### Questions:
1. Is random space on the first screen (about TableView header) because of Coordinator?
2. I pass selectedSubject through StudentDetail, is it a good approach, or should I avoid having DetailCell do anything with selectedSubject?
3. Why for UIImageVie I technically can't have rounded corners and shadow at the same time (for rounded corners I have to have "clipsToBounds = true", and for shadow "false")? Is there away around it? Or you just have to have the separate ShadowView?
4. I have this in console: ```NSBundle file:///Library/Developer/CoreSimulator/Volumes/iOS_22A3351/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS%2018.0.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/MetalTools.framework/ principal class is nil because all fallbacks have failed"```. Why does it appear?

### Sources:
- https://developer.apple.com/documentation (A LOT)
- StackOverflow (I hope all their pillows are always cold)
- https://www.hackingwithswift.com/example-code/uikit/how-to-swipe-to-delete-uitableviewcells
- For add and delete (3 different videos on YouTube)
- Random videos explaining things
- Photos pf my niece, her mother gave me permission :)
- https://books.apple.com/ua/book/develop-in-swift-fundamentals/id6468967906?l=uk (ViewController LifeCycle, TypeCasting and Navigation)
