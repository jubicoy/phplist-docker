package main

import "os/exec"
import "strings"
import "time"
import "fmt"
import "os"
import "github.com/robfig/cron"


func register_task(task_string string, c *cron.Cron) {
	fmt.Printf("Registering task: %s\n", task_string)
	task_string_split := strings.Split(task_string, "|")
	schedule_string := task_string_split[0]
	command_string := task_string_split[1]

	c.AddFunc(schedule_string, func() {
		out, err := exec.Command("sh","-c",command_string).Output()
		if err != nil {
			fmt.Println(err)
		} else {			
			fmt.Printf("Executing command: %s\n%s\n", command_string, out)
		}
		})
}

func main() {
	c := cron.New()
	env_array := os.Environ()

	for _, env := range env_array {
		if strings.Contains(env, "TASK_") {
			env_split := strings.Split(env, "=")
			register_task(env_split[1], c)
		}
	}

	c.Start()

	for {
		time.Sleep(1 * time.Second)
	}

	c.Stop()
}