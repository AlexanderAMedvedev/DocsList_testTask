//
//  ViewController.swift
//  DocsList
//
//  Created by Александр Медведев on 12.04.2024.
//

import UIKit

final class DocsListViewController: UIViewController {
    
    private let dataService = DataService.shared
    
    private lazy var docsTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(DocCell.self, forCellReuseIdentifier: DocCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
       // UIBlockingProgressHUD.show()
        dataService.fetchData { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                  self.setupUI()
                  self.setupLayout()
                  //  UIBlockingProgressHUD.dismiss()
                case .failure:
                    print("fail")
                   // UIBlockingProgressHUD.dismiss()
                   // self.showAlertWithOneAction(
                    //    generalTitle: "Что-то пошло не так(",
                     //   message: "Не удалось загрузить данные о пользователях в json-файле",
                      //  buttonText: "Повторить",
                       // handler: { _ in self.viewDidLoad() }
                   // )
                }
            }
        }
    }
    private func setupUI() {
        [docsTable].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let backButton = UIBarButtonItem()
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setupLayout() {
        let viewSafe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            docsTable.topAnchor.constraint(equalTo: viewSafe.topAnchor, constant: 16),
            docsTable.leadingAnchor.constraint(equalTo: viewSafe.leadingAnchor, constant: 16),
            docsTable.trailingAnchor.constraint(equalTo: viewSafe.trailingAnchor, constant: -16),
            docsTable.bottomAnchor.constraint(equalTo: viewSafe.bottomAnchor, constant: -16),
            
        ])
    }

}

extension DocsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataService.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocCell.reuseIdentifier, for: indexPath)
        guard let cell = (cell as? DocCell) else {
            print("Did not produce the desired cell")
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        cell.configure(user: dataService.users[indexPath.row])
        return cell
    }
    
}

extension DocsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let viewController = DocPageViewController(user: dataService.users[indexPath.row])
       viewController.modalPresentationStyle = .fullScreen
        //viewController.hidesBottomBarWhenPushed = true
       navigationController?.pushViewController(viewController, animated: true)
    }
}
