import os
import json
import boto3
from botocore.exceptions import ClientError
from django.core.exceptions import ImproperlyConfigured


def get_secret(key:str) -> str|int|bool:
    """
    Get secrets from aws secret manager.
    """
    try:
        # Create a Secrets Manager client
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=os.environ.get("AWS_S3_REGION_NAME"),

            # attach iam role to ec2 instance and allow role access to that secret, then no need of access keys
            aws_access_key_id = os.environ.get("AWS_ACCESS_KEY_ID"),
            aws_secret_access_key =os.environ.get("AWS_SECRET_ACCESS_KEY")
        )

        get_secret_value_response = client.get_secret_value(
            SecretId=os.environ.get("AWS_SECRET_NAME")
        )

        # Decrypts secret using the associated KMS key.
        response = get_secret_value_response['SecretString']
        secret = json.loads(response)
        return secret[key]
    
    except ClientError as e:
        raise e
    except KeyError:
        raise ImproperlyConfigured("{} key doesn't exist.".format(key))