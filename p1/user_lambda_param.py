import json
import boto3

# Inicializar el cliente de S3
s3 = boto3.client('s3')
BUCKET_NAME = 'si1p1'

# Función Lambda para guardar datos en S3
def lambda_handler(event, context):
    body = json.loads(event['body'])
    username = event['pathParameters']['username']
    data = body['data']
    
    # Ruta del archivo en S3
    file_path = f'users/{username}/data.json'
    
    # Guardar los datos en S3
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=file_path,
        Body=json.dumps(body)
    )
    
    # Retornar una respuesta de éxito
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Data saved successfully'})
    }
