package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func Test_randomVideo(t *testing.T) {
	tests := []struct {
		name string
		want string
	}{
		struct{ name, want string }{"example", "assets/video/computer_time.webm"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := randomVideo(); got != tt.want {
				t.Errorf("randomVideo() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_setupRouter(t *testing.T) {
	tests := []struct {
		name string
		want string
	}{
		{"health", "ok"},
	}

	r := setupRouter()
	w := httptest.NewRecorder()

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req, _ := http.NewRequest(http.MethodGet, "/api/"+tt.name, nil)
			r.ServeHTTP(w, req)
			if got := w.Body.String(); got != tt.want {
				t.Errorf("setupRouter() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_main(t *testing.T) {
	tests := []struct {
		name string
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			main()
		})
	}
}
