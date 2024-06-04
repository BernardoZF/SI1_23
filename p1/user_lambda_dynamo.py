import json
import boto3

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('si1p1')

# Función Lambda para insertar datos en DynamoDB
def lambda_handler(event, context):
    body = json.loads(event['body'])
    username = body['username']
    email = body['email']
    
    # Insertar el elemento en DynamoDB
    table.put_item(
        Item={
            'User': username,
            'Email': email
        }
    )
    
    # Retornar una respuesta de éxito
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'User added successfully'})
    }
