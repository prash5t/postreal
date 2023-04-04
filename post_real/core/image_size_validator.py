from django.core.exceptions import ValidationError


def validateImageSize(image):
    MEGABYTE_LIMIT = 25
    filesize = image.size

    if filesize > MEGABYTE_LIMIT * 1024 * 1024:
        raise ValidationError(f"Max allowed file size is {MEGABYTE_LIMIT}MB")