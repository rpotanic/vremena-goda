#!/usr/bin/env bash
set -euo pipefail

set +x

for variable in TELEGRAM_BOT_TOKEN MINIAPP_URL; do
    if [[ -z "${!variable:-}" ]]; then
        printf 'Ошибка: необходимо задать %s.\n' "$variable" >&2
        exit 1
    fi
done

if [[ ! "$TELEGRAM_BOT_TOKEN" =~ ^[A-Za-z0-9_:-]+$ ]]; then
    printf 'Ошибка: неверный формат TELEGRAM_BOT_TOKEN.\n' >&2
    exit 1
fi

for dependency in curl python3; do
    if ! command -v "$dependency" >/dev/null; then
        printf 'Ошибка: требуется %s.\n' "$dependency" >&2
        exit 1
    fi
done

readonly api_url="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}"

call_bot_api() {
    local method="$1"
    local payload="$2"
    local url="$api_url/$method"

    # Передаём URL через stdin, чтобы токен не попал в аргументы процесса curl.
    if printf 'url = "%s"\n' "$url" |
        curl --disable --config - --silent --fail --max-time 30 \
            --request POST --header 'Content-Type: application/json' --data-binary "$payload" 2>/dev/null |
        python3 -c '
import json
import sys

response = json.load(sys.stdin)
sys.exit(0 if isinstance(response, dict) and response.get("ok") is True else 1)
' 2>/dev/null; then
        printf '%s: ok\n' "$method"
    else
        printf '%s: fail\n' "$method"
        return 1
    fi
}

menu_payload="$(python3 -c '
import json
import os

print(json.dumps({"menu_button": {
    "type": "web_app",
    "text": "Бронирование",
    "web_app": {"url": os.environ["MINIAPP_URL"]},
}}))
')"

call_bot_api setMyDescription '{"description":"Бот базы отдыха «Времена Года» в Нижегородской области. Здесь можно оформить бронирование и зарегистрировать гостей."}'
call_bot_api setMyShortDescription '{"short_description":"Бронирование на базе отдыха «Времена Года»."}'
call_bot_api setMyCommands '{"commands":[{"command":"start","description":"Забронировать"}]}'
call_bot_api setChatMenuButton "$menu_payload"
