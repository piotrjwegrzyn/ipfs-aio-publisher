package main

import (
	"log/slog"
	"net/http"
	"net/url"
	"os"
	"time"
)

var (
	IPFS_URL       = "http://127.0.0.1:5001/api/v0/id"
	TIMEOUT        = 2 * time.Minute
	SLEEP_INTERVAL = time.Second
)

func main() {
	status := 0
	t := time.Now()

	for status != 200 {
		if time.Since(t) > TIMEOUT {
			slog.Error("timeout reached")
			os.Exit(1)
		}

		time.Sleep(SLEEP_INTERVAL)

		resp, err := http.PostForm(IPFS_URL, url.Values{})
		if err != nil {
			slog.Error("POST request failed", "error", err)
			continue
		}

		status = resp.StatusCode

		if err := resp.Body.Close(); err != nil {
			slog.Error(err.Error())
		}
	}
}
