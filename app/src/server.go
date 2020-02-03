package main
 
import (
	"fmt"
	"log"
	"net/http"
	"os"
)
 
func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "OK")
	})
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "version: 2")
		fmt.Fprintln(w, "POD_NAME:" + os.Getenv("POD_NAME"))

		fmt.Fprintln(w, "■Headers")

		for key, values := range r.Header {
			for _, h := range values {
				fmt.Fprintln(w, key + ": " + h)
			}
		}

		fmt.Fprintln(w, "■Env")

		for _, e := range os.Environ() {
				fmt.Fprintln(w, e)
		}
	})
	log.Fatal(http.ListenAndServe(":8080", nil))
}
