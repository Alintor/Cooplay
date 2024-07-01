//
//  AnalitycsService.swift
//  Cooplay
//
//  Created by Alexandr on 24.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsService {
    
    enum Event: String {
        case tapAppleSignIn,
        tapGoogleSignIn,
        openLoginScreen,
        tapResetPasswordEmail,
        submitLogin,
        openRegisterScreen,
        submitRegister,
        openResetPassword,
        submitResetPassword,
        openNewEventScreen,
        openSearchGameFromNewEvent,
        openSearchGameFromEventDetails,
        openSearchMemberFromNewEvent,
        openSearchMemberFromEventDetails,
        submitCreateNewEvent,
        showEventDetailsEditMode,
        closeEventDetailsEditModeByButton,
        closeEventDetailsEditModeByTopPull,
        submitChangeEventDate,
        submitChangeEventGame,
        submitAddEventMember,
        closeEventDetailsByButton,
        closeEventDetailsByEdgeSwipe,
        closeEventDetailsByTopPull,
        openProfileScreen,
        closeProfileByButton,
        closeProfileByEdgeSwipe,
        closeProfileByTopPull,
        openPersonalisationScreen,
        changeAvatarWithPicture,
        showMediaPermissionsAlert,
        openApplicationSettings,
        changeAvatarWithPhoto,
        submitChangePersonalisation,
        openArkanoidGame,
        openArkanoidGameFromEmptyView,
        closeArkanoidGame,
        openNotificationSettingsScreen,
        openReactionsSettingsScreen,
        changeReactionsInSettings,
        openRateUs,
        openWriteUsScreen,
        submitFeedback,
        openAccountScreen,
        tapLinkApple,
        tapUnlinkApple,
        tapLinkGoogle,
        tapUnlinkGoogle,
        openAddPasswordScreen,
        submitAddPassword,
        openChangePasswordScreen,
        submitChangePassword,
        openDeleteAccountScreen,
        submitDeleteAccount,
        submitLogout,
        tapAgreeOnInvitation,
        tapMoreOnInvitation,
        tapLogo,
        openLogoSpinnerScreen,
        closeLogoSpinnerScreen,
        openMemberContextMenu,
        openReactionsContextMenu,
        openFullReactionsListFromContextMenu,
        addMemberReactionFromContextMenu,
        addMemberReactionByDoubleTap,
        addSelfReactionFromContextMenu,
        openChangeStatusContextMenuFromList,
        openChangeStatusContextMenuFromEventDetails,
        changeStatusFromList,
        changeStatusFromEventDetails,
        tapGameCoverOnEventDetails,
        showNetworkError
    }
    
    static func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
    }
    
    static func sendEvent(_ event: AnalyticsService.Event, parameters: [String: Any]? = nil) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
    
}
