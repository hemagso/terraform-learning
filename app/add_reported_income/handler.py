from __future__ import annotations

from decimal import Decimal
from enum import Enum
from typing import TYPE_CHECKING, Optional
from uuid import UUID, uuid4

import boto3

from pydantic import AnyUrl, BaseModel, Field

if TYPE_CHECKING:
    from boto3_type_annotations.dynamodb import ServiceResource as DynamoDBResource
    from boto3_type_annotations.dynamodb import Table


class ReportedIncomeStatus(str, Enum):
    NO_CORROBORATION = "NO_CORROBORATION"
    WAITING_AUTOMATED_VALIDATION = "WAITING_AUTOMATED_VALIDATION"
    WAITING_HUMAN_VALIDATION = "WAITING_HUMAN_VALIDATION"
    VALIDATED = "VALIDATED"
    REJECTED = "REJECTED"
    EXPIRED = "EXPIRED"


class ReportedIncome(BaseModel):
    report_id: UUID = Field(default_factory=uuid4)
    customer_id: UUID
    value: Decimal
    status: ReportedIncomeStatus
    document_uri: Optional[AnyUrl] = None

    def to_item(self) -> dict[str, str]:
        return {key: str(value) for key, value in self.dict(exclude_none=True).items()}


def lambda_handler(event, context):
    report = ReportedIncome(**event)
    dynamodb: DynamoDBResource = boto3.resource("dynamodb")
    reported_income: Table = dynamodb.Table("reported_income")
    reported_income.put_item(Item=report.to_item())
    return event
