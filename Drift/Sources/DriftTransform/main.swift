import DriftRuntime
import Foundation

func main(_ arguments: [String]) throws {
    if arguments.count != 3 {
        printUsage()
        return
    }
    
    let path = arguments[1]
    let fm = FileManager.default
    
    var isDir: ObjCBool = false
    guard fm.fileExists(atPath: path, isDirectory: &isDir) else {
        print("Path: \(path) does not exist.")
        return
    }
    
    let backupDir = arguments[2]
    guard fm.fileExists(atPath: backupDir, isDirectory: &isDir) else {
        print("Backup directory: \(backupDir) does not exist.")
        return
    }
    
    guard isDir.boolValue else {
        print("Backup directory: \(backupDir) is not directory.")
        return
    }
    
    try transformAll(under: path, backupTo: backupDir)
}

/// Transform one file.
///
/// - Parameter file: path to the file
/// - Parameter dir: directory stores backup files
/// - Throws: exception from DriftConverter
func transform(file: String, backupTo dir: String) throws {
    print("Attempting to transform file: \(file) and backup to :\(dir)")
    guard let rfd = FileHandle(forReadingAtPath: file) else {
        print("Creating read fd for: \(file) failed.")
        return
    }
    
    guard let content = String(data: rfd.availableData, encoding: .utf8) else {
        print("Cannot convert data to utf8 encoded string.")
        return
    }
    
    // backup first
    let fileURL = URL(fileURLWithPath: file)
    let fileName = fileURL.lastPathComponent
    FileManager.default.createFile(atPath: "\(dir)/\(fileName)", contents: content.data(using: .utf8))
    
    let converted = try DriftConverter.rewrite(content: content)
    
    guard let wfd = FileHandle(forWritingAtPath: file) else {
        print("Creating write fd from: \(file) failed.")
        return
    }
    
    guard let outputData = converted.data(using: .utf8) else {
        print("Converting converted content to data (utf8) failed.")
        return
    }
    
    // Need to truncate in case converted file is smaller.
    wfd.truncateFile(atOffset: 0)
    wfd.write(outputData)
}

/// Transform everything
///
/// - Parameter path: path to file or folder
/// - Parameter dir: directory stores backup files
/// - Throws: error from file manager
func transformAll(under path: String, backupTo dir: String) throws {
    let fm = FileManager.default
    
    var isDir: ObjCBool = false
    guard fm.fileExists(atPath: path, isDirectory: &isDir) else {
        print("Path: \(path) doesn't exist.")
        return
    }
    
    if isDir.boolValue {
        let contents = try fm.contentsOfDirectory(atPath: path)
        for content in contents {
            // FIXME: cannot have file of same name under different dir
            try transformAll(under: "\(path)/\(content)", backupTo: dir)
        }
    }
    else {
        try transform(file: path, backupTo: dir)
    }
}

/// Print usage.
func printUsage() {
    print(
"""
    DriftTransform: Transforms any document that contains Javadoc to Swift documentation.

    Usage: DriftTransform <directory or file> <backup directory>

        The tool will detect the type of the second argument.
        If it's a directory, we will transform all files under the directory recursively.
        If it's a file, we will transform the file.

        Note: This tool does not follow symbolic links.
        
""")
}

try main(CommandLine.arguments)

