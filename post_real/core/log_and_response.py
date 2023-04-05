import logging
from rest_framework.response import Response

# logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s", datefmt="%Y-%m-%d %H:%M:%S",)

logger = logging.getLogger('django')
info_logger = logging.getLogger('postreal-info')
error_logger = logging.getLogger('postreal-error')


def generic_response(success=None, message=None, data=None, status=None, additional_data=None, no_response=False):
    if not additional_data:
        additional_data = {}

    response_body = {
        "success": success,
        "message": message,
        "data": data or {},
        **additional_data
      }
    
    # this optional arg is used to just return the standard format for response
    # reason -> While validation error we need to have the 
    # same format for response 
    if no_response:
        return response_body
    return Response(response_body, status)

