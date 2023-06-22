package main

import (
	"io/ioutil"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
)

func randomVideo() string {
	directory := "assets/video/"

	files, err := ioutil.ReadDir(directory)
	if err != nil {
		return ""
	}

	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	file := files[r.Intn(len(files))]
	return directory + file.Name()
}

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.LoadHTMLGlob("templates/*")
	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.tmpl", gin.H{
			"title": "random.bubylou.com",
			"video": randomVideo(),
		})
	})

	api := r.Group("/api")
	api.GET("/health", func(c *gin.Context) {
		c.String(http.StatusOK, "ok")
	})

	return r
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	r := setupRouter()
	r.StaticFS("/assets", http.Dir("assets"))
	r.Run(":" + port)
}
