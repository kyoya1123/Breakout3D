/*:
 # Breakout3D
 
 Hi! I'm **Kyoya Yamaguchi**, a student of MITA International School, Japan. I've devoted to iOS development since I was 13. Last year, I found that the `ARKit` is awesome. So I created `Breakout` using AR. This is much more harder than a normal breakout. Hope you like this!

 # Tutorial
 
 After tapping the `Run My Code` button, look forward and wait a moment. Once a stage appeared, you can launch ball by tapping screen.
 Then, use your device as a reflector and break all the blocks!
 You can go closer to the blocks but it is high risk.
 You have only **3** balls, so don't waste.
 
 ## Notice
 
 * I recommend you run this game in a **full screen + landscape** mode and **stand up!**
 
 */

//: [Next Page](@next)

//#-hidden-code
import UIKit
import PlaygroundSupport

let viewController = ClassicViewController()

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
