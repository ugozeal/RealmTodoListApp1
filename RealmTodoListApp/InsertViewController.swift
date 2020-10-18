//
//  InsertViewController.swift
//  RealmTodoListApp
//
//  Created by David U. Okonkwo on 10/12/20.
//

import UIKit
import RealmSwift

class InsertViewController: UIViewController {
    let realm = try? Realm()
    var newTodo: Todo? = nil

    @IBOutlet var todoSwitchButton: UISwitch?
    @IBOutlet var todoTextField: UITextField?
    @IBAction func saveButtonAction(_ sender: Any) {
        if let correctTodo = newTodo {
            try? realm?.write {
                correctTodo.isDone = ((todoSwitchButton?.isOn) ?? true)
                correctTodo.todoText = todoTextField?.text ?? ""
            }
        } else {
            let todo = Todo()
            todo.todoText = todoTextField?.text ?? ""
            todo.isDone = ((todoSwitchButton?.isOn) ?? true)
            
            try? realm?.write {
                realm?.add(todo)
            }
        }
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let correctTodo = newTodo {
            todoTextField?.text = correctTodo.todoText
            todoSwitchButton?.isOn = correctTodo.isDone
        }
    }
}
