//usr/bin/env go run "$0" "$*"; exit "$?" 
package main

import "fmt"
import "net"
import "bufio"
import "net/textproto"
import "strings"
import "time"

func http_code(host, port string) string {
	conn, err := net.Dial("tcp", host + ":" + port)
	if err != nil {
		fmt.Print("Connect error: ")
		fmt.Println(err)
		return ""
	}

	defer conn.Close()

	fmt.Fprintf(conn, "GET / HTTP/1.0\n\n")

	reader := bufio.NewReader(conn)
	tp := textproto.NewReader(reader)

	buf, err := tp.ReadLine()

	if err != nil {
		fmt.Print("Read error: ")
		fmt.Println(err)
		return ""
	}

	slice := strings.Split(buf, " ")

	responseCode := slice[1]
	return responseCode
}
func main() {
	host := "ae4ecc0cd3e7e11eaa7b60af5d8098ff-f2c2c64cceb34a45.elb.ap-southeast-1.amazonaws.com"
	port := "80"
	duration := time.Millisecond * 500

	for {
		t := time.Now()

		code := http_code(host, port)
		fmt.Println(t.Format(time.RFC3339Nano) + ": " + code)

		time.Sleep(duration)
	}
}

