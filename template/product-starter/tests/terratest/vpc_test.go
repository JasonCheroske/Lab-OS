package terratest

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// At experiment stage this is a contract placeholder. Enable after LocalStack (or AWS)
// has working state and point TerraformDir at a disposable test root if desired.
func TestVpcModuleOutputsMatchContract(t *testing.T) {
	t.Skip("Enable when terratest + LocalStack (or staging) is wired; see .lab/evidence/VALIDATION_MATRIX.md")

	opts := &terraform.Options{
		TerraformDir: "../../modules/vpc",
		Vars: map[string]interface{}{
			"name_prefix":          "tt-vpc",
			"cidr_block":           "10.99.0.0/16",
			"azs":                  []string{"us-east-1a", "us-east-1b"},
			"enable_nat_gateway":   false,
			"tags":                 map[string]string{"Test": "terratest"},
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	vpcID := terraform.Output(t, opts, "vpc_id")
	assert.NotEmpty(t, vpcID)
	publicIDs := terraform.OutputList(t, opts, "public_subnet_ids")
	assert.GreaterOrEqual(t, len(publicIDs), 1)
}
