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

    func testEmptyObjectSchema() throws {
        let json = "{}"
        validateParsing(json: json)
    }

    func testArraySchema() throws {
        let example = """
        {
            "type": "array",
            "items": {
                "type": "boolean"
            }
        }
        """
        validateParsing(json: example)
    }

    func testBooleanSchema() throws {
        let example = """
        {
            "definitions": {
                "schema1": true,
                "schema2": false,
                "schema3": {
                    "type": "boolean"
                }
            }
        }
        """
        validateParsing(json: example)
    }

    func testIntegerSchema() throws {
        let example = """
        {
            "type": "integer"
        }
        """
        validateParsing(json: example)
    }

    func testNullSchema() throws {
        let example = """
        {
            "definitions": {
                "schema1": null,
                "schema2": {
                    "type": "null"
                }
            }
        }
        """
        validateParsing(json: example)
    }

    func testNumberSchema() throws {
        let example = """
        {
            "type": "number"
        }
        """
        validateParsing(json: example)
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

    func testStringSchema() throws {
        let example = """
        {
            "type": "string"
        }
        """
        validateParsing(json: example)
    }

    func testCoreDefinitionsExamples() throws {
        // example schemas from https://tools.ietf.org/html/draft-zyp-json-schema-04
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
