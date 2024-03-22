package main

import (
	"github.com/pulumi/pulumi-gcp/sdk/v7/go/gcp/blockchainnodeengine"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		_, err := blockchainnodeengine.NewBlockchainNodes(ctx, "defaultNode", &blockchainnodeengine.BlockchainNodesArgs{
			BlockchainNodeId: pulumi.String("blockchain_basic_node"),
			BlockchainType:   pulumi.String("ETHEREUM"),
			EthereumDetails: &blockchainnodeengine.BlockchainNodesEthereumDetailsArgs{
				ApiEnableAdmin:  pulumi.Bool(true),
				ApiEnableDebug:  pulumi.Bool(true),
				ConsensusClient: pulumi.String("LIGHTHOUSE"),
				ExecutionClient: pulumi.String("ERIGON"),
				Network:         pulumi.String("MAINNET"),
				NodeType:        pulumi.String("ARCHIVE"),
				ValidatorConfig: &blockchainnodeengine.BlockchainNodesEthereumDetailsValidatorConfigArgs{
					MevRelayUrls: pulumi.StringArray{
						pulumi.String("https://mev1.example.org/"),
						pulumi.String("https://mev2.example.org/"),
					},
				},
			},
			Labels: pulumi.StringMap{
				"environment": pulumi.String("dev"),
			},
			Location: pulumi.String("us-central1"),
		})
		if err != nil {
			return err
		}
		return nil
	})
}
