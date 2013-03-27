var target = UIATarget.localTarget();
target.frontMostApp().tabBar().buttons()["Instructors"].tap();
target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["John Braico"].tap();
target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Comp2150 - Object Orientation"].tap();
