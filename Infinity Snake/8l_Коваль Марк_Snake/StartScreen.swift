import UIKit

final class StartScreen: UIViewController {
    
    @IBOutlet weak var green: UIView!
    
    override func viewDidLoad() {
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .repeat) {
            self.green.alpha = 0
        }
        
    }
}
