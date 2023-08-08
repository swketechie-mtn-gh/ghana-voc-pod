To use the `DigiModule` library for iOS, add `DigiModule` repo:  
```
pod repo add DigiModule https://github.com/swketechie-mtn-gh/ghana-voc-pod
```


Add dependency `pod 'DigiModule'` to the `Podfile` file:
```
source 'https://github.com/swketechie-mtn-gh/ghana-voc-pod.git'

target '<Project_target>' do
  use_frameworks!
  pod 'DigiModule'

end

```

In `AppDelegate` add initialization of `DigiModule`: 

```
import UIKit
import DigiModule

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DigiModule.shared.initialization(urlString: "<link to the runner script>")
        
        return true
    }
}
```

`urlString` - link to the runner script 

When you need to show the survey screen, call the `DigiModule.shared.show()` with proper arguments:

```
import UIKit
import DigiModule

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func buttonPressed(_ sender: Any) {
        DigiModule.shared.show(surveyId: 4536,
                               language: "en",
                               params: ["param1": 1, "param2": "two", "param3": true],
                               margins: Margins(top: 10, right: 10, left: 10, bottom: 10),
                               presentationController: self)
    }
}
```

`surveyId`, `language` - is required

`params` - optional (additional params for questionnaire, for example some metadata etc)

`margins` - optional. Margins for the questionnaire window. Default margins `top: CGFloat = 10, right: CGFloat = 10, left: CGFloat = 10, bottom: CGFloat = 10`

`presentationController` - presentationController to start DigiModule view


