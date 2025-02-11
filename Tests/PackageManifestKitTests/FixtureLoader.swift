import Foundation

enum FixtureLoader {
    static func load(named filename: String) -> Data? {
        let fixturePath = URL(filePath: #filePath)
            .deletingLastPathComponent()
            .appending(component: "Fixtures")
            .appending(components: filename)
        let fileManager: FileManager = .default
        
        return fileManager.contents(atPath: fixturePath.path(percentEncoded: false))
    }
}
