struct BooleanSchema: Decodable, Schema {
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
    }

    var value: Bool? = nil

    init(value: Bool) {
        self.value = value
    }

    var type: SchemaTypeName {
        return .boolean
    }
}
