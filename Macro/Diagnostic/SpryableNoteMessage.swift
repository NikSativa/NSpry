import SwiftDiagnostics

enum SpryableNoteMessage: String, NoteMessage {
    case preprocessorFlagArgumentRequiresStaticStringLiteral

    /// Provides a detailed note message for each case, offering guidance or clarification.
    var message: String {
        switch self {
        case .preprocessorFlagArgumentRequiresStaticStringLiteral:
            "Provide a literal string value without any dynamic expressions or interpolations to meet the static string literal requirement."
        }
    }

    /// Unique identifier for each note message, aligning with the corresponding diagnostic message for clarity.
    var noteID: MessageID {
        MessageID(domain: "SpryableMacro", id: rawValue + "NoteMessage")
    }
}
