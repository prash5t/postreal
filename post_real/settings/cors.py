# cors headers
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8000",
    "http://127.0.0.1:8000",
]


# CORS_ORIGIN_ALLOW_ALL = True
CORS_ORIGIN_WHITELIST = [
    "http://localhost:8000",
    "http://127.0.0.1:8000",
]


CORS_ALLOW_HEADERS = [
    "x-total-count",
    "accept",
    "accept-encoding",
    "authorization",
    "content-type",
    "content-length",
    "dnt",
    "origin",
    "user-agent",
    "x-csrftoken",
    "x-requested-with",
    "access-control-allow-origin",
]

CORS_EXPOSE_HEADERS = [
    "x-total-count",
    "content-length",
]

