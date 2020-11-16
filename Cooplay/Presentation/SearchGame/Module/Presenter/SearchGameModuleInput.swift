//
//  SearchGameModuleInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

protocol SearchGameModuleInput: class {

    func configure(offtenGames: [Game]?, selectedGame: Game?, selectionHandler: ((_ game: Game) -> Void)?)
}
