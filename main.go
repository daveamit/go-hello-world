package main

import (
	"flag"
	"fmt"
)

var name = flag.String("name", "world", "name defaults to world")

func init() {
	flag.Parse()
}

func main() {
	fmt.Println(fmt.Sprintf("Hello, %s", *name))
}
