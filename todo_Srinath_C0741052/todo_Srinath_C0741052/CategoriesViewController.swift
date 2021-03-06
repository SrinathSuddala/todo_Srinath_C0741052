
import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var categoryTable: UITableView!
    var categories: [Category] = []
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isFromNotesDetails: Bool = false
    var selectedCategoryUuid: UUID?
    var onCategorySelected: ((Category)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        
        categoryTable.register(UITableViewCell.self,
                               forCellReuseIdentifier: "Cell")
        if !isFromNotesDetails {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = fetchCategories()
        categoryTable.reloadData()
    }
    
    func fetchCategories() -> [Category] {
        guard let categories = try? appdelegate.persistentContainer.viewContext.fetch(Category.fetchRequest() as NSFetchRequest<Category>) else {
            return []
        }
        return categories
    }
    
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryDetailViewController") as! CategoryDetailViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


extension CategoriesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    
    return categories.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.title
        if category.uuid == selectedCategoryUuid {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromNotesDetails {
            selectedCategoryUuid = categories[indexPath.row].uuid
            tableView.reloadData()
            onCategorySelected?(categories[indexPath.row])
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
            viewController.selectedCategory = categories[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
