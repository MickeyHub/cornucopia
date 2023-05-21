//
//  GroceryController.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/17.
//

import UIKit

class GroceryController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = GroceryViewModel()
    
    var tableView: UITableView!
    var indicator: UIActivityIndicatorView!
    var retryButton: UIButton!
    
    override func viewDidLoad() {
        
        /// add tableview but empty at first
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        /// loading manifest from remote
        indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        /// retry btn
        retryButton = UIButton()
        retryButton.setTitle("Retry", for: .normal)
        retryButton.layer.cornerRadius = 4
        retryButton.layer.borderColor = UIColor.systemGray.cgColor
        retryButton.layer.borderWidth = 1
        retryButton.setTitleColor(.systemGray, for: .normal)
        retryButton.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        retryButton.sizeToFit()
        view.addSubview(retryButton)
        retryButton.center = view.center
        retryButton.addTarget(self, action: #selector(loadPlugins), for: .touchUpInside)
        
        /// load data
        loadPlugins()
        
        /// observe
        self.viewModel.observeInstaller { [weak self] indexPath in
            guard let self = self else { return }
            
            guard let indexPathes = self.tableView.indexPathsForVisibleRows else { return }
            guard indexPathes.contains(indexPath) else { return }
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            guard let installButton = cell.accessoryView as? InstallButton else { return }
            
            installButton.state = self.viewModel.state(at: indexPath)
        }
        
        self.viewModel.observeInstalled { [weak self] in
            self?.loadPlugins()
        }
    }
    
    @objc func loadPlugins() {
        /// load plugin
        viewModel.loadPlugins { [weak self] apiState in
            guard let self = self else { return }
            
            switch apiState {
            case .loading:
                self.indicator.isHidden = false
                self.tableView.isHidden = true
                self.retryButton.isHidden = true
            case .success:
                self.indicator.isHidden = true
                self.tableView.isHidden = false
                self.retryButton.isHidden = true
                self.tableView.reloadData()
            case .error(_):
                self.indicator.isHidden = true
                self.tableView.isHidden = true
                self.retryButton.isHidden = false
            }
        }
    }
    
    //MARK: UITableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.accessoryView = InstallButton(self.viewModel.state(at: indexPath)) { [weak self] button in
                guard let self = self else { return }
                
                guard let cell = button.superview as? UITableViewCell else { return }
                guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                
                switch button.state {
                case .available(_):
                    self.viewModel.install(at: indexPath)
                case .downloaded:
                    PluginEntrance.shared.navigate(self.viewModel.plugin(at: indexPath))
                    break
                default: break
                }
            }
        }
        
        cell?.textLabel?.text = self.viewModel.name(at: indexPath)
        if let installBtn = cell?.accessoryView as? InstallButton {
            installBtn.state = self.viewModel.state(at: indexPath)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        header?.textLabel?.text = self.viewModel.section(at: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let plugin = self.viewModel.plugin(at: indexPath)
        let infoController = PluginInfoController(plugin)
        
        if #available(iOS 15.0, *) {
            infoController.sheetPresentationController?.detents = [.medium(), .large()]
            infoController.sheetPresentationController?.prefersGrabberVisible = true
        }
        
        self.present(infoController, animated: true)
    }
}
