//
//  InstallButton.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/18.
//

import UIKit

class InstallButton : UIView {
    
    enum State {
        enum AvailableReason {
            case install
            case update
        }
        
        case unavailable (String)
        case available (AvailableReason)
        case downloading (Double)
        case downloaded
    }
    
    private let btn: UIButton
    private let indicator: UIActivityIndicatorView
    
    var state: State {
        didSet {
            switch self.state {
            case .unavailable(let version):
                btn.setTitle("\(version)+", for: .normal)
                btn.isHidden = false
                indicator.stopAnimating()
            case .available(let reason):
                btn.isHidden = false
                indicator.stopAnimating()
                switch reason {
                case .install:
                    btn.setTitle("Install", for: .normal)
                case .update:
                    btn.setTitle("Update", for: .normal)
                }
            case .downloading(_):
                btn.isHidden = true
                indicator.startAnimating()
            case .downloaded:
                btn.setTitle("Open", for: .normal)
                btn.isHidden = false
                indicator.stopAnimating()
            }
        }
    }
    
    typealias ClickHandler = (InstallButton)->Void
    let onClick: ClickHandler?
    
    init(_ state: State = .available(.install), _ onClick: ClickHandler? = nil) {
        
        self.btn = UIButton(type: .system)
        self.indicator = UIActivityIndicatorView(style: .medium)
        
        self.state = state
        self.onClick = onClick
        
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 25)))
        
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        addSubview(btn)
        
        indicator.hidesWhenStopped = true
        indicator.center = center
        addSubview(indicator)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        btn.topAnchor.constraint(equalTo: topAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        defer {
            self.state = state
        }
    }
    
    @objc func click() {
        self.onClick?(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
