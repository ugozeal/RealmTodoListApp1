//
//  ViewController.swift
//  RealmTodoListApp
//
//  Created by David U. Okonkwo on 10/12/20.
//

import UIKit
import Foundation
import RealmSwift

var realm = try? Realm()
class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var todoTableView: UITableView?
    var todos = try? Realm().objects(Todo.self)
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellClicked" {
            let destination = segue.destination as? InsertViewController
            let todo = todos?[(todoTableView?.indexPathForSelectedRow?.row) ?? 0]
            destination?.newTodo = todo
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else { return UITableViewCell() }
        let todo = todos?[indexPath.row]
        cell.todoText?.text = todo?.todoText
        cell.isDoneText?.text = todo?.isDone ?? false ? "It is Done" : "Do it"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? realm?.write {
                realm?.delete((todos?[indexPath.row]) ?? Object())
            }
            reloadTodo()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView?.delegate = self
        todoTableView?.dataSource = self
        todos = realm?.objects(Todo.self)
        reloadTodo()
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadTodo()
    }

    func reloadTodo() {
        todoTableView?.reloadData()
    }
}

class Todo: Object {
    @objc dynamic var todoText = ""
    @objc dynamic var isDone = false
}

class TodoCell: UITableViewCell {
    @IBOutlet var todoText: UILabel?
    @IBOutlet var isDoneText: UILabel?
}
