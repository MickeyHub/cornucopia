//
//  HomeController.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/17.
//

import UIKit

class HomeController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = HomeViewModel()
    
    var tableView: UITableView!
    var empty: UILabel!
    
    override func viewDidLoad() {
        
        /// add tableview but empty at first
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        /// empty label
        empty = UILabel()
        empty.textAlignment = .center
        empty.numberOfLines = 0
        empty.font = UIFont.systemFont(ofSize: 30)
        empty.textColor = .systemGray
        empty.text = "No Plugin Installed"
        
        view.addSubview(empty)
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        empty.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        empty.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        empty.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        /// load data
        self.loadPlugins()
        
        /// observe
        self.viewModel.observeInstaller { [weak self] in
            self?.loadPlugins()
        }
    }
    
    func loadPlugins() {
        self.viewModel.loadPlugins()
        
        empty.isHidden = !self.viewModel.isEmpty
        tableView.isHidden = self.viewModel.isEmpty
        
        tableView.reloadData()
    }
    
    //MARK: UITableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.viewModel.name(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        header?.textLabel?.text = self.viewModel.section(at: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        PluginEntrance.shared.navigate(self.viewModel.plugin(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let uninstall = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, handler in
            if let plugin = self?.viewModel.plugin(at: indexPath) {
                Installed.shared.delete(plugin)
                self?.loadPlugins()
            }
        }
        uninstall.image = UIImage(systemName: "trash")
        uninstall.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [uninstall])
    }
}

