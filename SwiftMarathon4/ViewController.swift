//
//  ViewController.swift
//  SwiftMarathon4
//
//  Created by Anton Charny on 10/03/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var table: UITableView!
    
    private var items = (0...35).map { TableItem(number: $0) }
    
    enum ViewControllerSection: Hashable {
        case main
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<ViewControllerSection, TableItem> = {
        let dataSource = UITableViewDiffableDataSource<ViewControllerSection, TableItem>(tableView: self.table) { tableView, indexPath, model in
            guard let cell = self.table.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell
            else { return UITableViewCell() }
            cell.configure(model: model)
            return cell
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.table.delegate = self
        
        self.table.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        self.applySnapshot()
    }
    
    @IBAction func shuffleAction(_ sender: Any) {
        self.items.shuffle()
        self.applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewControllerSection, TableItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.items, toSection: .main)
        
        dataSource.defaultRowAnimation = .fade
        dataSource.apply(snapshot, animatingDifferences: true) {
            print("dataSourceCompletion")
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.items[indexPath.row].isChecked.toggle()
        
        if self.items[indexPath.row].isChecked {
            self.items.insert(self.items.remove(at: indexPath.row), at: 0)
        }
        
        self.applySnapshot()
    }
}

struct TableItem: Hashable {
    var isChecked = false
    var number: Int
}

class Cell: UITableViewCell {
    static var identifier: String { Self.description() }
    
    func configure(model: TableItem) {
        self.textLabel?.text = String(model.number)
        self.accessoryType = model.isChecked ? .checkmark : .none
    }
}
