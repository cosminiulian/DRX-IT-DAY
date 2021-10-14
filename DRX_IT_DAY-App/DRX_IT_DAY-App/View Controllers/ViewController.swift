//
//  ViewController.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 27.04.2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    private let authorizeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Authorize", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LogoDRX")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "DRX IT Day"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(authorizeButton)
        view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func didTapButton() {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize with Face/Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (succes, error) in
                DispatchQueue.main.async {
                    // failed
                    guard succes, error == nil else {
                        return
                    }
                    // succes - show tab bar
                    
                    // Nav View Controllers
                    let assetVC = UINavigationController(rootViewController: AssetViewController())
                    let costCenterVC = UINavigationController(rootViewController: CostCenterViewController())
                    let employeeVC = UINavigationController(rootViewController: EmployeeViewController())
                    assetVC.title = "Asset"
                    costCenterVC.title = "Cost Center"
                    employeeVC.title = "Employee"
                    // TabBar View Controller
                    let tabBarVC = UITabBarController()
                    tabBarVC.modalPresentationStyle = .fullScreen
                    tabBarVC.setViewControllers([assetVC, costCenterVC, employeeVC], animated: false)
                    guard let items = tabBarVC.tabBar.items else {
                        return
                    }
                    items[0].image = UIImage(systemName: "shippingbox")
                    items[1].image = UIImage(systemName: "banknote")
                    items[2].image = UIImage(systemName: "person")
                    
                    self?.present(tabBarVC, animated: true)
                }
            }
            
        } else {
            // Face/Touch ID Unavailable
            let alert = UIAlertController(title: "Face/Touch ID Unavailable", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
    }
    
}


