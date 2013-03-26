
var target = UIATarget.localTarget();

target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Comp2150 - Object Orientation"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.88, y:0.35}});
target.frontMostApp().mainWindow().pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.67, y:0.89}});
target.frontMostApp().mainWindow().textViews()[0].tapWithOptions({tapOffset:{x:0.33, y:2.74}});
target.frontMostApp().keyboard().typeString("Some review description text.?.?.? ");
target.frontMostApp().mainWindow().buttons()["Create"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
