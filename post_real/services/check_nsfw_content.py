import requests
from django.conf import settings
from typing import Tuple, Dict, Any


def check_explicit_image(imageUrl:str) -> Tuple[Dict[str, Any], bool]:
    """
    Check nsfw_likelihood of image using edenai explicit-content checker api.
    """
    url = "https://api.edenai.run/v2/image/explicit_content"
    payload = {
        "response_as_dict": True,
        "attributes_as_list": False,
        "show_original_response": False,
        "providers": "amazon",
        "file_url": imageUrl
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {settings.EDEN_AI_API_KEY}"
    }   
    response = requests.post(url, json=payload, headers=headers)
    data={}
    is_explicit=False
    if response.status_code==200:
        data = response.json()
        likelihood = data.get("amazon").get("nsfw_likelihood")
        if likelihood and (likelihood > 2): is_explicit = True

    return data, is_explicit