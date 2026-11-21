# Времена Года — бронирование

Мини-приложение Telegram для бронирования и регистрации гостей базы отдыха «Времена Года» в Нижегородской области.

## Публикация на GitHub Pages

1. Поместите файлы поставки в ветку `main` публичного репозитория `rpotanic/vremena-goda`. Для бесплатного GitHub Pages нужен публичный репозиторий. Пустой файл `.nojekyll` уже есть в корне.
2. В настройках репозитория откройте **Settings → Pages**. В качестве источника выберите **Deploy from a branch**, ветку `main` и папку `/ (root)`. Сохраните настройки. [Документация GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
3. Когда [сайт](https://rpotanic.github.io/vremena-goda/) станет доступен, запустите из корня проекта скрипт настройки бота. Понадобятся Bash, curl и Python 3.

```bash
export TELEGRAM_BOT_TOKEN='…'
export MINIAPP_URL='https://rpotanic.github.io/vremena-goda/'
./bot/setup_bot.sh
```

Подставьте токен бота в переменную окружения. Скрипт задаёт описание бота, регистрирует команду `/start` и добавляет пункт меню «Бронирование», который открывает мини-приложение. [Документация Telegram Bot API](https://core.telegram.org/bots/api#setchatmenubutton)
