//
//  ApplicationAssembly.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class ApplicationAssembly {
    
    class var assembler: Assembler {
        return Assembler([
            
            // Network
            AuthorizationHandlerAssemblyContainer(),
            APIProviderAssemblyContainer(),
            
            // Storages
            DefaultsStorageAssemblyContainer(),
            
            // Services
            AuthorizationServiceAssemblyContainer(),
            EventServiceAssemblyContainer(),
            UserServiceAssemblyContainer(),
            GamesServiceAssemblyContainer(),
            
            // Modules
            EventsListAssemblyContainer(),
            NewEventAssemblyContainer(),
            SearchGameAssemblyContainer(),
            SearchMembersAssemblyContainer(),
            IntroAssemblyContainer(),
            AuthorizationAssemblyContainer(),
            RegistrationAssemblyContainer(),
            PersonalisationAssemblyContainer(),
            ProfileAssemblyContainer()
        ])
    }
}

extension SwinjectStoryboard {
    
    @objc public class func setup() {
        // workaround to fix the issue https://github.com/Swinject/Swinject/issues/218
        Container.loggingFunction = nil
        
        guard let applicationContainer = ApplicationAssembly.assembler.resolver as? Container else { return }
        defaultContainer = applicationContainer
    }
}
