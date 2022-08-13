package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	splits := strings.Split(os.Args[1], "/")
	if len(splits) != 2 {
		panic("first argument must be a namespaced-name in format <namespace>/<name>")
	}

	namespace := splits[0]
	name := splits[1]

	// fmt.Println(os.Args)

	ipRanges := make([]string, 0, len(os.Args))
	if len(os.Args)> 2 {
		ipRanges = os.Args[2:]
	} else {
		ipRanges = append(ipRanges, "0.0.0.0/0")
	}

	runServerProxy := fmt.Sprintf("kubectl run %s --namespace %s --image=nxtcoder17/alpine.python3:nonroot --restart=Never -- sh -c 'tail -f /dev/null'", name, namespace)
	b, err := exec.Command("bash", "-c", runServerProxy).CombinedOutput()
	fmt.Printf("(kubectl): %s", b)
	if err != nil {
		fmt.Printf("trying to use existing pod, in case it already exists\n")
		// fmt.Println("err occurred while creating pod:", err)
	}

	args := make([]string, 0, len(flag.Args()) * 2)
	args = append(args, "--dns", "-r", fmt.Sprintf("%s/%s", namespace, name), "-e", "ssh-vpn.go-khelper.sh")
	args = append(args, ipRanges...)
	c := exec.Command("sshuttle", args...)
	c.Stdin = os.Stdin
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr
	c.Run()
}

