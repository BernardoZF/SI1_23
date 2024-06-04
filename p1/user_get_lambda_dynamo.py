import json
import boto3
from boto3.dynamodb.conditions import Key

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('si1p1')

# Función Lambda para obtener el usuario desde DynamoDB
def lambda_handler(event, context):
    username = event['pathParameters']['username']
    
    # Obtener el elemento desde DynamoDB
    response = table.get_item(
        Key={
            'User': username
        }
    )
    
    # Verificar si el elemento existe y retornar la respuesta correspondiente
    if 'Item' in response:
        return {
            'statusCode': 200,
            'body': json.dumps(response['Item'])
        }
    else:
        return {
            'statusCode': 404,
            'body': json.dumps({'error': 'User not found'})
        }
