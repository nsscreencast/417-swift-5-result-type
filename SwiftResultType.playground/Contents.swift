import Foundation

// Swift 5's Result Type


struct MyCustomError : Error { }

func getMessage(completion: @escaping (Result<String, Error>) -> Void) {
    completion(.success("It worked!"))
}

func getMessageThatFails(completion: @escaping (Result<String, Error>) -> Void) {
    completion(.failure(MyCustomError()))
}

struct MyOtherError : Error { }
struct OddNumberOfCharacters : Error { }

getMessage { result in

    let newResult = result
        .map { $0.reversed() }
//        .mapError { _ in MyOtherError() }


    // MAP Result<T, E>   T->U   --> Result<U, E>

    // flatMap -> Result<U, E>
    // Result<T, E>      T->Result<U, E>   --> Result<U, E>

    let newResult2 = newResult.flatMap { msg -> Result<String, Error> in
        if msg.count % 2 == 0 {
            return .success(String(msg))
        } else {
            return .failure(OddNumberOfCharacters())
        }
    }


    switch newResult2 {
    case .success(let msg):
        print(String(msg))

    case .failure(let error):
        print(error)
    }

}



let r: Result<Int, Error> = .success(52)

try! r.get()

















enum CustomErrors : String, Error, CustomStringConvertible {
    case operation1Failed
    case operation2Failed
    case operation3Failed

    var description: String {
        return "🔥 \(self.rawValue)"
    }
}

func operation1() -> Result<Int, CustomErrors> {
    print("Running operation 1")
    let random = Int.random(in: 1...10)
    if random < 3 {
        return .failure(.operation1Failed)
    }
    return .success(random)
}

func operation2(_ input: Int) -> Result<String, CustomErrors> {
    print("Running operation 2")
    if Bool.random() {
        return .failure(.operation2Failed)
    } else {
        var s = ""
        for _ in 1...input {
            s.append("🤓")
        }
        return .success(s)
    }
}

func operation3(_ input: String) -> Result<String, CustomErrors> {
    print("Running operation 3")
    if Bool.random() {
        return .failure(.operation3Failed)
    } else {
        return .success(String(input.map { _ in "👍🏼" }))
    }
}

func run() -> Result<String, CustomErrors> {

    let r = operation1()
        .flatMap { operation2($0) }
        .flatMap { operation3($0) }
    // Update 11/16/19: You can also chain together the operations as follows:
    //    let r = operation1()
    //        .flatMap(operation2)
    //        .flatMap(operation3)

    return r

}


print(run())
print("-------------------------")
print(run())
print("-------------------------")
print(run())





