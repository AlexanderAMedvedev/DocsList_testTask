//
//  ModelAllData.swift
//  DocsList
//
//  Created by Александр Медведев on 12.04.2024.
//

import Foundation

struct AllData: Decodable {
    let record: Record
}

struct Record: Decodable {
    let data: DataPieces
}

struct DataPieces: Decodable {
    let users: [User]
}

struct User: Decodable {
    let lastName: String
    let firstName: String
    let patronymic: String
    let ratingsRating: Double
    let seniority: Int
    let textChatPrice: Int
    let videoChatPrice: Int
    let homePrice: Int
    let hospitalPrice: Int
    let avatar: String?
    let freeReceptionTime: [Time]
    let specialization: [Specialization]
    let higherEducation: [HigherEducation]
    let workExpirience: [WorkPlace]
    let scientificDegreeLabel: String
}

struct Specialization: Decodable  {
    let name: String
}

struct Time: Decodable {
    let time: Int
}

struct HigherEducation: Decodable {
    let university: String
}

struct WorkPlace: Decodable {
    let organization: String
}
