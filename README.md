# petTracker
Pet Tracker is an app created to help a pet owner keep track of all tasks related to their pets.
Ideally it would send notifications to user to complete a task.

Pet Tracker is run on iOS 9.3
* Most preferably iPhone 5 and up.
  * Layout not pretty on iPad


## Requirements met
* Has a storyboard with 4 meaningful view controllers connected by segues
* Has Login Screen that authenticates user (does not have to be to server)
* Uses GCD for multi-threaded operations
  * Dispatch off of main thread, so that it doesn't become blocked.
* Uses Alert pattern
  * If there is a mistake done by user, the user is alerted.
* Uses Action Sheet pattern
  * Action sheet pattern is used in our task view so user can view description of task.
* Uses animation
  * Upon login, the user is showed a loading spinner, to indicate the process of logging in.
* Uses UITableView or UICollectionView to display array of data
  * UITableView is used to show the user's pets, as well as the tasks of that pet.
* Uses UIScrollView
  * This is used in UITableView, which allows user to scroll through pets/tasks if there is more than what can be seen on the screen.

## Extra Credit
* Uses server to support application
  * We use a server to keep all of our users, their pets, and each pets tasks.
* Implements UINavigationController
  * Helps make it easy for user to navigate app.
