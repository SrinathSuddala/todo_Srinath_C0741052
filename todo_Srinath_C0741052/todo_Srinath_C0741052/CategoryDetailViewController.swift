
import UIKit

class CategoryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(saveTapped))
        // Do any additional setup after loading the view.
    }
    
    @objc func saveTapped() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
