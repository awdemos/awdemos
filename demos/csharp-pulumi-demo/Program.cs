using Pulumi;
using Pulumi.AwsNative.S3;
using System.Collections.Generic;

return await Deployment.RunAsync(() =>
{
    // Create an AWS resource (S3 Bucket)
    var bucket = new Bucket("my-very-cool-bucket");

    // Export the name of the bucket
    return new Dictionary<string, object?>
    {
        ["bucketName"] = bucket.Id
    };
});
