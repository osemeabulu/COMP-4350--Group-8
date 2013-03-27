
var target = UIATarget.localTarget();

target.frontMostApp().tabBar().buttons()["User"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.20, y:0.03}});
target.frontMostApp().keyboard().typeString("test");
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.21, y:0.07}});
target.frontMostApp().keyboard().typeString("password");
target.tap({x:722.00, y:976.00});
target.tap({x:740.00, y:981.00});
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.46, y:0.05}});
// Alert detected. Expressions for handling alerts should be moved into the UIATarget.onAlert function definition.
//target.frontMostApp().alert().cancelButton().tap();
target.frontMostApp().tabBar().buttons()["Courses"].tap();
target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Comp4350 - Software Engineering 2"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.85, y:0.35}});
target.frontMostApp().mainWindow().pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.62, y:0.73}});
target.frontMostApp().mainWindow().textViews()[0].tapWithOptions({tapOffset:{x:0.27, y:2.89}});
target.frontMostApp().keyboard().typeString("Review text.?.?.?");
target.tap({x:728.00, y:975.00});
target.tap({x:733.00, y:984.00});
target.frontMostApp().mainWindow().buttons()["Create"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.23, y:0.51}});
target.frontMostApp().mainWindow().pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.61, y:0.73}});
target.frontMostApp().mainWindow().buttons()["likeButton"].tap();
target.frontMostApp().mainWindow().buttons()["Save Changes"].tap();
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.26, y:0.51}});
target.frontMostApp().mainWindow().buttons()["Delete"].tap();
