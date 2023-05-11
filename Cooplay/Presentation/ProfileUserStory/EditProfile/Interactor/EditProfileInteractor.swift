//
//  EditProfileInteractor.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

final class EditProfileInteractor {
    
    weak var output: EditProfileInteractorOutput?
    
    // MARK: - Init
    
    init() {
    }
}

extension EditProfileInteractor: EditProfileInteractorInput { }
