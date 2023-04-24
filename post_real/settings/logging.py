from .base import PAPERTRAIL_HOST, PAPERTRAIL_PORT, BOT_TOKEN, CHAT_ID


LOGGING = {
    # Define the logging version
    'version': 1,

    # Enable the existing loggers
    'disable_existing_loggers': False,

    'filters': {
        'require_debug_true': {
            '()': 'django.utils.log.RequireDebugTrue',
        }
    },

    # Define the formatters
    'formatters': {
            'verbose': {
            'format': '[%(levelname)s] [%(asctime)s] [%(module)s] [%(lineno)s] [%(message)s]'
            },
    },

    # Define the handlers
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'filters': ['require_debug_true'],
            'formatter': 'verbose'
        },
        'django': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': 'postreal-request.log',
            'formatter': 'verbose',
            'encoding': 'utf-8'
        },
        'info': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': 'postreal-info.log',
            # 'maxBytes': 50 * 1024 * 1024, #50MB
            'formatter': 'verbose',
            'encoding': 'utf-8'
        },
        'error': {
            'level': 'ERROR',
            'class': 'logging.FileHandler',
            'filename': 'postreal-error.log',
            'formatter': 'verbose',
            'encoding': 'utf-8'
        },
        'papertrail': {
            'level': 'INFO',
            'class': 'logging.handlers.SysLogHandler',                                                    
            'formatter': 'verbose',
            # 'address': (PAPERTRAIL_HOST, PAPERTRAIL_PORT)                                                 
        },
        'telegram': {
            'level': 'INFO',
            'class': 'post_real.services.telegram_handler.TelegramHandler',
            'bot_token': BOT_TOKEN,
            'chat_id': CHAT_ID,
        },
    },

   # Define the loggers
    'loggers': {
        'django.server': {
            'handlers': ['django', 'console', 'papertrail'],
            'level': 'INFO',
        },
        'django.request': {
            'handlers': ['django', 'console', 'papertrail'],
            'level': 'INFO',
        },
        'postreal-info': {
            'handlers': ['info', 'console', 'papertrail', 'telegram'],
            'level': 'INFO',
            'propagate': True,
        },
        'postreal-error': {
            'handlers': ['error', 'console', 'papertrail'],
            'level': 'ERROR',
            'propagate': True,
        },

        #db query logger
        'django.db.backends': {
            'level': 'DEBUG',
            'handlers': ['console'],
        }
    },
}