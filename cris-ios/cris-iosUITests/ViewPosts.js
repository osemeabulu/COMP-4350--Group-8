
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

target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.84, y:0.14}});
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.59, y:0.14}});
target.frontMostApp().mainWindow().elements()[0].tapWithOptions({tapOffset:{x:0.26, y:0.14}});
target.frontMostApp().tabBar().buttons()["Posts"].tap();
target.frontMostApp().mainWindow().segmentedControls()[0].buttons()["My Posts"].tap();
target.frontMostApp().mainWindow().segmentedControls()[0].buttons()["Following"].tap();
target.frontMostApp().mainWindow().segmentedControls()[0].buttons()["Followed"].tap();
target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().navigationBar().leftButton().tap();

