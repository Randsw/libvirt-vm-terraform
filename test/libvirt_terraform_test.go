package test

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type vm struct {
	id string
	ip string
}

type domain struct {
	name   string
	cpu    int64
	ram    int64
	disk   int64
	bridge string
}

func TestTerraformlibvirt(t *testing.T) {
	// retryable errors in terraform testing.
	var vms []vm
	desiredCount := 2
	desiredNamePrefix := "dev"
	desiredDomains := "[{\"name\":\"1\",\"cpu\":1,\"ram\":512,\"disk\":10737418240,\"bridge\":\"virbr0\"}," +
		"{\"name\":\"2\",\"cpu\":2,\"ram\":1024,\"disk\":21474836480,\"bridge\":\"virbr0\"}]"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"prefix":  desiredNamePrefix,
			"domains": desiredDomains,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "vms_info")
	outputStr := strings.Trim(output, "[]")
	mapStr := regexp.MustCompile(` map`).Split(outputStr, -1)
	for _, item := range mapStr {
		if item != "" {
			regexp := regexp.MustCompile(`id:([^ ]+) ip:([^ ]+)`)
			matches := regexp.FindStringSubmatch(item)
			if len(matches) == 3 {
				vmItem := vm{
					id: strings.TrimSpace(matches[1]),
					ip: strings.TrimSpace(matches[2]),
				}
				vms = append(vms, vmItem)
			} else {
				fmt.Printf("could not parse %s\\n", item)
			}
		}
	}
	assert.Equal(t, desiredCount, len(vms))
	for i, vm := range vms {
		assert.Equal(t, desiredNamePrefix+"-"+strconv.Itoa(i+1), vm.id)
	}
}
