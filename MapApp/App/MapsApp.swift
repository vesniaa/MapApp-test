//
//  Maps.swift
//  MapApp
//
//  Created by Евгения Аникина on 21.06.2022.
//

import Foundation

struct MapsApp: Codable {
    let points: [Points]
    let lines: [Line]
    
    enum CodingKeys: String, CodingKey {
        case points = "Points"
        case lines = "Lines"
    }
}

struct Points: Codable {
    let type: LineType
    let id: String
    let properties: PointProperties
    let geometry: PointGeometry
}

struct Line: Codable {
    let type: LineType
    let properties: LineProperties
    let geometry: LineGeometry
}

struct LineGeometry: Codable {
    let type: PurpleType
    let coordinates: [[Double]]
}

enum PurpleType: String, Codable {
    case lineString = "LineString"
}

struct LineProperties: Codable {
    let subClasses: SubClasses

    enum CodingKeys: String, CodingKey {
        case subClasses = "SubClasses"
    }
}

enum SubClasses: String, Codable {
    case acDbEntityAcDbPolyline = "AcDbEntity:AcDbPolyline"
}

enum LineType: String, Codable {
    case feature = "Feature"
}

struct PointGeometry: Codable {
    let type: FluffyType
    let coordinates: [Double]
}

enum FluffyType: String, Codable {
    case point = "Point"
}

struct PointProperties: Codable {
    let name, propertiesDescription: String
    let created: Created
    let modified: String
    let color: [Double]
    let visible: Bool
    let latitude, longitude, elevation: Double

    enum CodingKeys: String, CodingKey {
        case name
        case propertiesDescription = "description"
        case created, modified, color, visible, latitude, longitude, elevation
    }
}

enum Created: String, Codable {
    case the20210616T084937 = "2021-06-16T08:49:37"
}

enum Link: String {
    case mapsAppApi = "http://a0532495.xsph.ru/getPoint"
}
