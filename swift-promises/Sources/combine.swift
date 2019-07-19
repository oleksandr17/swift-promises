import Foundation

func combine<A, B>(value: A, closure: @escaping (A) -> B) -> (() -> B) {
    return { closure(value)}
}
