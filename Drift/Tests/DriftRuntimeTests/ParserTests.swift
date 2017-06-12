import XCTest
import GitRuntime
import Antlr4

class ParserTests: XCTestCase {
    
    override func setUp() {
    }
    
    fileprivate static var git = Git()
    
    fileprivate static var fileManager = FileManager.default
    
    fileprivate static let ResourceURL = "https://github.com/hanjoes/antlr4.git"
    
    func testOne() {
        print(ParserTests.findAllSwiftFiles(under: ParserTests.initializedRepoDir).joined(separator: "\n"))
    }
    
    func testTwo() {
    }
    
}

private extension ParserTests {
    
    static var initializedTestDir: String = {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let systemTempDir = "/tmp/"
        
        // Refreshes once per hour
        let testDir = "\(systemTempDir)drift-tests-\(day)-\(hour)"
        ParserTests.ensure(folderAt: testDir)
        return testDir
    }()
    
    static var initializedRepoDir: String = {
        let repoDir = "\(ParserTests.initializedTestDir)/repo/"
        ParserTests.ensure(folderAt: repoDir)
        try! ParserTests.git.sync(from: ParserTests.ResourceURL, to: repoDir)
        return repoDir
    }()
    
    static func ensure(folderAt path: String) {
        if !ParserTests.fileManager.fileExists(atPath: path) {
            try! ParserTests.fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    static func findAllSwiftFiles(under path: String) -> [String] {
        var result = [String]()
        let files = try! ParserTests.fileManager.contentsOfDirectory(atPath: path)
        for file in files {
            let absolutePath = path + "/" + file
            if ParserTests.isDirectory(at: absolutePath) {
                result += ParserTests.findAllSwiftFiles(under: absolutePath)
            }
            
            if file.hasSuffix(".swift") {
                result.append(absolutePath)
            }
        }
        return result
    }
    
    static func isDirectory(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        ParserTests.fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}
