import SwiftDiagnostics

enum SpryableDiagnostic: String, DiagnosticMessage, Error {
    case onlyApplicableToProtocol
    case preprocessorFlagArgumentRequiresStaticStringLiteral
    case subscriptsNotSupported
    case operatorsNotSupported
    case invalidVariableRequirement

    /// Provides a human-readable diagnostic message for each diagnostic case.
    var message: String {
        switch self {
        case .onlyApplicableToProtocol:
            return "`@Spryable` can only be applied to a `protocol`"
        case .preprocessorFlagArgumentRequiresStaticStringLiteral:
            return "The `preprocessorFlag` argument requires a static string literal"
        case .subscriptsNotSupported:
            return "Subscript requirements are not supported by `@Spryable`"
        case .operatorsNotSupported:
            return "Operator requirements are not supported by @Mockable."
        case .invalidVariableRequirement:
            return "Invalid variable requirement. Missing type annotation or accessor block."
        }
    }

    /// Specifies the severity level of each diagnostic case.
    var severity: DiagnosticSeverity {
        switch self {
        case .invalidVariableRequirement,
             .onlyApplicableToProtocol,
             .operatorsNotSupported,
             .preprocessorFlagArgumentRequiresStaticStringLiteral,
             .subscriptsNotSupported:
            return .error
        }
    }

    /// Unique identifier for each diagnostic message, facilitating precise error tracking.
    var diagnosticID: MessageID {
        MessageID(domain: "SpryableMacro", id: rawValue)
    }
}
