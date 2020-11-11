//
//  TimePickerRoutable.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 10/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

protocol TimePickerRoutable: Router {
    
    func showTimePicker(startTime: Date, enableMinimumTime: Bool, showDate: Bool, handler: ((_ date: Date) -> Void)?)
}

extension TimePickerRoutable {
    
    func showTimePicker(startTime: Date, enableMinimumTime: Bool, showDate: Bool = false, handler: ((_ date: Date) -> Void)?) {
        guard let delegate = transitionHandler as? NewEventTimePickerViewDelegate else { return }
        let timePickerView = NewEventTimePickerView(delegate: delegate, timeHandler: handler)
        timePickerView.show(startTime: startTime, showDate: showDate, enableMinimumTime: enableMinimumTime)
    }
}
