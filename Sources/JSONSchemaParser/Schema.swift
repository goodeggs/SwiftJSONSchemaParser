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
