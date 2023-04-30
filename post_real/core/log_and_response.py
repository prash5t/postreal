import logging
from typing import Any

from rest_framework import status
from rest_framework.response import Response


# logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s", datefmt="%Y-%m-%d %H:%M:%S",)

# initializing loggers with its types  
logger = logging.getLogger('django')
info_logger = logging.getLogger('postreal-info')
error_logger = logging.getLogger('postreal-error')


def generic_response(success:bool|None=None, message:str|None=None, data:dict|None=None, status:int|None=None, additional_data:dict|None=None) -> Response:
    """
    Generic API response structure.
    Returns response with same format for all apis.
    """
    if not additional_data:
        additional_data = {}

    response_body = {
        "success": success,
        "message": message,
        **additional_data,
        "data": data or {},
      }
    
    return Response(response_body, status)



def log_exception(error:Any) -> Response:
    """
    Log and respond unknown exceptions. 
    """
    error_logger.error(error)
    return generic_response(
                success=False,
                message="Something Went Wrong!",
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


def log_field_error(error:Any) -> Response:
    """
    Response for Invalid Input/Field Error.
    """
    return generic_response(
        success=False,
        message='Invalid Input/Field Error',
        data=error,
        status=status.HTTP_400_BAD_REQUEST
    )


def post_not_found_error() -> Response:
    """
    Response for post doesn't exist exception.
    """
    return generic_response(
            success=False,
            message="Post Doesn't Exists!",
            status=status.HTTP_404_NOT_FOUND
        )