import ServerCore
import Foundation

do {
    try Hampy.start()
} catch let error {
    print("Error => \(error)")
    exit(1)
}
