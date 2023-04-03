import logging
from rest_framework.response import Response

logger = logging.getLogger('django')


def log_and_respond(data=None, status=None, message_code=None, message=None, exception=None, additional_data=None, response_data={}, no_response=False):
    if not additional_data:
        additional_data = {}

    if exception:
        logger.exception(exception)
    response_body = {
        "code": message_code,
        "message": message,
        "data": data or {},
        **additional_data
      }
    response_data['code'] = response_body['code']
    response_data['message'] = response_body['message']
    response_data['data'] = response_body['data']
    
    if additional_data:
        for key, value in additional_data.items():
            response_data[key] = value
    # this optional arg is used to just return the standard format for response
    # reason -> While validation error we need to have the 
    # same format for response 
    if no_response:
        return response_body
    return Response(response_body, status)

