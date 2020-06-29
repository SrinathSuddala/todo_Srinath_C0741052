

import UIKit

class TaskDetailsViewController: UIViewController {

    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskNuberOfDaysTextField: UITextField!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    var selectedCategory: Category?
    var selectedTask: Task?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        
        taskDescriptionTextView.layer.borderColor = UIColor.black.cgColor
        taskDescriptionTextView.layer.borderWidth = 1.0
        taskDescriptionTextView.layer.cornerRadius = 5.0
        
        selectCategoryButton.layer.borderColor = UIColor.black.cgColor
        selectCategoryButton.layer.borderWidth = 1.0
        selectCategoryButton.layer.cornerRadius = 5.0
        
        showSelectedTaskDetails()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        viewController.isFromNotesDetails = true
        viewController.selectedCategoryUuid = selectedTask?.category?.uuid
        viewController.onCategorySelected = { category in
            self.selectedCategory = category
            self.selectCategoryButton.setTitle(category.title, for: UIControl.State())
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSelectedTaskDetails() {
        guard let task = selectedTask else {
            selectCategoryButton.isHidden = true
            return
        }
        selectCategoryButton.isHidden = false
        taskTitleTextField.text = task.title
        taskDescriptionTextView.text = task.desc
        taskNuberOfDaysTextField.text = "\(task.numberOfDays)"
        if let category = task.category {
            selectCategoryButton.setTitle(category.title, for: UIControl.State())
        } else {
            selectCategoryButton.setTitle("Select Category", for: UIControl.State())
        }
    }
    
    @objc func saveTapped() {
        guard let title = taskTitleTextField.text, let desc = taskDescriptionTextView.text, let numberofDays = taskNuberOfDaysTextField.text else { return }
        let task = selectedTask == nil ? Task(context: appdelegate.persistentContainer.viewContext) : selectedTask!
        task.title = title
        task.desc = desc
        task.category = selectedCategory
        task.numberOfDays = Int64(numberofDays) ?? 0
        if task.dateCreated == nil {
            task.dateCreated = Date()
        }
        if selectedTask == nil {
            appdelegate.persistentContainer.viewContext.insert(task)
        }
        try? appdelegate.persistentContainer.viewContext.save()
        self.navigationController?.popViewController(animated: true)
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
