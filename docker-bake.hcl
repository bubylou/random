group "default" {
  targets = ["build", "validate"]
}

group "validate" {
  targets = ["lint", "test"]
}

variable "REPO" {
  default = "bubylou/random"
}

variable "TAG" {
  default = "latest"
}

variable "GO_VERSION" {
  default = "1.22"
}

variable "GOLANGCI_LINT_VERSION" {
  default = "1.61"
}

target "docker-metadata-action" {}

target "build" {
  context = "."
  dockerfile = "Dockerfile"
  cache-from = ["type=registry,ref=ghcr.io/${REPO}"]
  cache-to = ["type=inline"]
  args = {
    GO_VERSION = "${GO_VERSION}"
    GIN_MODE = "debug"
  }
  tags = ["ghcr.io/${REPO}:latest", "ghcr.io/${REPO}:${TAG}",
          "docker.io/${REPO}:latest", "docker.io/${REPO}:${TAG}"]
}

target "release" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "Dockerfile"
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
  attest = [
    "type=provenance,mode=max",
    "type=sbom"
  ]
}

target "release-all" {
  inherits = ["release"]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm"]
}

target "lint" {
  target = "lint"
  output = ["type=cacheonly"]
}

target "test" {
  target = "test"
  output = ["type=cacheonly"]
}
