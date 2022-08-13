package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
)

func main() {
	var namespace string
	var name string
	flag.StringVar(&namespace, "namespace", "", "--namespace")
	flag.StringVar(&name, "name", "shuttle-proxy", "--name")
	flag.Parse()

	if namespace == "" || name == "" {
		panic("must specify --namespace and --name")
	}

	// fmt.Println("namespace: ", namespace)
	// fmt.Println(flag.Args())

	runServerProxy := fmt.Sprintf("kubectl run %s --namespace %s --image=nxtcoder17/alpine.python3:nonroot --restart=Never -- sh -c 'tail -f /dev/null'", name, namespace)

	kCmd := exec.Command("bash", "-c", runServerProxy)
	kCmd.Stderr = os.Stderr
	kCmd.Stdout = os.Stdout
	kCmd.Stdin = os.Stdin
	fmt.Printf("kubectl output: %v\n", kCmd.Run())

	args := make([]string, 0, len(flag.Args()) * 2)
	// args = append(args, "-c", "sshuttle", "--dns", "-r", name, "-e", "ssh-vpn.go-khelper.sh")
	args = append(args, "-c", fmt.Sprintf("sshuttle --dns -r %s -e ssh-vpn.go-khelper.sh", name))
	args = append(args, flag.Args()...)
	fmt.Printf("args: %v\n", args)
	c := exec.Command("bash", args...)
	c.Stdin = os.Stdin
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr
	fmt.Println(c.Run())
}

