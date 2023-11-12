# swift-package-registry-demo

- This is a demo on how to get started with swift package registry. 

## Requirements
- Make sure you have Xcode 15 and Swift 5.9 installed. You can check by running `swift -version` and `xcodebuild -version`
- For this demo to work you'll need to have access to a swift package registry service.
- You can create one on JFrog Artifactory. There is 14 day free trial.
- Create an account on JFrog Artifactory: https://jfrog.com/artifactory/ 
- Create a repository and take note of the url. It should look like that: "https://myorganisation.jfrog.io/artifactory/api/swift/swift"
- Follow the first step from Artifactory to configure a client and create a token. Take note of the token.
- When following this doc, replace `myorganisation` by your org name in your artifactory account.

## How to publish a swift package to a registry

- Clone a repo. For this example we'll work with grpc
```
git clone https://github.com/grpc/grpc.git --depth 1
cd grpc
```
- Take note of the last release tag or any release you would like to publish. Fetch it.
```
git fetch --depth 1 origin tag v1.59.2
```
- Checkout the specific tag
```
git checkout v1.59.2
```
- As grpc has submodules, you would need to update them
```
git submodule update --init
```

- To publish a package, we need to specify its metadata, by creating a file called
`package-metadata.json`

- Create this file in the repo source root and past the following info
```package-metadata.json
{
    "author": {
        "name": "The gRPC contributors",
        "email": "grpc-packages@google.com",
        "organization": {
            "name": "The gRPC contributors"
        }
    },
    "description": "gRPC client library for iOS/OSX",
    "licenseURL": "https://github.com/grpc/grpc/blob/883e5f76976b86afee87415dc67bde58d9b295a4/LICENSE",
    "readmeURL": "https://github.com/firebase/boringSSL-SwiftPM/blob/dd3eda2b05a3f459fc3073695ad1b28659066eab/README.md",
    "repositoryURLs": [
        "https://github.com/grpc/grpc.git",
        "git@github.com:grpc/grpc.git"
    ]
}
```

- Then configure the url for the swift package-registry feature
```
swift package-registry set "https://myorganisation.jfrog.io/artifactory/api/swift/swift"
```

This created a file at `./.swiftpm/configuration/registries.json`

It should look like this
```
{
  "authentication" : {

  },
  "registries" : {
    "[default]" : {
      "supportsAvailability" : false,
      "url" : "https://myorganisation.jfrog.io/artifactory/api/swift/swift"
    }
  },
  "version" : 1
}
```

- Then run the following to login to your artifactory instance
```
swift package-registry login "https://myorganisation.jfrog.io/artifactory/api/swift/swift" --token "<insert-your-artifactory-token-here>"
```

- Then run the following to publish the package
```
swift package-registry publish swift.grpc 1.59.2 --metadata-path ${HOME}/path/to/package-metadata.json
```

- Done! You uploaded your first swift package to a registry.

- Before showing how to consume this package, we'll upload as well the two dependencies of grpc: abseil and boringssl. 

- Change directory 
```
cd ..
```

- Repeat the process for abseil

```
git clone https://github.com/firebase/abseil-cpp-SwiftPM.git --depth 1
cd abseil-cpp-SwiftPM
git fetch --depth 1 origin tag 0.20220623.1
git checkout 0.20220623.1
```

- Create the following `package-metadata.json`

```
{
    "author": {
        "name": "Google Inc.",
        "organization": {
            "name": "Google Inc."
        }
    },
    "description": "The repository contains the Abseil C++ library code. Abseil is an open-source collection of C++ code (compliant to C++11) designed to augment the C++ standard library.",
    "licenseURL": "https://github.com/firebase/abseil-cpp-SwiftPM/blob/06e7506b74bfc47c70f3353e2927ea3e2275230c/LICENSE",
    "readmeURL": "https://github.com/firebase/abseil-cpp-SwiftPM/blob/06e7506b74bfc47c70f3353e2927ea3e2275230c/README.md",
    "repositoryURLs": [
        "https://github.com/firebase/abseil-cpp-SwiftPM.git",
        "git@github.com:firebase/abseil-cpp-SwiftPM.git"
    ]
}
```

- Then run the following to set the url of the registry and login 
```
swift package-registry set "https://myorganisation.jfrog.io/artifactory/api/swift/swift"
swift package-registry login "https://myorganisation.jfrog.io/artifactory/api/swift/swift" --token "<insert-your-artifactory-token-here>"
```

- Publish the package
```
swift package-registry publish swift.abseil 0.20220623.1 --metadata-path ${HOME}/path/to/package-metadata.json
```
When this succeeded you should see the following
```
swift.abseil version 0.20220623.1 was successfully published to https://myorganisation.jfrog.io/artifactory/api/swift/swift
```

You can check that the package is available on your registry by visiting https://myorganisation.jfrog.io/ui/repos/tree/General/swift-local/swift/abseil/abseil-0.20220623.1.zip

- Change directory 
```
cd ..
```

- Repeat the process for boringssl

```
git clone https://github.com/firebase/boringSSL-SwiftPM.git --depth 1
cd boringSSL-SwiftPM
git fetch --depth 1 origin tag 0.9.1
git checkout 0.9.1
```

- Create the following `package-metadata.json`

```
{
    "author": {
        "name": "Google Inc.",
        "organization": {
            "name": "Google Inc."
        }
    },
    "description": "BoringSSL is a fork of OpenSSL that is designed to meet Google's needs.",
    "licenseURL": "https://github.com/firebase/boringSSL-SwiftPM/blob/dd3eda2b05a3f459fc3073695ad1b28659066eab/LICENSE",
    "readmeURL": "https://github.com/firebase/boringSSL-SwiftPM/blob/dd3eda2b05a3f459fc3073695ad1b28659066eab/README.md",
    "repositoryURLs": [
        "https://github.com/firebase/boringssl-SwiftPM.git",
        "git@github.com:firebase/boringSSL-SwiftPM.git"
    ]
}
```

- Then run the following to set the url of the registry and login 
```
swift package-registry set "https://myorganisation.jfrog.io/artifactory/api/swift/swift"
swift package-registry login "https://myorganisation.jfrog.io/artifactory/api/swift/swift" --token "<insert-your-artifactory-token-here>"
```

- Publish the package
```
swift package-registry publish swift.boringssl 0.9.1 --metadata-path ${HOME}/path/to/package-metadata.json
```

- Done! Now you can resolve grpc and its dependencies using your registry.

## How to consume a swift package from a registry
```
cd Vanilla
swift package-registry set "https://myorganisation.jfrog.io/artifactory/api/swift/swift"
swift package-registry login "https://myorganisation.jfrog.io/artifactory/api/swift/swift" --token "<insert-your-artifactory-token-here>"
```

- (Optional) Clear any build product and cache
```
swift package reset
swift package purge-cache
```

- Resolve
```
swift package --replace-scm-with-registry resolve
```

- Here is the log when swift package manager is downloading packages from the registry instead of using git
```
❯ swift package --replace-scm-with-registry resolve
Fetching https://github.com/firebase/boringssl-SwiftPM.git
Fetching https://github.com/firebase/abseil-cpp-SwiftPM.git
Computing version for swift.grpc
Computed swift.grpc at 1.59.2 (1.61s)
Fetched https://github.com/firebase/boringssl-SwiftPM.git (5.37s)
Fetched https://github.com/firebase/abseil-cpp-SwiftPM.git (5.37s)
Computing version for swift.boringssl
Computed swift.boringssl at 0.9.1 (0.85s)
Computing version for swift.abseil
Computed swift.abseil at 0.20220623.1 (0.72s)
Fetching swift.grpc
warning: 'swift.grpc': swift.grpc version 1.59.2 source archive from https://myorganisation.jfrog.io/artifactory/api/swift/swift-internal-master is not signed
Fetched swift.grpc (22.74s)
Fetching swift.abseil
warning: 'swift.abseil': swift.abseil version 0.20220623.1 source archive from https://myorganisation.jfrog.io/artifactory/api/swift/swift-internal-master is not signed
Fetched swift.abseil (0.86s)
Fetching swift.boringssl
warning: 'swift.boringssl': swift.boringssl version 0.9.1 source archive from https://myorganisation.jfrog.io/artifactory/api/swift/swift-internal-master is not signed
Fetched swift.boringssl (4.36s)
```

## Benchmark

- The following benchmark was done with an internet speed of around 500 Mbps measured on https://speed.cloudflare.com
- 3 min - Time to download grpc using swift package manager (it's cloning the whole repo)
- 30 s - Time to download grpc using swift package manager with swift package registry feature (it's downloading the archive source for the resolved version only)

## Notes

### About the flag --replace-scm-with-registry
- You can force to download dependencies using the registry with the following notation in Package.swift
```
.package(id: "swift.grpc", exact: "1.59.2"),
```

Using the url like in the following example has some benefits
```
.package(url: "https://github.com/grpc/grpc.git", exact: "1.59.2")
```

Indeed, when you do
 ```
 swift package --replace-scm-with-registry resolve
 ```

swift package manager will try to fetch the package from the registry, and fall back on the 
 provided github repo if it failed.

This is made possible by the `repositoryURLs` that was specified in the package-metadata.json.

This way, you can resolve any package and its dependencies using the registry, if there is a compatible version available in the registry, and fallback on git if this failed.

### About the flag --global
- Instead of having a project specific configuration you can set a registry and login config as a global config, using the --global flag.
- See `swift package-registry --help`

### Reset config
- You can reset your swift package-registry config by deleting the global config
```
rm -rf ~/.swiftpm/configuration/registries.json
```
as well as your project config
```
rm -rf ./.swiftpm/configuration/registries.json
```
and by reseting build products
```
swift package reset
```
and cache
```
swift package purge-cache
```

### About signing
- This demo does not handle signing so you'll get the following warning when resolving 
```
warning: 'swift.grpc': swift.grpc version 1.59.2 source archive from https://myorganisation.jfrog.io/artifactory/api/swift/swift-internal-master is not signed
```
See the documentation below to implement signing

 ## Documentation

- Documentation on the swift-package-manager repo - https://github.com/apple/swift-package-manager/tree/main/Documentation/PackageRegistry
- CLI help - `swift package-registry --help`
