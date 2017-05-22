#!/usr/bin/env bash

set -e

while [[ $# -gt 1 ]]
do
    key="$1"

    case $key in
        -b|--bucket)
        BUCKET="$2"
        shift
        ;;
        -s|--stack-name)
        STACK_NAME="$2"
        shift
        ;;
        *)
        # Unknown
        ;;
    esac
    shift # past argument or value
done

if [[ -z $BUCKET ]]; then
    echo "Bucket not specified by -b | --bucket, defaulting to storeapp-build-artifacts"
    BUCKET="storeapp-build-artifacts"
fi

if [[ -z $STACK_NAME ]]; then
    echo "Stack must be set by -s or --stack-name"
    exit 1
fi

TEMPLATE_FILE="template.sam.yml"
TEMPLATE_OUTPUT_FILE="template.sam.output.yml"

echo "Packaging and uploading application to $BUCKET in region $REGION"

aws cloudformation package \
    --template-file $TEMPLATE_FILE \
    --output-template-file $TEMPLATE_OUTPUT_FILE \
    --s3-bucket $BUCKET

echo "Deploying to stack $STACK_NAME"

aws cloudformation deploy \
    --template-file $TEMPLATE_OUTPUT_FILE \
    --capabilities CAPABILITY_IAM \
    --stack-name $STACK_NAME
