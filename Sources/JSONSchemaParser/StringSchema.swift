struct StringSchema: Decodable, Schema {
    var schema: String?
    var id: String?
    var ref: String?

    // Validation keywords for any instance type
    // var enum:
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

        case definitions

        case title
        case schemaDescription = "description"
    }

    var type: SchemaTypeName {
        return .string
    }
}
