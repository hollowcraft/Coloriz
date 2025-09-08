from flask import Flask, jsonify
from websocket import create_connection
import threading

app = Flask(__name__)

TWITCH_CHANNEL = "hollow_craft"  # Remplace par ton nom de chaîne Twitch
TWITCH_OAUTH = "oauth:xxxxxxxxxxxxxxxxxxxxx"  # Remplace par ton token OAuth
TWITCH_NICK = "hollow_craft"

messages = []

def listen_twitch():
    global messages
    ws = create_connection("wss://irc-ws.chat.twitch.tv:443")
    ws.send(f"PASS {TWITCH_OAUTH}\r\n")
    ws.send(f"NICK {TWITCH_NICK}\r\n")
    ws.send(f"JOIN #{TWITCH_CHANNEL}\r\n")

    while True:
        response = ws.recv()
        if "PRIVMSG" in response:
            parts = response.split(":", 2)
            if len(parts) > 2:
                user = parts[1].split("!")[0]
                msg = parts[2].strip()
                messages.append(f"{user}: {msg}")
                if len(messages) > 10:
                    messages.pop(0)  # Garde seulement les 10 derniers messages

@app.route("/chat")
def get_chat():
    return jsonify(messages)

if __name__ == "__main__":
    threading.Thread(target=listen_twitch, daemon=True).start()
    app.run(host="0.0.0.0", port=5000)
