//
//  Film.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 08/06/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class Film: NSObject, NSCoding {

    var id_seance: String
    var id_film: String
    var titre: String
    var date: Date
    var horaire: String
    var troisD: Bool
    var vo: Bool
    var moinsDouze: Bool
    var avertissement: Bool
    var artEssai: Bool
    var affiche: String
    var duree: String
    var annee: String
    var pays: String
    var style: String
    var de: String
    var avec: String
    var synopsis: String
    var bandeAnnonce: String
    var autresDates : [AutresDates]
    
    override init() {
        
        self.id_seance = ""
        self.id_film = ""
        self.titre = ""
        self.date = Date()
        self.horaire = ""
        self.troisD = false
        self.vo = false
        self.moinsDouze = false
        self.avertissement = false
        self.artEssai = false
        self.affiche = ""
        self.duree = ""
        self.annee = ""
        self.pays = ""
        self.style = ""
        self.de = ""
        self.avec = ""
        self.synopsis = ""
        self.bandeAnnonce = ""
        self.autresDates = [AutresDates]()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id_seance, forKey: "id_seance")
        aCoder.encode(id_film, forKey: "id_film")
        aCoder.encode(titre, forKey: "titre")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(horaire, forKey: "horaire")
        aCoder.encode(troisD, forKey: "troisD")
        aCoder.encode(vo, forKey: "vo")
        aCoder.encode(moinsDouze, forKey: "moinsDouze")
        aCoder.encode(avertissement, forKey: "avertissement")
        aCoder.encode(artEssai, forKey: "artEssai")
        aCoder.encode(affiche, forKey: "affiche")
        aCoder.encode(duree, forKey: "duree")
        aCoder.encode(annee, forKey: "annee")
        aCoder.encode(pays, forKey: "pays")
        aCoder.encode(style, forKey: "style")
        aCoder.encode(de, forKey: "de")
        aCoder.encode(avec, forKey: "avec")
        aCoder.encode(synopsis, forKey: "synopsis")
        aCoder.encode(bandeAnnonce, forKey: "bandeAnnonce")
        aCoder.encode(autresDates, forKey: "autresDates")
    }
    
    required init?(coder aDecoder: NSCoder) {
        date = Date()
        id_seance = aDecoder.decodeObject(forKey: "id_seance") != nil ? aDecoder.decodeObject(forKey: "id_seance") as! String : ""
        id_film = aDecoder.decodeObject(forKey: "id_film") != nil ? aDecoder.decodeObject(forKey: "id_film") as! String : ""
        titre = aDecoder.decodeObject(forKey: "titre") != nil ? aDecoder.decodeObject(forKey: "titre") as! String : ""
        horaire = aDecoder.decodeObject(forKey: "horaire") != nil ? aDecoder.decodeObject(forKey: "horaire") as! String : ""
        troisD = aDecoder.decodeBool(forKey: "troisD")
        vo = aDecoder.decodeBool(forKey: "vo")
        moinsDouze = aDecoder.decodeBool(forKey: "moinsDouze")
        avertissement = aDecoder.decodeBool(forKey: "avertissement")
        artEssai = aDecoder.decodeBool(forKey: "artEssai")
        
        affiche = aDecoder.decodeObject(forKey: "affiche") != nil ? aDecoder.decodeObject(forKey: "affiche") as! String : ""
        duree = aDecoder.decodeObject(forKey: "duree") != nil ? aDecoder.decodeObject(forKey: "duree") as! String : ""
        annee = aDecoder.decodeObject(forKey: "annee") != nil ? aDecoder.decodeObject(forKey: "annee") as! String : ""
        pays = aDecoder.decodeObject(forKey: "pays") != nil ? aDecoder.decodeObject(forKey: "pays") as! String : ""
        style = aDecoder.decodeObject(forKey: "style") != nil ? aDecoder.decodeObject(forKey: "style") as! String : ""
        de = aDecoder.decodeObject(forKey: "de") != nil ? aDecoder.decodeObject(forKey: "de") as! String : ""
        avec = aDecoder.decodeObject(forKey: "avec") != nil ? aDecoder.decodeObject(forKey: "avec") as! String : ""
        synopsis = aDecoder.decodeObject(forKey: "synopsis") != nil ? aDecoder.decodeObject(forKey: "synopsis") as! String : ""
        bandeAnnonce = aDecoder.decodeObject(forKey: "bandeAnnonce") != nil ? aDecoder.decodeObject(forKey: "bandeAnnonce") as! String : ""
        
        autresDates = aDecoder.decodeObject(forKey: "autresDates") as! [AutresDates]
    }
}
