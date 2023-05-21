//
//  PluginDetailController.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/18.
//

import UIKit

class PluginInfoController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let plugin: Plugin
    init(_ plugin: Plugin) {
        self.plugin = plugin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.title = "Overview"
        
        /// add tableview
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 5
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let buildCell: (UITableViewCell.CellStyle) -> UITableViewCell = { style in
            var cell = tableView.dequeueReusableCell(withIdentifier: "\(style.rawValue)")
            if (cell == nil) {
                cell = UITableViewCell(style: style, reuseIdentifier: "\(style.rawValue)")
            }
            return cell!
        }
        
        switch indexPath.section {
        case 0:
            let cell = buildCell(.value1)
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = self.plugin.displayName
            return cell
        case 1:
            let cell = buildCell(.value1)
            cell.textLabel?.textColor = .black
            switch indexPath.item {
            case 0:
                cell.textLabel?.text = "Author"
                cell.detailTextLabel?.text = self.plugin.author
            case 1:
                cell.textLabel?.text = "Category"
                cell.detailTextLabel?.text = self.plugin.category
            case 2:
                cell.textLabel?.text = "Release Date"
                cell.detailTextLabel?.text = self.plugin.releaseDate
            case 3:
                cell.textLabel?.text = "Version"
                cell.detailTextLabel?.text = self.plugin.version
            case 4:
                cell.textLabel?.text = "Supported iOS Version"
                cell.detailTextLabel?.text = self.plugin.supportedIOSVersion + "+"
            default: break
            }
            cell.accessoryType = .none
            return cell
        case 2:
            let cell = buildCell(.default)
            cell.textLabel?.text = self.plugin.mail
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = .systemBlue
            return cell
        case 3:
            let cell = buildCell(.default)
            cell.textLabel?.text = self.plugin.homepage
            cell.textLabel?.textColor = .systemBlue
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 0 ? self.plugin.description : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            if let url = URL(string: "mailto:" + self.plugin.mail) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        } else if indexPath.section == 3 {
            if let url = URL(string: self.plugin.homepage) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
