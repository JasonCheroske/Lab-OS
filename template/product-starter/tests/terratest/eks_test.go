package terratest

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// EKS apply against LocalStack is often incomplete; prefer staging AWS for real assertions.
func TestEksClusterReachabilityStub(t *testing.T) {
	t.Skip("Enable with a dedicated test harness and kubeconfig from terraform output; see .lab/reality/ARCHITECTURE.md")

	opts := &terraform.Options{
		TerraformDir: "../../modules/eks",
		Vars: map[string]interface{}{
			"cluster_name":         "tt-eks",
			"vpc_id":               "vpc-placeholder",
			"subnet_ids":           []string{"subnet-a", "subnet-b"},
			"private_subnet_ids":   []string{"subnet-a", "subnet-b"},
			"endpoint_public_access": true,
			"node_instance_types":  []string{"t3.medium"},
			"node_desired_size":    1,
			"node_min_size":        1,
			"node_max_size":        2,
		},
		NoColor: true,
	}

	terraform.Init(t, opts)
	// Intentionally no apply: placeholders are invalid IDs.
	_ = opts
}
