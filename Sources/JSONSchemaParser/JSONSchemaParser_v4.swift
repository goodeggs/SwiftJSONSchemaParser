import Foundation

let SchemaErrorDomain = "JSONSchemaParserErrorDomain"

enum SchemaErrorCodes: Int {
    case unsupportedValue
}

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

struct NullSchema: Decodable {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName?
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]?

    // Metadata keywords
    var title: String?
    var schemaDescription: String?
    // default

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id
        case ref = "$ref"

        case type
        case definitions

        case title
        case schemaDescription = "description"
    }
}

struct BooleanSchema: Decodable {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName?
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]?

    // Metadata keywords
    var title: String?
    var schemaDescription: String?
    // default

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id
        case ref = "$ref"

        case type
        case definitions

        case title
        case schemaDescription = "description"
    }

    var value: Bool? = nil

    init(value: Bool) {
        self.value = value
    }
}

struct NumberSchema: Decodable {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName?
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]?

    // Metadata keywords
    var title: String?
    var schemaDescription: String?
    // default

    // Validation keywords for numeric instances
    // multipleOf
    // maximum
    // exclusiveMaximum
    // minimum
    // exclusiveMinimum

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id
        case ref = "$ref"

        case type
        case definitions

        case title
        case schemaDescription = "description"
    }
}

struct IntegerSchema: Decodable {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName?
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]?

    // Metadata keywords
    var title: String?
    var schemaDescription: String?
    // default

    // Validation keywords for numeric instances
    // multipleOf
    // maximum
    // exclusiveMaximum
    // minimum
    // exclusiveMinimum

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id
        case ref = "$ref"

        case type
        case definitions

        case title
        case schemaDescription = "description"
    }
}

struct StringSchema: Decodable {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName?
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]?

    // Metadata keywords
    var title: String?
    var schemaDescription: String?
    // default

    // Validation keywords for strings
    // maxLength
    // minLength
    // pattern

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id
        case ref = "$ref"

        case type
        case definitions

        case title
        case schemaDescription = "description"
    }
}

struct ArraySchema: Decodable {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName?
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]?

    // Metadata keywords
    var title: String?
    var schemaDescription: String?
    // default

    // Validation keywords for arrays
    // additionalItems
    // items
    // maxItems
    // minItems
    // uniqueItems

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id
        case ref = "$ref"

        case type
        case definitions

        case title
        case schemaDescription = "description"
    }
}

struct ObjectSchema: Decodable {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName?
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]?

    // Metadata keywords
    var title: String?
    var schemaDescription: String?
    // default

    // Validation keywords for objects
    // maxProperties
    // minProperties
    var required: [String]?
    var additionalProperties: Bool? = true
    // properties
    // patternProperties
    // dependencies

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id
        case ref = "$ref"

        case type
        case definitions

        case title
        case schemaDescription = "description"

        case required
        case additionalProperties
    }
}

protocol Schema {
    var schema: String? { get }
    var id: String? { get }
    var ref: String? { get }

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName { get }
    // var allOf
    // var anyOf
    // var oneOf
    // var not
    var definitions: [String: JSONSchema]? { get }

    // Metadata keywords
    var title: String? { get }
    var schemaDescription: String? { get }
    // default
}

/**
 https://tools.ietf.org/html/draft-zyp-json-schema-04
 https://tools.ietf.org/html/draft-fge-json-schema-validation-00
 */
enum JSONSchema: Decodable {
    case null(NullSchema)
    case boolean(BooleanSchema)
    case number(NumberSchema)
    case integer(IntegerSchema)
    case string(StringSchema)
    case array(ArraySchema)
    case object(ObjectSchema)

    enum SchemaTypeKey: CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null(NullSchema())
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(BooleanSchema(value: boolValue))
        } else if
            let typeString = try? decoder.container(keyedBy: SchemaTypeKey.self).decode(String.self, forKey: .type),
            let type = SchemaTypeName(rawValue: typeString)
        {
            switch type {
            case .null:
                self = .null(try container.decode(NullSchema.self))
            case .boolean:
                self = .boolean(try container.decode(BooleanSchema.self))
            case .object:
                self = .object(try container.decode(ObjectSchema.self))
            case .array:
                self = .array(try container.decode(ArraySchema.self))
            case .number:
                self = .number(try container.decode(NumberSchema.self))
            case .string:
                self = .string(try container.decode(StringSchema.self))
            case .integer:
                self = .integer(try container.decode(IntegerSchema.self))
            }
        } else if let objectValue = try? container.decode(ObjectSchema.self) {
            self = .object(objectValue)
        } else {
            throw NSError(domain: SchemaErrorDomain, code: SchemaErrorCodes.unsupportedValue.rawValue, userInfo: ["codingPath": decoder.codingPath, "info": decoder.userInfo])
        }
    }
}
