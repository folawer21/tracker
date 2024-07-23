//
//  CategoriesVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 12.07.2024.
//
import UIKit
final class CategoriesVC: UIViewController {
    weak var viewModel: CategoriesViewModel?
    var chosenCategory: String?
    let tableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = Colors.blackBackgroundColor
        return table
    }()
    
    lazy var stubView = StubView(frame: CGRect.zero, title: NSLocalizedString("stubView_text", comment: ""))
    
    let addButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Colors.addButtonColor
        return button
    }()
    
    init(viewModel: CategoriesViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        guard let categoryStore = viewModel?.model else {
            return
        }
        let trackerStore = TrackerStore(day: .friday)
        trackerStore.setCategoryStore(categoryStore: categoryStore)
        categoryStore.setTrackerStore(trackerStore: trackerStore)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        viewModel?.setTrackerStore()
        view.backgroundColor = Colors.blackBackgroundColor
        navigationItem.titleView?.tintColor = Colors.stubTextLabelColor
        let navTitle = NSLocalizedString("categories_nav_title", comment: "")
        navigationItem.title = navTitle
        let button_text = NSLocalizedString("stubView_button_text", comment: "")
        addButton.setTitle(button_text, for: .normal)

        addButton.setTitleColor(Colors.blackBackgroundColor, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
      
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.cellIdentifier)
        tableView.allowsMultipleSelection = false

    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.setTrackerStore()
        
        guard let isEmpty = viewModel?.isEmpty() else {
            return
        }
        if isEmpty {
            buildWithStub()
        } else {
            buildWithCategories()
        }
    }
    
    private func buildWithStub(){
        removeTable()
        addSubViewsWithStub()
        applyConstraintsWithStub()
    }
    
    private func buildWithCategories(){
        removeStub()
        addSubViewsWithCategories()
        applyConstraintsWithCategories()
    }
    
    private func addSubViewsWithCategories() {
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    private func addSubViewsWithStub(){
        view.addSubview(stubView)
        view.addSubview(addButton)
    }
    
    private func applyConstraintsWithStub() {
        applyStubConstraints()
        applyButtonConstraintsStub()
    }
    private func applyConstraintsWithCategories() {
        applyTableConstraints()
        applyButtonConstraintsWithCategories()
    }
    
    private func applyTableConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -15)
        ])
    }
    
    private func applyButtonConstraintsWithCategories() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            addButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func applyStubConstraints() {
        stubView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stubView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stubView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -15)
        ])
    }
    
    private func applyButtonConstraintsStub() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: stubView.bottomAnchor, constant: 15),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            addButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func removeStub(){
        self.view.willRemoveSubview(stubView)
        stubView.removeFromSuperview()
    }
    private func removeTable(){
        self.view.willRemoveSubview(tableView)
        tableView.removeFromSuperview()
    }
    
    @objc private func addButtonTapped() {
        let vc = CreationCategoryVC(viewModel: viewModel)
        show(vc, sender: self)
    }
  
}

extension CategoriesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getCategoristCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        guard let name = viewModel?.getCategoryName(index: indexPath.row) else {
            return UITableViewCell()
        }
        cell.setupCell(name: name)
        
        guard let isChosenFlag = viewModel?.isCategoryChosen(index: indexPath.row) else {
            return UITableViewCell()
        }
        if isChosenFlag {
            cell.makeChosen()
        }
        return cell
    }
}

extension CategoriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell,
              let chosenCategory = viewModel?.getCategoryName(index: indexPath.row) else {
            return
        }
        viewModel?.setPickedCategory(name: chosenCategory)
        cell.makeChosen()
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else {
            return
        }
        cell.makeUnChosen()
    }
}
extension CategoriesVC: TrackerCategoryStoreDelegate{
    func stote(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        tableView.reloadData()
    }
}
