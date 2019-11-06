//
//  EventsListViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import DTModelStorage
import iCarousel

protocol EventsListViewInput: class, ActivityIndicatorRenderer {

    // MARK: - View out

    var output: EventsListModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func updateProfile(with model: AvatarViewModel)
    func showItems()
    func setInvitations(show: Bool, dataSource: iCarouselDataSource)
}
