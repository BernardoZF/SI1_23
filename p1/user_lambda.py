import json

# Función Lambda para procesar datos de usuario
def lambda_handler(event, context):
    body = json.loads(event['body'])
    username = body['username']
    first_name = body['firstName']
    
    # Crear un mensaje de respuesta
    response_message = {
        'username': username,
        'firstName': first_name,
        'status': 'processed'
    }
    
    # Retornar la respuesta como un JSON
    return {
        'statusCode': 200,
        'body': json.dumps(response_message)
    }
