group "default" {
  targets = ["build", "validate"]
}

group "release-all" {
  targets = ["release"]
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
  default = "1.23"
}

variable "GOLANGCI_LINT_VERSION" {
  default = "1.63"
}

target "docker-metadata-action" {}

target "build" {
  context = "."
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/${REPO}:latest", "ghcr.io/${REPO}:${TAG}",
          "docker.io/${REPO}:latest", "docker.io/${REPO}:${TAG}"]
}

target "build-dev" {
  inherits = ["build"]
  cache-from = ["type=registry,ref=ghcr.io/${REPO}"]
  cache-to = ["type=inline"]
  args = {
    GOLANGCI_LINT_VERSION = "${GOLANGCI_LINT_VERSION}"
    GO_VERSION = "${GO_VERSION}"
    GIN_MODE = "debug"
  }
}

target "docker-metadata-action" {}

target "release" {
  inherits = ["build", "docker-metadata-action"]
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm"]
  attest = [
    "type=provenance,mode=max",
    "type=sbom"
  ]
}

target "lint" {
  target = "lint"
  output = ["type=cacheonly"]
}

target "test" {
  target = "test"
  output = ["type=cacheonly"]
}
