
var target = UIATarget.localTarget();

target.frontMostApp().tabBar().buttons()["Top Rated"].tap();
target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Comp4350 - Software Engineering 2"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.43, y:0.41}});
