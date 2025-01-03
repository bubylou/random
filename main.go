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

func randomVideo() string {
	files, err := os.ReadDir(directory)
	if err != nil {
		return ""
	}

	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	file := files[r.Intn(len(files))]
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
	port = os.Getenv("RV_PORT")
	if port == "" {
		port = "3000"
	}

	directory = os.Getenv("RV_DIR")
	if directory == "" {
		directory = "/data/videos"
	}

	r := setupRouter()
	r.StaticFS("/assets", http.Dir("./assets"))
	r.StaticFS("/videos", http.Dir(directory))
	_ = r.Run(":" + port)
}
