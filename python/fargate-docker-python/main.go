package main

import (
	"encoding/base64"
	"fmt"
	"strings"

	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/ec2"
	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/ecr"
	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/ecs"
	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/iam"
	"github.com/pulumi/pulumi-docker/sdk/v3/go/docker"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		// Create a VPC
		vpc, err := ec2.NewVpc(ctx, "appVpc", &ec2.VpcArgs{
			CidrBlock: pulumi.String("10.0.0.0/16"),
		})
		if err != nil {
			return err
		}

		// Create a subnet
		subnet, err := ec2.NewSubnet(ctx, "appSubnet", &ec2.SubnetArgs{
			VpcId:     vpc.ID(),
			CidrBlock: pulumi.String("10.0.1.0/24"),
		})
		if err != nil {
			return err
		}

		// Create a security group
		sg, err := ec2.NewSecurityGroup(ctx, "appSg", &ec2.SecurityGroupArgs{
			VpcId: vpc.ID(),
		})
		if err != nil {
			return err
		}

		// Create an IAM role for the task execution
		executionRole, err := iam.NewRole(ctx, "appExecutionRole", &iam.RoleArgs{
			AssumeRolePolicy: pulumi.String(`{
				"Version": "2012-10-17",
				"Statement": [
					{
						"Action": "sts:AssumeRole",
						"Principal": {
							"Service": "ecs-tasks.amazonaws.com"
						},
						"Effect": "Allow",
						"Sid": ""
					}
				]
			}`),
		})
		if err != nil {
			return err
		}

		// Attach the AmazonECSTaskExecutionRolePolicy policy to the role
		_, err = iam.NewRolePolicyAttachment(ctx, "appExecutionRolePolicyAttachment", &iam.RolePolicyAttachmentArgs{
			Role:      executionRole.Name,
			PolicyArn: pulumi.String("arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"),
		})
		if err != nil {
			return err
		}

		// Create an ECR repository
		repo, err := ecr.NewRepository(ctx, "appRepo", &ecr.RepositoryArgs{
			Name: pulumi.String("app-repo"), // specify a valid name here
		})
		if err != nil {
			return err
		}

		// Create an ECR repository to store our app's Docker images
		token, err := ecr.GetAuthorizationToken(ctx, &ecr.GetAuthorizationTokenArgs{})
		if err != nil {
			return err
		}

		decodedToken, _ := base64.StdEncoding.DecodeString(token.AuthorizationToken)
		splitToken := strings.Split(string(decodedToken), ":")
		username := splitToken[0]
		password := splitToken[1]

		// Build and publish the app image.
		image, err := docker.NewImage(ctx, "appImage", &docker.ImageArgs{
			Build: &docker.DockerBuildArgs{
				Context: pulumi.String("./app"), // specify the path to your Dockerfile here
			},
			ImageName: repo.RepositoryUrl,
			Registry: &docker.ImageRegistryArgs{
				Server:   repo.RepositoryUrl,
				Username: pulumi.String(username),
				Password: pulumi.String(password),
			},
		})
		if err != nil {
			return err
		}

		// Create a Fargate cluster
		cluster, err := ecs.NewCluster(ctx, "appCluster", nil)
		if err != nil {
			return err
		}

		// Create a task definition
		containerDefinitions := image.ImageName.ApplyT(func(name string) (string, error) {
			return fmt.Sprintf(`[
				{
					"name": "appContainer",
					"image": "%s",
					"portMappings": [
						{
							"containerPort": 80,
							"hostPort": 80,
							"protocol": "tcp"
						}
					]
				}
			]`, name), nil
		}).(pulumi.StringOutput)

		taskDef, err := ecs.NewTaskDefinition(ctx, "appTaskDef", &ecs.TaskDefinitionArgs{
			Family:                  pulumi.String("appTaskDef"),
			RequiresCompatibilities: pulumi.StringArray{pulumi.String("FARGATE")},
			Cpu:                     pulumi.String("256"),
			Memory:                  pulumi.String("512"),
			NetworkMode:             pulumi.String("awsvpc"),
			ContainerDefinitions:    containerDefinitions,
			ExecutionRoleArn:        executionRole.Arn,
		})
		if err != nil {
			return err
		}

		// Create a Fargate service
		_, err = ecs.NewService(ctx, "appService", &ecs.ServiceArgs{

			Cluster:        cluster.Arn,
			TaskDefinition: taskDef.Arn,
			DesiredCount:   pulumi.Int(1),
			LaunchType:     pulumi.String("FARGATE"),
			NetworkConfiguration: &ecs.ServiceNetworkConfigurationArgs{
				AssignPublicIp: pulumi.Bool(true),
				Subnets:        pulumi.StringArray{subnet.ID()}, // Use the subnet ID
				SecurityGroups: pulumi.StringArray{sg.ID()},     // Use the security group ID
			},
		})
		if err != nil {
			return err
		}

		// Export the URL of the Service and the kubeconfig.
		ctx.Export("appUrl", image.ImageName)

		return nil
	})
}
