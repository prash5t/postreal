import ast
import telepot
import requests
from celery import shared_task


@shared_task(name="logOnTelegram")
def log_info_on_telegram(log:str, bot_token:str, chat_id:str|list) -> None:
    """
    Task to send info level logs to telegram chatbot.
    """
    chat_ids = ast.literal_eval(chat_id)
    bot = telepot.Bot(token=bot_token)
    for id in chat_ids:
        bot.sendMessage(id, log)

        # url = f"https://api.telegram.org/bot{self.bot_token}/sendMessage?chat_id={id}&text={log}"
        # requests.get(url)