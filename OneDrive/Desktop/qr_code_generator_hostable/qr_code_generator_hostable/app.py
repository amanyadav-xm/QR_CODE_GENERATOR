import io
import re
from flask import Flask, render_template, request, send_file
import qrcode
from qrcode.constants import ERROR_CORRECT_M

app = Flask(__name__)

def looks_like_url(value: str) -> bool:
    # Allow regular URLs and simple text payloads; prepend https:// for domain-like input.
    value = value.strip()
    if not value:
        return False
    if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*://", value):
        return True
    if re.match(r"^(localhost|\d{1,3}(?:\.\d{1,3}){3})(:\d+)?(?:/.*)?$", value):
        return True
    return bool(re.match(r"^(?:[\w-]+\.)+[a-zA-Z]{2,}(?::\d+)?(?:/.*)?$", value))

def normalize_payload(value: str) -> str:
    value = value.strip()
    if looks_like_url(value) and not re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*://", value):
        return "https://" + value
    return value

@app.get("/")
def index():
    return render_template("index.html")

@app.post("/generate")
def generate():
    raw = request.form.get("content", "").strip()
    if not raw:
        return render_template("index.html", error="Please enter a link or text to encode."), 400
    if len(raw) > 4000:
        return render_template("index.html", error="Please keep the content under 4,000 characters."), 400

    payload = normalize_payload(raw)
    qr = qrcode.QRCode(
        version=None,
        error_correction=ERROR_CORRECT_M,
        box_size=10,
        border=4,
    )
    qr.add_data(payload)
    qr.make(fit=True)
    image = qr.make_image(fill_color="#2563eb", back_color="#ffffff").convert("RGB")
    output = io.BytesIO()
    image.save(output, format="PNG")
    output.seek(0)
    return send_file(output, mimetype="image/png", as_attachment=False, download_name="qrcode.png")

if __name__ == "__main__":
    # Local development only. For hosting, use the Procfile / gunicorn command.
    app.run(host="0.0.0.0", port=5000, debug=False)
