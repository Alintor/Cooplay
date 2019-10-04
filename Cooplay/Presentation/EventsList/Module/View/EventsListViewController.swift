//
//  EventsListViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import DTTableViewManager
import DTModelStorage

final class EventsListViewController: UIViewController, EventsListViewInput, DTTableViewManageable {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View out

    var output: EventsListModuleInput?
    var viewIsReady: (() -> Void)?
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)?

    // MARK: - View in

    func setupInitialState() {
        navigationController?.navigationBar.prefersLargeTitles = true
        //self.view.backgroundColor = UIColor(red: 23.0/255, green: 25.0/255, blue: 31.0/255, alpha: 1)
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: EventCell.self) { cellType, modelType in
            manager.register(cellType)
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        if let dataSource = manager.storage as? MemoryStorage {
            dataSourceIsReady?(dataSource)
        }
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
}
