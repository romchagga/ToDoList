//
//  ViewController.swift
//  ToDoList
//
//  Created by macbook on 11.12.2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Creating properties
    //temporarily
    var notes: [String] = ["Drink", "Shopping", "Playing"] {
        didSet {
            countOfNotes.text = notes.count > 1 ? "\(notes.count) notes" : "\(notes.count) note"
        }
    }
    
    private let searchC = UISearchController()
    
    private let noteTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addNewNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var countOfNotes: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    // MARK: Life cycles
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 242/255, green: 241/255, blue: 248/255, alpha: 1)
        
        configNavC()
        configSearchC()
        configNoteTVC()
        
        
        addNewNoteButton.addTarget(self, action: #selector(addNewNoteButtonTapped), for: .touchUpInside)
        
        countOfNotes.text = notes.count > 1 ? "\(notes.count) notes" : "\(notes.count) note"
        
    }
    
    @objc func addNewNoteButtonTapped() {
        navigationController?.pushViewController(EditAddNoteViewController(), animated: true)
    }
    
    // MARK: Config views
    private func configNavC() {
        navigationItem.title = "Мои заметки"
    }
    
    private func configSearchC() {
       // searchC.searchResultsUpdater = self
        searchC.obscuresBackgroundDuringPresentation = false
        searchC.searchBar.placeholder = "Search"
        navigationItem.searchController = searchC
    }
    
    private func configNoteTVC() {
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.idCell)
        noteTableView.backgroundColor = .clear
        noteTableView.separatorStyle = .none
    }
    
    private func setConstraints() {
        view.addSubview(noteTableView)
        NSLayoutConstraint.activate([
            noteTableView.topAnchor.constraint(equalTo: view.topAnchor),
            noteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            noteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.addSubview(addNewNoteButton)
        NSLayoutConstraint.activate([
            addNewNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addNewNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            addNewNoteButton.widthAnchor.constraint(equalToConstant: 21),
            addNewNoteButton.heightAnchor.constraint(equalToConstant: 18)
        ])
        view.addSubview(countOfNotes)
        NSLayoutConstraint.activate([
            countOfNotes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            countOfNotes.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            countOfNotes.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
}

// MARK: Extentions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = notes.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.idCell, for: indexPath) as! TableViewCell
        let object = notes[indexPath.row]
        cell.writtenTextLabel.text = object
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        DispatchQueue.main.async {
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
