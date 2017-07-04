import XCTest
import GitRuntime
import Antlr4
import DriftRuntime

class ParserTests: XCTestCase {
    
    override func setUp() {
    }
    
    fileprivate static var git = Git()
    
    fileprivate static var fileManager = FileManager.default
    
    fileprivate static let ResourceURL = "https://github.com/hanjoes/antlr4.git"
    
    func testParsingWithNoError() throws {
//        let inputFiles = ParserTests.findAllSwiftFiles(under: ParserTests.initializedRepoDir)
////        _ = try inputFiles.map {
////            inputFile in
////            print("handling \(inputFile)")
//            let fileStream = ANTLRFileStream("/tmp/drift-tests-12-22/repo//runtime/Swift/Sources/Antlr4/atn/ATNDeserializer.swift")
//            let lexer = Swift3Lexer(fileStream)
//            let tokenStream = CommonTokenStream(lexer)
//            let parser = try Swift3Parser(tokenStream)
//            let walker = ParseTreeWalker()
//            try walker.walk(Swift3BaseListener(), parser.top_level())
////            try parser.top_level()
////        }
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
            try! ParserTests.fileManager.createDirectory(atPath: path,
                                                         withIntermediateDirectories: false,
                                                         attributes: nil)
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
    
    func parse(file: String) throws {
        let fileStream = ANTLRFileStream(file)
        let lexer = JavadocLexer(fileStream)
        let tokenStream = CommonTokenStream(lexer)
        let parser = try JavadocParser(tokenStream)
        try parser.file()
    }

}
