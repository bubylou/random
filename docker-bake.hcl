group "default" {
  targets = ["main", "all"]
}

variable "REPO" {
  default = "bubylou/random"
}

variable "TAG" {
  default = "latest"
}

target "main" {
  context = "."
  dockerfile = "Dockerfile"
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/bubylou/random"
    "org.opencontainers.image.authors" = "Nicholas Malcolm <bubylou@pm.me>"
    "org.opencontainers.image.licenses" = "GPL-3.0-or-later"
  }
  tags = ["ghcr.io/${REPO}:latest", "ghcr.io/${REPO}:${TAG}",
          "docker.io/${REPO}:latest", "docker.io/${REPO}:${TAG}"]
}

target "all" {
  inherits = ["main"]
  platforms = ["linux/386", "linux/amd64", "linux/arm64",
	       "linux/arm/v6", "linux/arm/v7", "linux/ppc64le", "linux/s390x"]
}
