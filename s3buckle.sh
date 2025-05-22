#!/bin/bash

# Step 1: Set AWS credentials as environment variables
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION=""
export AWS_APP_ID=""
export AWS_BRANCH=""
# $1 are the parameters. $0 are the commands whereas, in this context $0 isn't used.
export BUCKET_NAME="$1"

aws s3 ls s3://$BUCKET_NAME --region $AWS_DEFAULT_REGION

# Step 2: Generate a new script for upload to S3 bucket
cat <<EOF > upload.sh
#!/bin/bash
aws s3 sync . s3://$BUCKET_NAME --region $AWS_DEFAULT_REGION
aws amplify  start-deployment \
 --app-id $AWS_APP_ID \
 --branch-name $AWS_BRANCH \
 --region $AWS_DEFAULT_REGION \
 --source-url s3://$BUCKET_NAME/ \
 --source-url-type BUCKET_PREFIX
EOF

chmod +x upload.sh

echo "Script 'upload to S3 & Amplify-Start!' generated successfully"
