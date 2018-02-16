import Foundation

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
            throw NSError(domain: SchemaErrorDomain, code: SchemaErrorCodes.unsupportedValue.rawValue, userInfo: ["codingPath": decoder.codingPath, "decoderInfo": decoder.userInfo])
        }
    }
}

extension JSONSchema: Schema {
    var associatedSchema: Schema {
        switch self {
        case .null(let schema):
            return schema
        case .boolean(let schema):
            return schema
        case .number(let schema):
            return schema
        case .integer(let schema):
            return schema
        case .string(let schema):
            return schema
        case .array(let schema):
            return schema
        case .object(let schema):
            return schema
        }
    }

    // MARK: Schema properties
    var schema: String? {
        return self.associatedSchema.schema
    }
    var id: String? {
        return self.associatedSchema.id
    }
    var ref: String? {
        return self.associatedSchema.ref
    }

    // Validation keywords for any instance type
    // var enum:
    var type: SchemaTypeName {
        return self.associatedSchema.type
    }
    var allOf: [JSONSchema]? {
        return self.associatedSchema.allOf
    }
    var anyOf: [JSONSchema]? {
        return self.associatedSchema.anyOf
    }
    var oneOf: [JSONSchema]? {
        return self.associatedSchema.oneOf
    }
    var definitions: [String: JSONSchema]? {
        return self.associatedSchema.definitions
    }

    // Metadata keywords
    var title: String? {
        return self.associatedSchema.title
    }
    var schemaDescription: String? {
        return self.associatedSchema.schemaDescription
    }
    // default
}
