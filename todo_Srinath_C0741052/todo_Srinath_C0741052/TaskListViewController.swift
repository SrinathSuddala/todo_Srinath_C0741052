

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var taskListTableView: UITableView!
    var tasks: [Task] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        taskListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        // Do any additional setup after loading the view.
    }
    

    @objc func addTapped() {
        
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

