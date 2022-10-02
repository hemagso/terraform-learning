from typing import TYPE_CHECKING

import boto3

if TYPE_CHECKING:
    from boto3_type_annotations.dynamodb import ServiceResource as DynamoDBResource
    from boto3_type_annotations.dynamodb import Table


def lambda_handler(event, context):
    dynamodb: DynamoDBResource = boto3.resource("dynamodb")
    reported_income = dynamodb.Table("reported_income")
    return {"event": event, "context": repr(context)}
