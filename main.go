package main

import (
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
)

var (
	port      string
	directory string
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

func randomVideo() string {
	files, err := os.ReadDir(directory)
	if err != nil {
		return ""
	}

	file := files[rand.Intn(len(files))]
	return file.Name()
}

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.LoadHTMLGlob("templates/*")
	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.tmpl", gin.H{
			"title": "random.bubylou.com",
			"video": "/videos/" + randomVideo(),
		})
	})

	api := r.Group("/api")
	api.GET("/health", func(c *gin.Context) {
		c.String(http.StatusOK, "ok")
	})

	return r
}

func main() {
	port = os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	directory = os.Getenv("DIRECTORY")
	if directory == "" {
		directory = "/videos"
	}

	r := setupRouter()
	r.StaticFS("/assets", http.Dir("./assets"))
	r.StaticFS("/videos", http.Dir(directory))
	r.Run(":" + port)
}
