import network
import socket
import machine

uart = machine.UART(0, 115200)  # Default (change if needed)

# WiFi Config (Change SSID & Password)
ssid = "Micky"
password = "CottonTail."

# Set up WiFi
sta_if = network.WLAN(network.STA_IF)
sta_if.active(True)
sta_if.connect(ssid, password)

# Wait for connection
while not sta_if.isconnected():
    pass

print("Connected! IP:", sta_if.ifconfig()[0])

# Simple HTTP Server
def web_page():
    return """<html><body><h1>Kavi</h1></body></html>"""

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 80))
s.listen(5)

while True:
    conn, addr = s.accept()
    request = conn.recv(1024)
    response = web_page()
    conn.send("HTTP/1.1 200 OK\n")
    conn.send("Content-Type: text/html\n")
    conn.send("Connection: close\n\n")
    conn.sendall(response)
    conn.close()