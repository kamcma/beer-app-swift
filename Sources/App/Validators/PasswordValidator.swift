import Vapor

final class PasswordValidator: ValidationSuite {
    static func validate(input value: String) throws {
        let range = value.range(of: "^(?=.*[0-9])(?=.*[A-Z])", options: [.regularExpression, .caseInsensitive])
        guard let _ = range else {
            throw error(with: value)
        }
    }
}
