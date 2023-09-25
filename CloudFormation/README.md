# CloudFormation Doc

## AWS CLI commands to deploy new stack change

```
aws cloudformation update-stack --stack-name=uCloud-Multi-branch-CodePipeline --template-url=http://s3.amazonaws.com/cf-templates-1ffsmcfmp8z7z-us-west-1/uCloud-Setup.yaml --capabilities CAPABILITY_NAMED_IAM
aws s3 cp CloudFormation/uCloud-Setup.yaml s3://cf-templates-1ffsmcfmp8z7z-us-west-1/
```