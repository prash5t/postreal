import logging
import telepot
import requests
import ast


class TelegramHandler(logging.Handler):
    """
    Custom logging handler to send logs info on telegram bot.
    """
    def __init__(self, bot_token, chat_id):
        super().__init__()
        self.bot_token = bot_token
        self.chat_id = chat_id

    def emit(self, record):
        log = self.format(record)
        chat_ids = ast.literal_eval(self.chat_id)
        bot = telepot.Bot(token=self.bot_token)
        for id in chat_ids:
            # url = f"https://api.telegram.org/bot{self.bot_token}/sendMessage?chat_id={id}&text={log}"
            # requests.get(url)

            bot.sendMessage(id, log)
        