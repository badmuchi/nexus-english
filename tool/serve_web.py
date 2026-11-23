#!/usr/bin/env python3
"""
Local development server for Nexus English Web.
Serves the build/web directory with Cross-Origin-Opener-Policy (COOP) and
Cross-Origin-Embedder-Policy (COEP) headers required for SQLite WASM & Web Workers.
"""

import http.server
import os
import socketserver
import sys

PORT = 8080
DIRECTORY = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "build", "web")

class CoopCoepHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "credentialless")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

def main():
    if not os.path.isdir(DIRECTORY):
        print(f"Error: Directory '{DIRECTORY}' not found.")
        print("Run 'flutter build web' first to compile the web bundle.")
        sys.exit(1)

    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), CoopCoepHandler) as httpd:
        print(f"🚀 Nexus English Web local server running at:")
        print(f"👉 http://localhost:{PORT}")
        print("Press Ctrl+C to stop.")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")

if __name__ == "__main__":
    main()
