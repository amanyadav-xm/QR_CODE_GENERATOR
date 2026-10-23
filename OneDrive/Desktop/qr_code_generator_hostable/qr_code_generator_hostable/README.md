# QR Code Generator — Host-ready Web App

This converts a URL or plain text into a QR code in your browser. It replaces the original Tkinter desktop interface with a web UI so it can be hosted online.

## Run locally (Windows)

1. Install Python 3.10+.
2. Open Command Prompt in this folder.
3. Create and activate a virtual environment:

   ```bat
   py -m venv .venv
   .venv\Scripts\activate
   ```

4. Install dependencies:

   ```bat
   pip install -r requirements.txt
   ```

5. Start the app:

   ```bat
   python app.py
   ```

6. Open `http://127.0.0.1:5000` in your browser.

## Deploy to Render

1. Upload this folder to a GitHub repository.
2. In Render, choose **New + → Web Service**, then connect the repository.
3. Set **Build Command** to `pip install -r requirements.txt`.
4. Set **Start Command** to `gunicorn app:app`.
5. Deploy. Render detects the Python runtime from `runtime.txt` on supported setups; if the platform ignores it, select Python 3.12 in its settings.

## Deploy to Railway / other Python hosts

- Build/install command: `pip install -r requirements.txt`
- Start command: `gunicorn app:app`

## Notes

- The app does not save user-submitted content or generated QR images on the server; each PNG is generated in memory and returned to the browser.
- URL-like input without a scheme (for example, `example.com`) is normalized to `https://example.com`.
- Plain text is also supported.
- This is a basic single-service app. Add rate limiting or other protections before exposing it to heavy public traffic.
