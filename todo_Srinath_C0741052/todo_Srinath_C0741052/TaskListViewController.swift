

import UIKit
import CoreData

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var taskListTableView: UITableView!
    var tasks: [Task] = []
    var selectedCategory: Category!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    var isArchivedCategory: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        isArchivedCategory = selectedCategory.title == "Archived"
        taskListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        if isArchivedCategory {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        }
        // Do a ny additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = fetchTasks()
        taskListTableView.reloadData()
    }
    
    func fetchTasks() -> [Task] {
        guard let tasks = try? appdelegate.persistentContainer.viewContext.fetch(Task.fetchRequest(with: selectedCategory.uuid!) as NSFetchRequest<Task>) else {
            return []
        }
        return tasks
    }
    

    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        viewController.selectedCategory = selectedCategory
        self.navigationController?.pushViewController(viewController, animated: true)
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

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        viewController.selectedCategory = selectedCategory
        viewController.selectedTask = tasks[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isArchivedCategory
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            self.performEditAction(at: indexPath)
        }
        let addAction = UIContextualAction(style: .normal, title: "Add") { (action, view, handler) in
            self.performAddAction(at: indexPath)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.deleteTask(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, addAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func performAddAction(at indexPath: IndexPath) {
        taskListTableView.beginUpdates()
        let task = tasks[indexPath.row]
        task.numberOfDays += 1
        taskListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        try? appdelegate.persistentContainer.viewContext.save()
        taskListTableView.endUpdates()
    }
    
    func performEditAction(at indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        viewController.selectedCategory = selectedCategory
        viewController.selectedTask = tasks[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        taskListTableView.beginUpdates()
        let task = tasks[indexPath.row]
        move(task: task)
        tasks.remove(at: indexPath.row)
        taskListTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        taskListTableView.endUpdates()
    }
    
    func move(task: Task) {
        if let categories = try? appdelegate.persistentContainer.viewContext.fetch(Category.fetchRequest(with: "Archived") as NSFetchRequest<Category>), categories.count > 0  {
            task.category = categories[0]
            try? appdelegate.persistentContainer.viewContext.save()
        } else {
            let category = Category(context: appdelegate.persistentContainer.viewContext)
            category.title = "Archived"
            category.uuid = UUID()
            appdelegate.persistentContainer.viewContext.insert(category)
            task.category = category
            try? appdelegate.persistentContainer.viewContext.save()
            
        }
    }
    
    func color(for task: Task) -> UIColor {
        guard let currentDate = task.dateCreated else { return .clear }
        if isArchivedCategory {
            return .clear
        }
        var dateComponent = DateComponents()
        dateComponent.day = Int(task.numberOfDays)
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: futureDate).day
        switch diffInDays! {
        case Int.min ... -1:
            return .red
        case 0 ... Int.max :
            return .green
        default:
            return .clear
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = tasks[indexPath.row].title
        cell.backgroundColor = color(for: tasks[indexPath.row])
        return cell
    }
}

extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tasks = fetchNotes(with: searchText)
        taskListTableView.reloadData()
    }
    
    func fetchNotes(with text: String) -> [Task] {
        if text.isEmpty {
            guard let tasks = try? appdelegate.persistentContainer.viewContext.fetch(Task.fetchRequest(with: selectedCategory.uuid!) as NSFetchRequest<Task>) else {
                return []
            }
            return tasks
        } else {
            guard let tasks = try? appdelegate.persistentContainer.viewContext.fetch(Task.fetchRequest(with: text, categoryUuid: selectedCategory.uuid!) as NSFetchRequest<Task>) else {
                return []
            }
            return tasks
        }
    }
}
