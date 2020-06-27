

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

