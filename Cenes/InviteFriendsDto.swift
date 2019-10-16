//
//  InviteFriendsDto.swift
//  Deploy
//
//  Created by Cenes_Dev on 16/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class InviteFriendsDto {
    var userContactIdMapList: [Int: CenesUserContactMO] = [:];
    var eventMemberMapList: [Int: EventMemberMO] = [:];
    var cenesContacts = [CenesUserContactMO]();
    var allEventMembers: [CenesUserContactMO] = [CenesUserContactMO]();
    var allContacts = [FriendListDto]();
    var filteredEventMembers = [CenesUserContactMO]();
    var selectedFriendCollectionViewList: [CenesUserContactMO] = [CenesUserContactMO]()
    var isAllContactsView: Bool = true;
    var checkboxStateHolder: [Int: Bool] = [:];
    var friendCollectionViewCell: CGFloat = InviteFriendsCellHeight.friendsCollectionViewheight;
    var allAndCenesContactsSwitchCell: CGFloat = InviteFriendsCellHeight.allCenesContactsSwitchHeight;
    var totalNumberOfRows = 3;
    var alphabetStrip = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "U", "W", "X", "Y", "Z", "#"];
    var isSearchOn: Bool = false;
    var searchText: String = "";
}
