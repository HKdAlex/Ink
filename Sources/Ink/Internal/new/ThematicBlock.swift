internal struct ThematicBlock: Fragment {
    var modifierTarget: Modifier.Target { .thematicBlocks }

    private static let marker: Character = "="

    private var type: Substring
    private var code: String

    static func read(using reader: inout Reader) throws -> ThematicBlock {
        let startingMarkerCount = reader.readCount(of: marker)
        try require(startingMarkerCount >= 3)
        reader.discardWhitespaces()

        let type = reader
            .readUntilEndOfLine()
            .trimmingTrailingWhitespaces()
            
        var code = ""

        while !reader.didReachEnd {
            if code.last == "\n", reader.currentCharacter == "\n" {
                break
            }

            if let escaped = reader.currentCharacter.escaped {
                code.append(escaped)
            } else {
                code.append(reader.currentCharacter)
            }

            reader.advanceIndex()
        }

        return ThematicBlock(type: type, code: code)
    }

    func html(usingURLs urls: NamedURLCollection,
              modifiers: ModifierCollection) -> String {
        let typeClass = type.isEmpty ? "" : " class=\"type-\(type)\""
        return "<pre><code\(typeClass)>\(code)</code></pre>"
    }

    func plainText() -> String {
        code
    }
}
