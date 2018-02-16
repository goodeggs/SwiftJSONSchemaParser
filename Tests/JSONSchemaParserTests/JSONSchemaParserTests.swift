import XCTest
@testable import JSONSchemaParser

class JSONSchemaParserTests: XCTestCase {
    func validateParsing(json: String) {
        var schema: JSONSchema?
        var data: Data?

        XCTAssertNoThrow(data = json.data(using: .utf8))
        if let data = data {
            XCTAssertNoThrow(try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments), "invalid JSON")
            XCTAssertNoThrow(schema = try JSONDecoder().decode(JSONSchema.self, from: data))
            XCTAssertNotNil(schema, "Expected to get a non-nil schema when decoding: \(String(describing: json))")
        }
    }

    func testBooleanSchemas() throws {
        let example = """
        {
            "definitions": {
                "schema1": true,
                "schema2": false
            }
        }
        """
        validateParsing(json: example)
    }

    func testEmptyObjectSchema() throws {
        let json = "{}"
        validateParsing(json: json)
    }

    func testObjectSchema() throws {
        let json = """
        {
            "$schema": "http://json-schema.org/draft-04/schema#",
            "title": "persimmon-api",
            "type": "object",
            "$id": "schema://root.schema#",
            "required": [
                "data"
            ],
            "properties": {
                "data": {
                    "type": "object"
                },
                "links": {
                    "type": "object"
                },
                "meta": {
                    "type": "object"
                },
                "errors": {
                    "type": "array"
                }
            },
            "additionalProperties": false
        }
        """
        validateParsing(json: json)
    }

    func testCoreDefinitionsExamples() throws {
        let examples = [
            """
            {
                "title": "root"
            }
            """,
            """
            {
                "title": "root",
                "otherSchema": {
                    "title": "nested",
                    "anotherSchema": {
                        "title": "alsoNested"
                    }
                }
            }
            """,
            """
            {
                "id": "http://x.y.z/rootschema.json#",
                "schema1": {
                    "id": "#foo"
                },
                "schema2": {
                    "id": "otherschema.json",
                    "nested": {
                        "id": "#bar"
                    },
                    "alsonested": {
                        "id": "t/inner.json#a"
                    }
                },
                "schema3": {
                    "id": "some://where.else/completely#"
                }
            }
            """,
            """
            {
                "id": "http://my.site/myschema#",
                "definitions": {
                    "schema1": {
                        "id": "schema1",
                        "type": "integer"
                    },
                    "schema2": {
                        "type": "array",
                        "items": { "$ref": "schema1" }
                    }
                }
            }
            """,
            """
            {
                "id": "http://some.site/schema#",
                "not": { "$ref": "#inner" },
                "definitions": {
                    "schema1": {
                        "id": "#inner",
                        "type": "boolean"
                    }
                }
            }
            """
        ]

        for example in examples {
            validateParsing(json: example)
        }
    }
}
