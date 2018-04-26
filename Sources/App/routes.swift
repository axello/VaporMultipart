import Foundation
import Routing
import Vapor
import Multipart
import SwiftGD

public func routes(_ router: Router) throws {
    let rootDirectory = DirectoryConfig.detect().workDir
    let uploadDirectory = URL(fileURLWithPath: "\(rootDirectory)Public/uploads")
    let originalsDirectory = uploadDirectory.appendingPathComponent("originals")
    let thumbsDirectory = uploadDirectory.appendingPathComponent("thumbs")

    router.get { req -> Future<View> in
        let fm = FileManager()
        
        guard let files = try? fm.contentsOfDirectory(at: originalsDirectory, includingPropertiesForKeys: nil) else {
            throw Abort(.internalServerError)
        }
        
        let allFilenames = files.map { $0.lastPathComponent }
        let visibleFilenames = allFilenames.filter { !$0.hasPrefix(".") }
        
        let context = ["files": visibleFilenames]
        return try req.view().render("home", context)
    }

    // single ImageFile, multiple files
    router.post("upload") { req -> Future<Response> in
        struct ImageFile : Content {
            var upload: [File]
        }
        return try req.content.decode(ImageFile.self).map(to: Response.self, { forms in
            let ploep = forms.upload            // for some reason, this is always 0
            print("files uploaded: \(ploep)")
            guard forms.upload.count > 0 else {
                return req.redirect(to: "/", type: RedirectType.normal)
            }
            for file in forms.upload {
                print(file.filename)
                let newURL = originalsDirectory.appendingPathComponent("wtf_\(file.filename).png")
                print(newURL)

                _ = try? file.data.write(to: newURL)
            }
            return req.redirect(to: "/", type: RedirectType.normal)          //.redirect(to: "/", [:])
       })
    }

}
