import Foundation

// This turns an (A) -> B function into a () -> B function,
// by using a constant value for A.
func combine<A, B>(
    value: A,
    closure: @escaping (A) -> B
    ) -> (() -> B) {
    return { closure(value)}
}

// This turns an (A) -> B and a (B) -> C function into a
// (A) -> C function, by chaining them together.
func chain<A, B, C>(
    _ inner: @escaping (A) -> B,
    to outer: @escaping (B) -> C
    ) -> (A) -> C {
    return { outer(inner($0)) }
}
