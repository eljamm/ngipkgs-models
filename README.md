# Example

```$ as json
nix-instantiate --eval --strict --json -A projects.Omnom | jq
```

```json
{
  "binary": {},
  "metadata": {
    "links": {},
    "subgrants": [
      "omnom",
      "omnom-ActivityPub"
    ],
    "summary": "Omnom is a webpage bookmarking and snapshotting service."
  },
  "nixos": {
    "services": {
      "omnom": {
        "examples": {
          "base": {
            "description": "Basic Omnom configuration, mainly used for testing purposes",
            "links": {},
            "module": "/nix/store/7fm40ccxv8ij811jm4mz47aib53sxr4c-example.nix",
            "tests": {}
          }
        },
        "links": {},
        "module": "/nix/store/k61ag4rmnhhx20pssyjmahbw2ykzhvai-1dwky0bis4bkl3qngsc6pmq902swa9b6-source/nixos/modules/services/misc/omnom.nix",
        "name": "omnom"
      }
    }
  }
}
```

# Goal

- [x] project
  - [x] name
  - [x] metadata
    - [x] summary
    - [x] subgrants
    - [x] links
  - [x] nixos
    - [x] services
    - [x] programs
    - [x] examples
    - [x] tests
  - [x] binary
- [x] types
  - [x] subgrantType
  - [x] urlType
  - [x] moduleType
  - [x] binaryType
  - [x] pluginType
  - [x] serviceType
  - [x] programType
  - [x] exampleType
  - [x] testType
