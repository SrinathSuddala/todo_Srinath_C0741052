

import UIKit
import CoreData

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var taskListTableView: UITableView!
    var tasks: [Task] = []
    var selectedCategory: Category!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        taskListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
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
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.deleteTask(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func deleteTask(at indexPath: IndexPath) {
        taskListTableView.beginUpdates()
        let task = tasks[indexPath.row]
        tasks.remove(at: indexPath.row)
        taskListTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        appdelegate.persistentContainer.viewContext.delete(task)
        taskListTableView.endUpdates()
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = tasks[indexPath.row].title
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
