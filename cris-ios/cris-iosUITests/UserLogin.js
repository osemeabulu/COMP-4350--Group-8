
var target = UIATarget.localTarget();
target.frontMostApp().tabBar().buttons()["User"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.21, y:0.03}});
target.frontMostApp().keyboard().typeString("test");
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.23, y:0.07}});
target.frontMostApp().keyboard().typeString("password");
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.45, y:0.05}});
// Alert detected. Expressions for handling alerts should be moved into the UIATarget.onAlert function definition.
//target.frontMostApp().alert().cancelButton().tap();
