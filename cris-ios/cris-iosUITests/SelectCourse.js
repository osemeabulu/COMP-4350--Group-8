
var target = UIATarget.localTarget();

target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Comp2150 - Object Orientation"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.37, y:0.42}});

