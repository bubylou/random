group "default" {
  targets = ["image", "test"]
}

variable "REPO" {
  default = "bubylou/random"
}

variable "TAG" {
  default = "latest"
}

target "docker-metadata-action" {}

target "image" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "Dockerfile"
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
  tags = ["ghcr.io/${REPO}:latest", "ghcr.io/${REPO}:${TAG}",
          "docker.io/${REPO}:latest", "docker.io/${REPO}:${TAG}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = ["linux/386", "linux/amd64", "linux/arm64", "linux/arm/v7"]
}

target "test" {
  target = "test"
  output = ["type=cacheonly"]
}
