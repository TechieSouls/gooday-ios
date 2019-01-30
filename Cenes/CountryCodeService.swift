//
//  CountryCodeService.swift
//  Cenes
//
//  Created by Macbook on 29/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class CountryCodeService {
    
    var DEFAULT_FLAG_RES: NSNumber = -99;
    var phoneCode: String = "";
    var nameCode: String = "";
    var name: String = "";
    var flagResID: NSNumber = 0;
    
    func getPhoneCode() -> String {
    return phoneCode;
    }
    
    func setPhoneCode(phoneCode: String) {
        self.phoneCode = phoneCode;
    }
    
    func getNameCode() -> String {
        return self.nameCode;
    }
    
    func setNameCode(nameCode: String) {
        self.nameCode = nameCode;
    }
    
    func getName() -> String {
        return self.name;
    }
    
    func setName(name: String) {
        self.name = name;
    }
    
    /*func getFlagResID() -> NSNumber {
        return self.flagResID;
    }
    
    func setFlagResID(flagResID: NSNumber) {
        self.flagResID = flagResID;
    }*/
    
    func getCountryCodeService(nameCode: String, phoneCode: String, name: String, flagResID: NSNumber) -> CountryCodeService {
        let countryCodeService: CountryCodeService = CountryCodeService();
        countryCodeService.nameCode = nameCode;
        countryCodeService.phoneCode = phoneCode;
        countryCodeService.name = name;
        countryCodeService.flagResID = flagResID;
        return countryCodeService;
    }
    
    /**
     * Returns image res based on country name code
     *
     * @param
     * @return
     */
    func getFlagMasterResID(countryCode: CountryCodeService) -> UIImage {
        switch (countryCode.getNameCode().lowercased()) {
        //this should be sorted based on country name code.
            case "ad": //andorra
            return #imageLiteral(resourceName: "countryFlags/flag_andorra");
            case "ae": //united arab emirates
            return #imageLiteral(resourceName: "countryFlags/flag_uae");
            case "af": //afghanistan
            return #imageLiteral(resourceName: "countryFlags/flag_afghanistan");
            case "ag": //antigua & barbuda
            return #imageLiteral(resourceName: "countryFlags/flag_antigua_and_barbuda");
            case "ai": //anguilla // Caribbean Islands
            return #imageLiteral(resourceName: "countryFlags/flag_anguilla");
            case "al": //albania
            return #imageLiteral(resourceName: "countryFlags/flag_albania");
            case "am": //armenia
            return #imageLiteral(resourceName: "countryFlags/flag_armenia");
            case "ao": //angola
            return #imageLiteral(resourceName: "countryFlags/flag_angola");
            case "aq": //antarctica // custom
            return #imageLiteral(resourceName: "countryFlags/flag_antarctica");
            case "ar": //argentina
            return #imageLiteral(resourceName: "countryFlags/flag_argentina");
            case "as": //American Samoa
            return #imageLiteral(resourceName: "countryFlags/flag_american_samoa");
            case "at": //austria
            return #imageLiteral(resourceName: "countryFlags/flag_austria");
            case "au": //australia
            return #imageLiteral(resourceName: "countryFlags/flag_australia");
            case "aw": //aruba
            return #imageLiteral(resourceName: "countryFlags/flag_aruba");
            case "ax": //alan islands
            return #imageLiteral(resourceName: "countryFlags/flag_aland");
            case "az": //azerbaijan
            return #imageLiteral(resourceName: "countryFlags/flag_azerbaijan");
            case "ba": //bosnia and herzegovina
            return #imageLiteral(resourceName: "countryFlags/flag_bosnia");
            case "bb": //barbados
            return #imageLiteral(resourceName: "countryFlags/flag_barbados");
            case "bd": //bangladesh
            return #imageLiteral(resourceName: "countryFlags/flag_bangladesh");
            case "be": //belgium
            return #imageLiteral(resourceName: "countryFlags/flag_belgium");
            case "bf": //burkina faso
            return #imageLiteral(resourceName: "countryFlags/flag_burkina_faso");
            case "bg": //bulgaria
            return #imageLiteral(resourceName: "countryFlags/flag_bulgaria");
            case "bh": //bahrain
            return #imageLiteral(resourceName: "countryFlags/flag_bahrain");
            case "bi": //burundi
            return #imageLiteral(resourceName: "countryFlags/flag_burundi");
            case "bj": //benin
            return #imageLiteral(resourceName: "countryFlags/flag_benin");
            case "bl": //saint barthélemy
            return #imageLiteral(resourceName: "countryFlags/flag_saint_barthelemy");// custom
            case "bm": //bermuda
            return #imageLiteral(resourceName: "countryFlags/flag_bermuda");
            case "bn": //brunei darussalam // custom
            return #imageLiteral(resourceName: "countryFlags/flag_brunei");
            case "bo": //bolivia, plurinational state of
            return #imageLiteral(resourceName: "countryFlags/flag_bolivia");
            case "br": //brazil
            return #imageLiteral(resourceName: "countryFlags/flag_brazil");
            case "bs": //bahamas
            return #imageLiteral(resourceName: "countryFlags/flag_bahamas");
            case "bt": //bhutan
            return #imageLiteral(resourceName: "countryFlags/flag_bhutan");
            case "bw": //botswana
            return #imageLiteral(resourceName: "countryFlags/flag_botswana");
            case "by": //belarus
            return #imageLiteral(resourceName: "countryFlags/flag_belarus");
            case "bz": //belize
            return #imageLiteral(resourceName: "countryFlags/flag_belize");
            case "ca": //canada
            return #imageLiteral(resourceName: "countryFlags/flag_canada");
            case "cc": //cocos (keeling) islands
            return #imageLiteral(resourceName: "countryFlags/flag_cocos");// custom
            case "cd": //congo, the democratic republic of the
            return #imageLiteral(resourceName: "countryFlags/flag_democratic_republic_of_the_congo");
            case "cf": //central african republic
            return #imageLiteral(resourceName: "countryFlags/flag_central_african_republic");
            case "cg": //congo
            return #imageLiteral(resourceName: "countryFlags/flag_republic_of_the_congo");
            case "ch": //switzerland
            return #imageLiteral(resourceName: "countryFlags/flag_switzerland");
            case "ci": //côte d\'ivoire
            return #imageLiteral(resourceName: "countryFlags/flag_cote_divoire");
            case "ck": //cook islands
            return #imageLiteral(resourceName: "countryFlags/flag_cook_islands");
            case "cl": //chile
            return #imageLiteral(resourceName: "countryFlags/flag_chile");
            case "cm": //cameroon
            return #imageLiteral(resourceName: "countryFlags/flag_cameroon");
            case "cn": //china
            return #imageLiteral(resourceName: "countryFlags/flag_china");
            case "co": //colombia
            return #imageLiteral(resourceName: "countryFlags/flag_colombia");
            case "cr": //costa rica
            return #imageLiteral(resourceName: "countryFlags/flag_costa_rica");
            case "cu": //cuba
            return #imageLiteral(resourceName: "countryFlags/flag_cuba");
            case "cv": //cape verde
            return #imageLiteral(resourceName: "countryFlags/flag_cape_verde");
            case "cx": //christmas island
            return #imageLiteral(resourceName: "countryFlags/flag_christmas_island");
            case "cy": //cyprus
            return #imageLiteral(resourceName: "countryFlags/flag_cyprus");
            case "cz": //czech republic
            return #imageLiteral(resourceName: "countryFlags/flag_czech_republic");
            case "de": //germany
            return #imageLiteral(resourceName: "countryFlags/flag_germany");
            case "dj": //djibouti
            return #imageLiteral(resourceName: "countryFlags/flag_djibouti");
            case "dk": //denmark
            return #imageLiteral(resourceName: "countryFlags/flag_denmark");
            case "dm": //dominica
            return #imageLiteral(resourceName: "countryFlags/flag_dominica");
            case "do": //dominican republic
            return #imageLiteral(resourceName: "countryFlags/flag_dominican_republic");
            case "dz": //algeria
            return #imageLiteral(resourceName: "countryFlags/flag_algeria");
            case "ec": //ecuador
            return #imageLiteral(resourceName: "countryFlags/flag_ecuador");
            case "ee": //estonia
            return #imageLiteral(resourceName: "countryFlags/flag_estonia");
            case "eg": //egypt
            return #imageLiteral(resourceName: "countryFlags/flag_egypt");
            case "er": //eritrea
            return #imageLiteral(resourceName: "countryFlags/flag_eritrea");
            case "es": //spain
            return #imageLiteral(resourceName: "countryFlags/flag_spain");
            case "et": //ethiopia
            return #imageLiteral(resourceName: "countryFlags/flag_ethiopia");
            case "fi": //finland
            return #imageLiteral(resourceName: "countryFlags/flag_finland");
            case "fj": //fiji
            return #imageLiteral(resourceName: "countryFlags/flag_fiji");
            case "fk": //falkland islands (malvinas)
            return #imageLiteral(resourceName: "countryFlags/flag_falkland_islands");
            case "fm": //micronesia, federated states of
            return #imageLiteral(resourceName: "countryFlags/flag_micronesia");
            case "fo": //faroe islands
            return #imageLiteral(resourceName: "countryFlags/flag_faroe_islands");
            case "fr": //france
            return #imageLiteral(resourceName: "countryFlags/flag_france");
            case "ga": //gabon
            return #imageLiteral(resourceName: "countryFlags/flag_gabon");
            case "gb": //united kingdom
            return #imageLiteral(resourceName: "countryFlags/flag_united_kingdom");
            case "gd": //grenada
            return #imageLiteral(resourceName: "countryFlags/flag_grenada");
            case "ge": //georgia
            return #imageLiteral(resourceName: "countryFlags/flag_georgia");
            case "gf": //guyane
            return #imageLiteral(resourceName: "countryFlags/flag_guyane");
            case "gg": //Guernsey
            return #imageLiteral(resourceName: "countryFlags/flag_guernsey");
            case "gh": //ghana
            return #imageLiteral(resourceName: "countryFlags/flag_ghana");
            case "gi": //gibraltar
            return #imageLiteral(resourceName: "countryFlags/flag_gibraltar");
            case "gl": //greenland
            return #imageLiteral(resourceName: "countryFlags/flag_greenland");
            case "gm": //gambia
            return #imageLiteral(resourceName: "countryFlags/flag_gambia");
            case "gn": //guinea
            return #imageLiteral(resourceName: "countryFlags/flag_guinea");
            case "gp": //guadeloupe
            return #imageLiteral(resourceName: "countryFlags/flag_guadeloupe");
            case "gq": //equatorial guinea
            return #imageLiteral(resourceName: "countryFlags/flag_equatorial_guinea");
            case "gr": //greece
            return #imageLiteral(resourceName: "countryFlags/flag_greece");
            case "gt": //guatemala
            return #imageLiteral(resourceName: "countryFlags/flag_guatemala");
            case "gu": //Guam
            return #imageLiteral(resourceName: "countryFlags/flag_guam");
            case "gw": //guinea-bissau
            return #imageLiteral(resourceName: "countryFlags/flag_guinea_bissau");
            case "gy": //guyana
            return #imageLiteral(resourceName: "countryFlags/flag_guyana");
            case "hk": //hong kong
            return #imageLiteral(resourceName: "countryFlags/flag_hong_kong");
            case "hn": //honduras
            return #imageLiteral(resourceName: "countryFlags/flag_honduras");
            case "hr": //croatia
            return #imageLiteral(resourceName: "countryFlags/flag_croatia");
            case "ht": //haiti
            return #imageLiteral(resourceName: "countryFlags/flag_haiti");
            case "hu": //hungary
            return #imageLiteral(resourceName: "countryFlags/flag_hungary");
            case "id": //indonesia
            return #imageLiteral(resourceName: "countryFlags/flag_indonesia");
            case "ie": //ireland
            return #imageLiteral(resourceName: "countryFlags/flag_ireland");
            case "il": //israel
            return #imageLiteral(resourceName: "countryFlags/flag_israel");
            case "im": //isle of man
            return #imageLiteral(resourceName: "countryFlags/flag_isleof_man"); // custom
            case "is": //Iceland
            return #imageLiteral(resourceName: "countryFlags/flag_iceland");
            case "in": //india
            return #imageLiteral(resourceName: "countryFlags/flag_india");
            case "io": //British indian ocean territory
            return #imageLiteral(resourceName: "countryFlags/flag_british_indian_ocean_territory");
            case "iq": //iraq
            return #imageLiteral(resourceName: "countryFlags/flag_iraq_new");
            case "ir": //iran, islamic republic of
            return #imageLiteral(resourceName: "countryFlags/flag_iran");
            case "it": //italy
            return #imageLiteral(resourceName: "countryFlags/flag_italy");
            case "je": //Jersey
            return #imageLiteral(resourceName: "countryFlags/flag_jersey");
            case "jm": //jamaica
            return #imageLiteral(resourceName: "countryFlags/flag_jamaica");
            case "jo": //jordan
            return #imageLiteral(resourceName: "countryFlags/flag_jordan");
            case "jp": //japan
            return #imageLiteral(resourceName: "countryFlags/flag_japan");
            case "ke": //kenya
            return #imageLiteral(resourceName: "countryFlags/flag_kenya");
            case "kg": //kyrgyzstan
            return #imageLiteral(resourceName: "countryFlags/flag_kyrgyzstan");
            case "kh": //cambodia
            return #imageLiteral(resourceName: "countryFlags/flag_cambodia");
            case "ki": //kiribati
            return #imageLiteral(resourceName: "countryFlags/flag_kiribati");
            case "km": //comoros
            return #imageLiteral(resourceName: "countryFlags/flag_comoros");
            case "kn": //st kitts & nevis
            return #imageLiteral(resourceName: "countryFlags/flag_saint_kitts_and_nevis");
            case "kp": //north korea
            return #imageLiteral(resourceName: "countryFlags/flag_north_korea");
            case "kr": //south korea
            return #imageLiteral(resourceName: "countryFlags/flag_south_korea");
            case "kw": //kuwait
            return #imageLiteral(resourceName: "countryFlags/flag_kuwait");
            case "ky": //Cayman_Islands
            return #imageLiteral(resourceName: "countryFlags/flag_cayman_islands");
            case "kz": //kazakhstan
            return #imageLiteral(resourceName: "countryFlags/flag_kazakhstan");
            case "la": //lao people\'s democratic republic
            return #imageLiteral(resourceName: "countryFlags/flag_laos");
            case "lb": //lebanon
            return #imageLiteral(resourceName: "countryFlags/flag_lebanon");
            case "lc": //st lucia
            return #imageLiteral(resourceName: "countryFlags/flag_saint_lucia");
            case "li": //liechtenstein
            return #imageLiteral(resourceName: "countryFlags/flag_liechtenstein");
            case "lk": //sri lanka
            return #imageLiteral(resourceName: "countryFlags/flag_sri_lanka");
            case "lr": //liberia
            return #imageLiteral(resourceName: "countryFlags/flag_liberia");
            case "ls": //lesotho
            return #imageLiteral(resourceName: "countryFlags/flag_lesotho");
            case "lt": //lithuania
            return #imageLiteral(resourceName: "countryFlags/flag_lithuania");
            case "lu": //luxembourg
            return #imageLiteral(resourceName: "countryFlags/flag_luxembourg");
            case "lv": //latvia
            return #imageLiteral(resourceName: "countryFlags/flag_latvia");
            case "ly": //libya
            return #imageLiteral(resourceName: "countryFlags/flag_libya");
            case "ma": //morocco
            return #imageLiteral(resourceName: "countryFlags/flag_morocco");
            case "mc": //monaco
            return #imageLiteral(resourceName: "countryFlags/flag_monaco");
            case "md": //moldova, republic of
            return #imageLiteral(resourceName: "countryFlags/flag_moldova");
            case "me": //montenegro
            return #imageLiteral(resourceName: "countryFlags/flag_of_montenegro");// custom
            case "mf":
            return #imageLiteral(resourceName: "countryFlags/flag_saint_martin");
            case "mg": //madagascar
            return #imageLiteral(resourceName: "countryFlags/flag_madagascar");
            case "mh": //marshall islands
            return #imageLiteral(resourceName: "countryFlags/flag_marshall_islands");
            case "mk": //macedonia, the former yugoslav republic of
            return #imageLiteral(resourceName: "countryFlags/flag_macedonia");
            case "ml": //mali
            return #imageLiteral(resourceName: "countryFlags/flag_mali");
            case "mm": //myanmar
            return #imageLiteral(resourceName: "countryFlags/flag_myanmar");
            case "mn": //mongolia
            return #imageLiteral(resourceName: "countryFlags/flag_mongolia");
            case "mo": //macao
            return #imageLiteral(resourceName: "countryFlags/flag_macao");
            case "mp": // Northern mariana islands
            return #imageLiteral(resourceName: "countryFlags/flag_northern_mariana_islands");
            case "mq": //martinique
            return #imageLiteral(resourceName: "countryFlags/flag_martinique");
            case "mr": //mauritania
            return #imageLiteral(resourceName: "countryFlags/flag_mauritania");
            case "ms": //montserrat
            return #imageLiteral(resourceName: "countryFlags/flag_montserrat");
            case "mt": //malta
            return #imageLiteral(resourceName: "countryFlags/flag_malta");
            case "mu": //mauritius
            return #imageLiteral(resourceName: "countryFlags/flag_mauritius");
            case "mv": //maldives
            return #imageLiteral(resourceName: "countryFlags/flag_maldives");
            case "mw": //malawi
            return #imageLiteral(resourceName: "countryFlags/flag_malawi");
            case "mx": //mexico
            return #imageLiteral(resourceName: "countryFlags/flag_mexico");
            case "my": //malaysia
            return #imageLiteral(resourceName: "countryFlags/flag_malaysia");
            case "mz": //mozambique
            return #imageLiteral(resourceName: "countryFlags/flag_mozambique");
            case "na": //namibia
            return #imageLiteral(resourceName: "countryFlags/flag_namibia");
            case "nc": //new caledonia
            return #imageLiteral(resourceName: "countryFlags/flag_new_caledonia");// custom
            case "ne": //niger
            return #imageLiteral(resourceName: "countryFlags/flag_niger");
            case "nf": //Norfolk
            return #imageLiteral(resourceName: "countryFlags/flag_norfolk_island");
            case "ng": //nigeria
            return #imageLiteral(resourceName: "countryFlags/flag_nigeria");
            case "ni": //nicaragua
            return #imageLiteral(resourceName: "countryFlags/flag_nicaragua");
            case "nl": //netherlands
            return #imageLiteral(resourceName: "countryFlags/flag_netherlands");
            case "no": //norway
            return #imageLiteral(resourceName: "countryFlags/flag_norway");
            case "np": //nepal
            return #imageLiteral(resourceName: "countryFlags/flag_nepal");
            case "nr": //nauru
            return #imageLiteral(resourceName: "countryFlags/flag_nauru");
            case "nu": //niue
            return #imageLiteral(resourceName: "countryFlags/flag_niue");
            case "nz": //new zealand
            return #imageLiteral(resourceName: "countryFlags/flag_new_zealand");
            case "om": //oman
            return #imageLiteral(resourceName: "countryFlags/flag_oman");
            case "pa": //panama
            return #imageLiteral(resourceName: "countryFlags/flag_panama");
            case "pe": //peru
            return #imageLiteral(resourceName: "countryFlags/flag_peru");
            case "pf": //french polynesia
            return #imageLiteral(resourceName: "countryFlags/flag_french_polynesia");
            case "pg": //papua new guinea
            return #imageLiteral(resourceName: "countryFlags/flag_papua_new_guinea");
            case "ph": //philippines
            return #imageLiteral(resourceName: "countryFlags/flag_philippines");
            case "pk": //pakistan
            return #imageLiteral(resourceName: "countryFlags/flag_pakistan");
            case "pl": //poland
            return #imageLiteral(resourceName: "countryFlags/flag_poland");
            case "pm": //saint pierre and miquelon
            return #imageLiteral(resourceName: "countryFlags/flag_saint_pierre");
            case "pn": //pitcairn
            return #imageLiteral(resourceName: "countryFlags/flag_pitcairn_islands");
            case "pr": //puerto rico
            return #imageLiteral(resourceName: "countryFlags/flag_puerto_rico");
            case "ps": //palestine
            return #imageLiteral(resourceName: "countryFlags/flag_palestine");
            case "pt": //portugal
            return #imageLiteral(resourceName: "countryFlags/flag_portugal");
            case "pw": //palau
            return #imageLiteral(resourceName: "countryFlags/flag_palau");
            case "py": //paraguay
            return #imageLiteral(resourceName: "countryFlags/flag_paraguay");
            case "qa": //qatar
            return #imageLiteral(resourceName: "countryFlags/flag_qatar");
            case "re": //la reunion
            return #imageLiteral(resourceName: "countryFlags/flag_martinique"); // no exact flag found
            case "ro": //romania
            return #imageLiteral(resourceName: "countryFlags/flag_romania");
            case "rs": //serbia
            return #imageLiteral(resourceName: "countryFlags/flag_serbia"); // custom
            case "ru": //russian federation
            return #imageLiteral(resourceName: "countryFlags/flag_russian_federation");
            case "rw": //rwanda
            return #imageLiteral(resourceName: "countryFlags/flag_rwanda");
            case "sa": //saudi arabia
            return #imageLiteral(resourceName: "countryFlags/flag_saudi_arabia");
            case "sb": //solomon islands
            return #imageLiteral(resourceName: "countryFlags/flag_soloman_islands");
            case "sc": //seychelles
            return #imageLiteral(resourceName: "countryFlags/flag_seychelles");
            case "sd": //sudan
            return #imageLiteral(resourceName: "countryFlags/flag_sudan");
            case "se": //sweden
            return #imageLiteral(resourceName: "countryFlags/flag_sweden");
            case "sg": //singapore
            return #imageLiteral(resourceName: "countryFlags/flag_singapore");
            case "sh": //saint helena, ascension and tristan da cunha
            return #imageLiteral(resourceName: "countryFlags/flag_saint_helena"); // custom
            case "si": //slovenia
            return #imageLiteral(resourceName: "countryFlags/flag_slovenia");
            case "sk": //slovakia
            return #imageLiteral(resourceName: "countryFlags/flag_slovakia");
            case "sl": //sierra leone
            return #imageLiteral(resourceName: "countryFlags/flag_sierra_leone");
            case "sm": //san marino
            return #imageLiteral(resourceName: "countryFlags/flag_san_marino");
            case "sn": //senegal
            return #imageLiteral(resourceName: "countryFlags/flag_senegal");
            case "so": //somalia
            return #imageLiteral(resourceName: "countryFlags/flag_somalia");
            case "sr": //suriname
            return #imageLiteral(resourceName: "countryFlags/flag_suriname");
            case "st": //sao tome and principe
            return #imageLiteral(resourceName: "countryFlags/flag_sao_tome_and_principe");
            case "sv": //el salvador
            return #imageLiteral(resourceName: "countryFlags/flag_el_salvador");
            case "sx": //sint maarten
            return #imageLiteral(resourceName: "countryFlags/flag_sint_maarten");
            case "sy": //syrian arab republic
            return #imageLiteral(resourceName: "countryFlags/flag_syria");
            case "sz": //swaziland
            return #imageLiteral(resourceName: "countryFlags/flag_swaziland");
            case "tc": //turks & caicos islands
            return #imageLiteral(resourceName: "countryFlags/flag_turks_and_caicos_islands");
            case "td": //chad
            return #imageLiteral(resourceName: "countryFlags/flag_chad");
            case "tg": //togo
            return #imageLiteral(resourceName: "countryFlags/flag_togo");
            case "th": //thailand
            return #imageLiteral(resourceName: "countryFlags/flag_thailand");
            case "tj": //tajikistan
            return #imageLiteral(resourceName: "countryFlags/flag_tajikistan");
            case "tk": //tokelau
            return #imageLiteral(resourceName: "countryFlags/flag_tokelau"); // custom
            case "tl": //timor-leste
            return #imageLiteral(resourceName: "countryFlags/flag_timor_leste");
            case "tm": //turkmenistan
            return #imageLiteral(resourceName: "countryFlags/flag_turkmenistan");
            case "tn": //tunisia
            return #imageLiteral(resourceName: "countryFlags/flag_tunisia");
            case "to": //tonga
            return #imageLiteral(resourceName: "countryFlags/flag_tonga");
            case "tr": //turkey
            return #imageLiteral(resourceName: "countryFlags/flag_turkey");
            case "tt": //trinidad & tobago
            return #imageLiteral(resourceName: "countryFlags/flag_trinidad_and_tobago");
            case "tv": //tuvalu
            return #imageLiteral(resourceName: "countryFlags/flag_tuvalu");
            case "tw": //taiwan, province of china
            return #imageLiteral(resourceName: "countryFlags/flag_taiwan");
            case "tz": //tanzania, united republic of
            return #imageLiteral(resourceName: "countryFlags/flag_tanzania");
            case "ua": //ukraine
            return #imageLiteral(resourceName: "countryFlags/flag_ukraine");
            case "ug": //uganda
            return #imageLiteral(resourceName: "countryFlags/flag_uganda");
            case "us": //united states
            return #imageLiteral(resourceName: "countryFlags/flag_united_states_of_america");
            case "uy": //uruguay
            return #imageLiteral(resourceName: "countryFlags/flag_uruguay");
            case "uz": //uzbekistan
            return #imageLiteral(resourceName: "countryFlags/flag_uzbekistan");
            case "va": //holy see (vatican city state)
            return #imageLiteral(resourceName: "countryFlags/flag_vatican_city");
            case "vc": //st vincent & the grenadines
            return #imageLiteral(resourceName: "countryFlags/flag_saint_vicent_and_the_grenadines");
            case "ve": //venezuela, bolivarian republic of
            return #imageLiteral(resourceName: "countryFlags/flag_venezuela");
            case "vg": //british virgin islands
            return #imageLiteral(resourceName: "countryFlags/flag_british_virgin_islands");
            case "vi": //us virgin islands
            return #imageLiteral(resourceName: "countryFlags/flag_us_virgin_islands");
            case "vn": //vietnam
            return #imageLiteral(resourceName: "countryFlags/flag_vietnam");
            case "vu": //vanuatu
            return #imageLiteral(resourceName: "countryFlags/flag_vanuatu");
            case "wf": //wallis and futuna
            return #imageLiteral(resourceName: "countryFlags/flag_wallis_and_futuna");
            case "ws": //samoa
            return #imageLiteral(resourceName: "countryFlags/flag_samoa");
            case "xk": //kosovo
            return #imageLiteral(resourceName: "countryFlags/flag_kosovo");
            case "ye": //yemen
            return #imageLiteral(resourceName: "countryFlags/flag_yemen");
            case "yt": //mayotte
            return #imageLiteral(resourceName: "countryFlags/flag_martinique"); // no exact flag found
            case "za": //south africa
            return #imageLiteral(resourceName: "countryFlags/flag_south_africa");
            case "zm": //zambia
            return #imageLiteral(resourceName: "countryFlags/flag_zambia");
            case "zw": //zimbabwe
            return #imageLiteral(resourceName: "countryFlags/flag_zimbabwe");
            default:
            return #imageLiteral(resourceName: "countryFlags/flag_transparent");
        }
    }
    
    func getLibraryMasterCountriesEnglish() -> [CountryCodeService] {
    var countries: [CountryCodeService] = [];
        countries.append(getCountryCodeService(nameCode: "ad", phoneCode: "+376", name: "Andorra", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ae", phoneCode: "+971", name: "United Arab Emirates (UAE)", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "af", phoneCode: "+93", name: "Afghanistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ag", phoneCode: "+1", name: "Antigua and Barbuda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ai", phoneCode: "+1", name: "Anguilla", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "al", phoneCode: "+355", name: "Albania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "am", phoneCode: "+374", name: "Armenia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ao", phoneCode: "+244", name: "Angola", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "aq", phoneCode: "+672", name: "Antarctica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ar", phoneCode: "+54", name: "Argentina", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "as", phoneCode: "+1", name: "American Samoa", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "at", phoneCode: "+43", name: "Austria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "au", phoneCode: "+61", name: "Australia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "aw", phoneCode: "+297", name: "Aruba", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "az", phoneCode: "+358", name: "Aland Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "az", phoneCode: "+994", name: "Azerbaijan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ba", phoneCode: "+387", name: "Bosnia And Herzegovina", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bb", phoneCode: "+1", name: "Barbados", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bd", phoneCode: "+880", name: "Bangladesh", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "be", phoneCode: "+32", name: "Belgium", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bf", phoneCode: "+226", name: "Burkina Faso", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bg", phoneCode: "+359", name: "Bulgaria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bh", phoneCode: "+973", name: "Bahrain", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bi", phoneCode: "+257", name: "Burundi", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bj", phoneCode: "+229", name: "Benin", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bl", phoneCode: "+590", name: "Saint Barthélemy", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bm", phoneCode: "+1", name: "Bermuda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bn", phoneCode: "+673", name: "Brunei Darussalam", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bo", phoneCode: "+591", name: "Bolivia, Plurinational State Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "br", phoneCode: "+55", name: "Brazil", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bs", phoneCode: "+1", name: "Bahamas", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bt", phoneCode: "+975", name: "Bhutan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bw", phoneCode: "+267", name: "Botswana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "by", phoneCode: "+375", name: "Belarus", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bz", phoneCode: "+501", name: "Belize", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ca", phoneCode: "+1", name: "Canada", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cc", phoneCode: "+61", name: "Cocos (keeling) Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cd", phoneCode: "+243", name: "Congo, The Democratic Republic Of The", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cf", phoneCode: "+236", name: "Central African Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cg", phoneCode: "+242", name: "Congo", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ch", phoneCode: "+41", name: "Switzerland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ci", phoneCode: "+225", name: "Côte D'ivoire", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ck", phoneCode: "+682", name: "Cook Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cl", phoneCode: "+56", name: "Chile", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cm", phoneCode: "+237", name: "Cameroon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cn", phoneCode: "+86", name: "China", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "co", phoneCode: "+57", name: "Colombia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cr", phoneCode: "+506", name: "Costa Rica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cu", phoneCode: "+53", name: "Cuba", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cv", phoneCode: "+238", name: "Cape Verde", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cx", phoneCode: "+61", name: "Christmas Island", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cy", phoneCode: "+357", name: "Cyprus", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cz", phoneCode: "+420", name: "Czech Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "de", phoneCode: "+49", name: "Germany", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dj", phoneCode: "+253", name: "Djibouti", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dk", phoneCode: "+45", name: "Denmark", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dm", phoneCode: "+1", name: "Dominica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "do", phoneCode: "+1", name: "Dominican Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dz", phoneCode: "+213", name: "Algeria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ec", phoneCode: "+593", name: "Ecuador", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ee", phoneCode: "+372", name: "Estonia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "eg", phoneCode: "+20", name: "Egypt", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "er", phoneCode: "+291", name: "Eritrea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "es", phoneCode: "+34", name: "Spain", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "et", phoneCode: "+251", name: "Ethiopia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fi", phoneCode: "+358", name: "Finland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fj", phoneCode: "+679", name: "Fiji", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fk", phoneCode: "+500", name: "Falkland Islands (malvinas)", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fm", phoneCode: "+691", name: "Micronesia, Federated States Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fo", phoneCode: "+298", name: "Faroe Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fr", phoneCode: "+33", name: "France", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ga", phoneCode: "+241", name: "Gabon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gb", phoneCode: "+44", name: "United Kingdom", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gd", phoneCode: "+1", name: "Grenada", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ge", phoneCode: "+995", name: "Georgia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gf", phoneCode: "+594", name: "French Guyana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gh", phoneCode: "+233", name: "Ghana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gi", phoneCode: "+350", name: "Gibraltar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gl", phoneCode: "+299", name: "Greenland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gm", phoneCode: "+220", name: "Gambia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gn", phoneCode: "+224", name: "Guinea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gp", phoneCode: "+450", name: "Guadeloupe", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gq", phoneCode: "+240", name: "Equatorial Guinea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gr", phoneCode: "+30", name: "Greece", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gt", phoneCode: "+502", name: "Guatemala", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gu", phoneCode: "+1", name: "Guam", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gw", phoneCode: "+245", name: "Guinea-bissau", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gy", phoneCode: "+592", name: "Guyana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hk", phoneCode: "+852", name: "Hong Kong", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hn", phoneCode: "+504", name: "Honduras", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hr", phoneCode: "+385", name: "Croatia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ht", phoneCode: "+509", name: "Haiti", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hu", phoneCode: "+36", name: "Hungary", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "id", phoneCode: "+62", name: "Indonesia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ie", phoneCode: "+353", name: "Ireland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "il", phoneCode: "+972", name: "Israel", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "im", phoneCode: "+44", name: "Isle Of Man", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "is", phoneCode: "+354", name: "Iceland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "in", phoneCode: "+91", name: "India", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "io", phoneCode: "+246", name: "British Indian Ocean Territory", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "iq", phoneCode: "+964", name: "Iraq", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ir", phoneCode: "+98", name: "Iran, Islamic Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "it", phoneCode: "+39", name: "Italy", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "je", phoneCode: "+44", name: "Jersey ", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "jm", phoneCode: "+1", name: "Jamaica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "jo", phoneCode: "+962", name: "Jordan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "jp", phoneCode: "+81", name: "Japan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ke", phoneCode: "+254", name: "Kenya", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kg", phoneCode: "+996", name: "Kyrgyzstan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kh", phoneCode: "+855", name: "Cambodia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ki", phoneCode: "+686", name: "Kiribati", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "km", phoneCode: "+269", name: "Comoros", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kn", phoneCode: "+1", name: "Saint Kitts and Nevis", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kp", phoneCode: "+850", name: "North Korea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kr", phoneCode: "+82", name: "South Korea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kw", phoneCode: "+965", name: "Kuwait", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ky", phoneCode: "+1", name: "Cayman Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kz", phoneCode: "+7", name: "Kazakhstan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "la", phoneCode: "+856", name: "Lao People's Democratic Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lb", phoneCode: "+961", name: "Lebanon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lc", phoneCode: "+1", name: "Saint Lucia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "li", phoneCode: "+423", name: "Liechtenstein", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lk", phoneCode: "+94", name: "Sri Lanka", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lr", phoneCode: "+231", name: "Liberia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ls", phoneCode: "+266", name: "Lesotho", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lt", phoneCode: "+370", name: "Lithuania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lu", phoneCode: "+352", name: "Luxembourg", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lv", phoneCode: "+371", name: "Latvia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ly", phoneCode: "+218", name: "Libya", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ma", phoneCode: "+212", name: "Morocco", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mc", phoneCode: "+377", name: "Monaco", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "md", phoneCode: "+373", name: "Moldova, Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "me", phoneCode: "+382", name: "Montenegro", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mf", phoneCode: "+590", name: "Saint Martin", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mg", phoneCode: "+261", name: "Madagascar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mh", phoneCode: "+692", name: "Marshall Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mk", phoneCode: "+389", name: "Macedonia, The Former Yugoslav Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ml", phoneCode: "+223", name: "Mali", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mm", phoneCode: "+95", name: "Myanmar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mn", phoneCode: "+976", name: "Mongolia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mo", phoneCode: "+853", name: "Macao", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mp", phoneCode: "+1", name: "Northern Mariana Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mq", phoneCode: "+596", name: "Martinique", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mr", phoneCode: "+222", name: "Mauritania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ms", phoneCode: "+1", name: "Montserrat", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mt", phoneCode: "+356", name: "Malta", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mu", phoneCode: "+230", name: "Mauritius", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mv", phoneCode: "+960", name: "Maldives", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mw", phoneCode: "+265", name: "Malawi", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mx", phoneCode: "+52", name: "Mexico", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "my", phoneCode: "+60", name: "Malaysia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mz", phoneCode: "+258", name: "Mozambique", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "na", phoneCode: "+264", name: "Namibia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nc", phoneCode: "+687", name: "New Caledonia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ne", phoneCode: "+227", name: "Niger", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nf", phoneCode: "+672", name: "Norfolk Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ng", phoneCode: "+234", name: "Nigeria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ni", phoneCode: "+505", name: "Nicaragua", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nl", phoneCode: "+31", name: "Netherlands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "no", phoneCode: "+47", name: "Norway", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "np", phoneCode: "+977", name: "Nepal", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nr", phoneCode: "+674", name: "Nauru", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nu", phoneCode: "+683", name: "Niue", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nz", phoneCode: "+64", name: "New Zealand", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "om", phoneCode: "+968", name: "Oman", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pa", phoneCode: "+507", name: "Panama", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pe", phoneCode: "+51", name: "Peru", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pf", phoneCode: "+689", name: "French Polynesia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pg", phoneCode: "+675", name: "Papua New Guinea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ph", phoneCode: "+63", name: "Philippines", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pk", phoneCode: "+92", name: "Pakistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pl", phoneCode: "+48", name: "Poland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pm", phoneCode: "+508", name: "Saint Pierre And Miquelon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pn", phoneCode: "+870", name: "Pitcairn", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pr", phoneCode: "+1", name: "Puerto Rico", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ps", phoneCode: "+970", name: "Palestine", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pt", phoneCode: "+351", name: "Portugal", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pw", phoneCode: "+680", name: "Palau", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "py", phoneCode: "+595", name: "Paraguay", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "qa", phoneCode: "+974", name: "Qatar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "re", phoneCode: "+262", name: "Réunion", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ro", phoneCode: "+40", name: "Romania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "rs", phoneCode: "+381", name: "Serbia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ru", phoneCode: "+7", name: "Russian Federation", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "rw", phoneCode: "+250", name: "Rwanda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sa", phoneCode: "+966", name: "Saudi Arabia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sb", phoneCode: "+677", name: "Solomon Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sc", phoneCode: "+248", name: "Seychelles", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sd", phoneCode: "+249", name: "Sudan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "se", phoneCode: "+46", name: "Sweden", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sg", phoneCode: "+65", name: "Singapore", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sh", phoneCode: "+290", name: "Saint Helena, Ascension And Tristan Da Cunha", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "si", phoneCode: "+386", name: "Slovenia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sk", phoneCode: "+421", name: "Slovakia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sl", phoneCode: "+232", name: "Sierra Leone", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sm", phoneCode: "+378", name: "San Marino", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sn", phoneCode: "+221", name: "Senegal", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "so", phoneCode: "+252", name: "Somalia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sr", phoneCode: "+597", name: "Suriname", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "st", phoneCode: "+239", name: "Sao Tome And Principe", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sv", phoneCode: "+503", name: "El Salvador", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sx", phoneCode: "+1", name: "Sint Maarten", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sy", phoneCode: "+963", name: "Syrian Arab Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sz", phoneCode: "+268", name: "Swaziland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tc", phoneCode: "+1", name: "Turks and Caicos Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "td", phoneCode: "+235", name: "Chad", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tg", phoneCode: "+228", name: "Togo", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "th", phoneCode: "+66", name: "Thailand", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tj", phoneCode: "+992", name: "Tajikistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tk", phoneCode: "+690", name: "Tokelau", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tl", phoneCode: "+670", name: "Timor-leste", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tm", phoneCode: "+993", name: "Turkmenistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tn", phoneCode: "+216", name: "Tunisia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "to", phoneCode: "+676", name: "Tonga", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tr", phoneCode: "+90", name: "Turkey", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tt", phoneCode: "+1", name: "Trinidad &amp; Tobago", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tv", phoneCode: "+688", name: "Tuvalu", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tw", phoneCode: "+886", name: "Taiwan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tz", phoneCode: "+255", name: "Tanzania, United Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ua", phoneCode: "+380", name: "Ukraine", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ug", phoneCode: "+256", name: "Uganda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "us", phoneCode: "+1", name: "United States", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "uy", phoneCode: "+598", name: "Uruguay", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "uz", phoneCode: "+998", name: "Uzbekistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "va", phoneCode: "+379", name: "Holy See (vatican City State)", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vc", phoneCode: "+1", name: "Saint Vincent &amp; The Grenadines", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ve", phoneCode: "+58", name: "Venezuela, Bolivarian Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vg", phoneCode: "+1", name: "British Virgin Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vi", phoneCode: "+1", name: "US Virgin Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vn", phoneCode: "+84", name: "Viet Nam", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vu", phoneCode: "+678", name: "Vanuatu", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "wf", phoneCode: "+681", name: "Wallis And Futuna", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ws", phoneCode: "+685", name: "Samoa", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "xk", phoneCode: "+383", name: "Kosovo", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ye", phoneCode: "+967", name: "Yemen", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "yt", phoneCode: "+262", name: "Mayotte", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "za", phoneCode: "+27", name: "South Africa", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "zm", phoneCode: "+260", name: "Zambia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "zw", phoneCode: "+263", name: "Zimbabwe", flagResID: DEFAULT_FLAG_RES));
        return countries;
    }
}
