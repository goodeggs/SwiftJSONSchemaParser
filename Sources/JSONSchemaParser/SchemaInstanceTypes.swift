import Foundation

public enum SchemaTypeName: String, Decodable {
    case null
    case boolean
    case object
    case array
    case number
    case string
    case integer
}

/**
 https://tools.ietf.org/html/draft-zyp-json-schema-04#section-3.7
 3.7.  Instance

 An instance is any JSON value.  An instance may be described by one
 or more schemas.

 An instance may also be referred to as "JSON instance", or "JSON
 data".
 */
public enum JSONSchemaInstance: Decodable {
    case null
    case boolean(Bool)
    case object([String: JSONSchemaInstance])
    case array([JSONSchemaInstance])
    case number(Double)
    case integer(Int)
    case string(String)


    public init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(boolValue)
        } else if let objectValue = try? container.decode([String: JSONSchemaInstance].self) {
            self = .object(objectValue)
        } else if let arrayValue = try? container.decode([JSONSchemaInstance].self) {
            self = .array(arrayValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .integer(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw NSError(domain: SchemaErrorDomain, code: SchemaErrorCodes.unsupportedValue.rawValue, userInfo: ["codingPath": decoder.codingPath])
        }
    }
}
