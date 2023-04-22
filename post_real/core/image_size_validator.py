from django.core.exceptions import ValidationError

def validate_image_size(image):
    """
    Validate image size.
    Rejects image which is more than 25 MB.
    """
    MEGABYTE_LIMIT: int = 25
    filesize = image.size

    if filesize > MEGABYTE_LIMIT * 1024 * 1024:
        raise ValidationError(f"Max allowed file size is {MEGABYTE_LIMIT}MB")