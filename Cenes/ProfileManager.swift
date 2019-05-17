//
//  ProfileManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 16/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
class ProfileManager {
    
    func getWorldHolidayData() -> [String: HolidaySectionDto] {
        
        var keyValueWorldHolidayDto = [HolidaySectionDto]();
        var keyValueWorldHolidayData = [String: HolidaySectionDto]();
        var countryDataArray = [NSMutableDictionary]()

        countryDataArray =  [["name":"Australian Holidays","value":"en.australian#holiday@group.v.calendar.google.com","image":"flag_au.png"],
                             ["name":"Austrian Holidays","value":"en.austrian#holiday@group.v.calendar.google.com","image":"flag_br.png"],
                             ["name":"Brazilian Holidays","value":"en.brazilian#holiday@group.v.calendar.google.com","image":"flag_at.png"],
                             ["name":"Canadian Holidays","value":"en.canadian#holiday@group.v.calendar.google.com","image":"flag_ca.png"],
                             ["name":"China Holidays","value":"en.china#holiday@group.v.calendar.google.com","image":"flag_cn.png"],
                             ["name":"Christian Holidays","value":"en.christian#holiday@group.v.calendar.google.com","image":"flag_christ.png"],
                             ["name":"Danish Holidays","value":"en.danish#holiday@group.v.calendar.google.com","image":"flag_dk.png"],
                             ["name":"Dutch Holidays","value":"en.dutch#holiday@group.v.calendar.google.com","image":"flag_dut.png"],
                             ["name":"Finnish Holidays","value":"en.finnish#holiday@group.v.calendar.google.com","image":"flag_fi.png"],
                             ["name":"French Holidays","value":"en.french#holiday@group.v.calendar.google.com","image":"flag_fr.png"],
                             ["name":"German Holidays","value":"en.german#holiday@group.v.calendar.google.com","image":"flag_de.png"],
                             ["name":"Greek Holidays","value":"en.greek#holiday@group.v.calendar.google.com","image":"flag_gr.png"],
                             ["name":"Hong Kong (C) Holidays","value":"en.hong_kong_c#holiday@group.v.calendar.google.com","image":"flag_hk.png"],
                             ["name":"Hong Kong Holidays","value":"en.hong_kong#holiday@group.v.calendar.google.com","image":"flag_hk.png"],
                             ["name":"Indian Holidays","value":"en.indian#holiday@group.v.calendar.google.com","image":"flag_in.png"],
                             ["name":"Indonesian Holidays","value":"en.indonesian#holiday@group.v.calendar.google.com","image":"flag_id.png"],
                             ["name":"Iranian Holidays","value":"en.iranian#holiday@group.v.calendar.google.com","image":"flag_ir.png"],
                             ["name":"Irish Holidays","value":"en.irish#holiday@group.v.calendar.google.com","image":"flag_ie.png"],
                             ["name":"Islamic Holidays","value":"en.islamic#holiday@group.v.calendar.google.com","image":"flag_isl.png"],
                             ["name":"Italian Holidays","value":"en.italian#holiday@group.v.calendar.google.com","image":"flag_it.png"],
                             ["name":"Japanese Holidays","value":"en.japanese#holiday@group.v.calendar.google.com","image":"flag_jp.png"],
                             ["name":"Jewish Holidays","value":"en.jewish#holiday@group.v.calendar.google.com","image":"flag_jew.png"],
                             ["name":"Malaysian Holidays","value":"en.malaysia#holiday@group.v.calendar.google.com","image":"flag_my.png"],
                             ["name":"Mexican Holidays","value":"en.mexican#holiday@group.v.calendar.google.com","image":"flag_mx.png"],
                             ["name":"New Zealand Holidays","value":"en.new_zealand#holiday@group.v.calendar.google.com","image":"flag_nz.png"],
                             ["name":"Norwegian Holidays","value":"en.norwegian#holiday@group.v.calendar.google.com","image":"flag_nw.png"],
                             ["name":"Philippines Holidays","value":"en.philippines#holiday@group.v.calendar.google.com","image":"flag_ph.png"],
                             ["name":"Polish Holidays","value":"en.polish#holiday@group.v.calendar.google.com","image":"flag_pl.png"],
                             ["name":"Portuguese Holidays","value":"en.portuguese#holiday@group.v.calendar.google.com","image":"flag_pt.png"],
                             ["name":"Russian Holidays","value":"en.russian#holiday@group.v.calendar.google.com","image":"flag_ru.png"],
                             ["name":"Singapore Holidays","value":"en.singapore#holiday@group.v.calendar.google.com","image":"flag_sg.png"],
                             ["name":"South Africa Holidays","value":"en.sa#holiday@group.v.calendar.google.com","image":"flag_za.png"],
                             ["name":"South Korean Holidays","value":"en.south_korea#holiday@group.v.calendar.google.com","image":"flag_kr.png"],
                             ["name":"Spain Holidays","value":"en.spain#holiday@group.v.calendar.google.com","image":"flag_es.png"],
                             ["name":"Swedish Holidays","value":"en.swedish#holiday@group.v.calendar.google.com","image":"flag_se.png"],
                             ["name":"Taiwan Holidays","value":"en.taiwan#holiday@group.v.calendar.google.com","image":"flag_tw.png"],
                             ["name":"Thai Holidays","value":"en.thai#holiday@group.v.calendar.google.com","image":"flag_th.png"],
                             ["name":"UK Holidays","value":"en.uk#holiday@group.v.calendar.google.com","image":"flag_ac.png"],
                             ["name":"US Holidays","value":"en.usa#holiday@group.v.calendar.google.com","image":"flag_us.png"],
                             ["name":"Vietnamese Holidays","value":"en.vietnamese#holiday@group.v.calendar.google.com","image":"flag_vn.png"]]
        
        
        var emptyDto = HolidaySectionDto();
        emptyDto.sectionName = "#";
        emptyDto.sectionData = [NSMutableDictionary]();
        keyValueWorldHolidayData["#"] = emptyDto;
        
        for countryData in countryDataArray {
           
            let initials = String((countryData["name"] as! String).split(separator: " ")[0]).substring(toIndex: 1).uppercased();
            
            if (keyValueWorldHolidayData[initials] != nil) {
                
                var countryDataDto = keyValueWorldHolidayData[initials];
                
                var countryDataArray = countryDataDto?.sectionData;
                countryDataArray?.append(countryData);
                countryDataDto?.sectionData = countryDataArray;
                keyValueWorldHolidayData[initials] = countryDataDto;
                
            } else {
                var countryDataArray = [NSMutableDictionary]()
                countryDataArray.append(countryData);
                
                var tempHolidaySecitonDto = HolidaySectionDto();
                tempHolidaySecitonDto.sectionName = initials;
                tempHolidaySecitonDto.sectionData = countryDataArray;
               
                keyValueWorldHolidayData[initials] = tempHolidaySecitonDto;
            }
        }
        
        return keyValueWorldHolidayData;
    }
    
    func getHolidayCalendarAlphabeticStrip() -> [String] {
        
        var alphabeticStrip: [String] = [String]();
        alphabeticStrip = ["#", "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        /*var countryDataArray = getWorldHolidayData();
        for countryData in countryDataArray {
            
            let initial = String((countryData["name"] as! String).split(separator: " ")[0]).substring(toIndex: 1);
            
            if (!alphabeticStrip.contains(initial)) {
                alphabeticStrip.append(initial.uppercased());
            }
        }*/
        
        return alphabeticStrip;
    }
    
}

class HolidaySectionDto {
    var sectionName: String!;
    var sectionData: [NSMutableDictionary]!
}
