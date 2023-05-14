import io
import gzip
from PIL import Image

from django.core.exceptions import ValidationError
from django.core.files.uploadedfile import UploadedFile
from django.db.models.fields.files import ImageFieldFile
from django.core.files.uploadedfile import InMemoryUploadedFile


def validate_image_size(image: UploadedFile) -> None:
    """
    Validate image size.
    Rejects image which is more than 25 MB.
    """
    MEGABYTE_LIMIT: int = 25
    filesize = image.size

    if filesize > MEGABYTE_LIMIT * 1024 * 1024:
        raise ValidationError(f"Max allowed file size is {MEGABYTE_LIMIT}MB")


def compress_image(image:ImageFieldFile) -> InMemoryUploadedFile:
    """
    Compress in-memory-upload image.
    """
    # Create a buffer to hold the compressed data
    buffer = io.BytesIO()
    # Open the image and save it to the buffer as JPEG
    with Image.open(image) as img:
        image_size_in_bytes = image.size   # in bytes
        image_size_in_mb = image_size_in_bytes / (1024 * 1024)  # to megabytes (MB)
        if image_size_in_mb >= 2:
            img.convert('RGB').save(buffer, format='JPEG', optimize=True, quality=25)
        else:
            img.convert('RGB').save(buffer, format='JPEG', optimize=True, quality=50)

    # Compress the buffer using gzip
    # buffer.seek(0)
    # gzipped_buffer = gzip.compress(buffer.read())

    # Create a new InMemoryUploadedFile instance with the compressed data
    compressed_image = InMemoryUploadedFile(
        buffer,  # The compressed data
        image.name,  # The original file name
        image.name,  # The new file name with .gz extension
        image.content_type,  # The content type of the file
        None,  # The file size
        None,  # The charset (set to None for binary data)
    )
    return compressed_image