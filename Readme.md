Configure terraform backend to store state files. I have used cloudformation template to configure the backend.

## Execute following command.

aws cloudformation deploy --stack-name terraform-backend-dev-123456789011 --template-file cloudformation/tfbackend.yml --parameter-overrides AppName="app" Environment="dev" AccountID="123456789011"