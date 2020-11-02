//
//  ViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class TodoListVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Properties
    var tasks: [TaskData] = []
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getAllTasks()
    }

    // MARK:- Public Methods
    class func create() -> TodoListVC {
        let todoListVC: TodoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.todoListVC)
        return todoListVC
    }
    
    // MARK:- Private Methods
    private func setUpNavBar() {
        navigationItem.title = "Tasks"
        let newTaskButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(newTodo))
        newTaskButton.tintColor = .label
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(goToProfileVC))
        profileButton.tintColor = .label
        navigationItem.rightBarButtonItems = [newTaskButton, profileButton]
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func getAllTasks() {
        APIManager.getAllTasks { [weak self] (error, tasksData) in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            } else if let tasksData = tasksData {
                self?.tasks = tasksData.data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func saveNewTask(with task: TaskData) {
        APIManager.addNewTask(with: task) { [weak self] (succeded) in
            if succeded {
                self?.getAllTasks()
            } else {
                self?.showAlert(title: "Connection error", message: "Please try again later")
            }
        }
    }
    
    // MARK:- @Objc Methods
    @objc private func newTodo() {
        let alert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] (action) in
            guard let description = alert.textFields?.first?.text, !description.isEmpty else {
                self?.showAlert(title: "Can't save task", message: "Please enter task description")
                return
            }
            let task = TaskData(description: description)
            self?.saveNewTask(with: task)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func goToProfileVC() {
        let profileVC = ProfileVC.create()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}

// MARK:- TableView DataSource and Delegate
extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.todoCell, for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
