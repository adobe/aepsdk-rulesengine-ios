/// A pair of tag delimiters, such as `("{{", "}}")`.
public typealias DelimiterPair = (String, String)

public struct MustacheError: Error {

/// Eventual error message
    public let message: String?

    public init( message: String? = nil) {
        self.message = message
    }
}

public struct TemplateToken {
    enum `Type` {
        /// text
        case text(String)

        /// {{ content }}
        case mustache(MustacheToken?)

    }

    let type: Type
    let templateString: String
    let range: Range<String.Index>
    var templateSubstring: String { return String(templateString[range]) }
}
