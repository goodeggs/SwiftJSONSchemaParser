struct ObjectSchema: Decodable, Schema {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
    var allOf: [JSONSchema]?
    var anyOf: [JSONSchema]?
    var oneOf: [JSONSchema]?
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

        case allOf
        case anyOf
        case oneOf
        case definitions

        case title
        case schemaDescription = "description"

        case required
        case additionalProperties
    }

    var type: SchemaTypeName {
        return .object
    }
}
