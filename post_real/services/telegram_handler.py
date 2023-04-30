import logging

from post_real.services.tasks.send_logs_to_telegram import log_info_on_telegram


class TelegramHandler(logging.Handler):
    """
    Custom logging handler to send info level logs to telegram bot.
    """
    def __init__(self, bot_token, chat_id):
        super().__init__()
        self.bot_token = bot_token
        self.chat_id = chat_id

    def emit(self, record):
        log_info_on_telegram.delay(log=self.format(record), bot_token=self.bot_token, chat_id=self.chat_id)