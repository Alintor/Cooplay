//
//  SearchMembersRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import Foundation

protocol SearchMembersRouterInput: CloseableRouter {

    func shareInventLink(_ link: URL)
}
