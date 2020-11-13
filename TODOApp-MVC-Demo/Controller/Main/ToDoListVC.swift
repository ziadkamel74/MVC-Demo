//
//  ViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ToDoListVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Properties
    var tasks: [TaskData] = []
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getAllTasks()
    }

    // MARK:- Public Methods
    class func create() -> ToDoListVC {
        let toDoListVC: ToDoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.toDoListVC)
        return toDoListVC
    }
}

extension ToDoListVC {
    // MARK:- Private Methods
    private func setupViews() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Tasks"
        let newTaskButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(newTodo))
        newTaskButton.tintColor = .label
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(goToProfileVC))
        profileButton.tintColor = .label
        navigationItem.rightBarButtonItems = [newTaskButton, profileButton]
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cells.toDoCell, bundle: nil), forCellReuseIdentifier: Cells.toDoCell)
    }
    
    private func getAllTasks() {
        self.view.showLoader()
//        APIManager.getAllTasks { [weak self] (error, tasksData) in
//            if let error = error {
//                self?.showAlert(title: "Error", message: error.localizedDescription)
//            } else if let tasksData = tasksData {
//                self?.tasks = tasksData
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            }
//            self?.view.hideLoader()
//        }
        APIManager.getAllTasks { [weak self] (response) in
            switch response {
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let tasks):
                self?.tasks = tasks.data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            self?.view.hideLoader()
        }
    }
    
    private func saveNewTask(with task: TaskData) {
        self.view.showLoader()
        APIManager.addNewTask(with: task) { [weak self] (succeeded) in
            if succeeded {
                self?.getAllTasks()
            } else {
                self?.showAlert(title: "Connection error", message: "Please try again later")
            }
            self?.view.hideLoader()
        }
    }
    
    private func deleteTask(with id: String) {
        self.view.showLoader()
        APIManager.deleteTask(with: id) { [weak self] (deleted) in
            if deleted {
                self?.getAllTasks()
            } else {
                self?.showAlert(title: "Connection error", message: "Please try again later")
            }
            self?.view.hideLoader()
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
            let task = TaskData(description: description, id: nil)
            self?.saveNewTask(with: task)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func goToProfileVC() {
        let profileTableVC = ProfileTableVC.create()
        navigationController?.pushViewController(profileTableVC, animated: true)
    }
    
    @objc private func didTapDeleteTask(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: hitPoint) else { return }
        let alert = UIAlertController(title: "Sorry", message: "Are you sure you want to delete this todo?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
            guard let taskID = self?.tasks[indexPath.row].id else { return }
            self?.deleteTask(with: taskID)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true)
    }
}

// MARK:- TableView DataSource and Delegate
extension ToDoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.toDoCell, for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        cell.configure(description: tasks[indexPath.row].description)
        cell.deleteButton.addTarget(self, action: #selector(didTapDeleteTask), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
