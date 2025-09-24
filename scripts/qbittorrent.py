import sys
import requests

def changePassword(actual_password):
    auth = requests.post("http://localhost:8080/api/v2/auth/login", 
                data={"username": "admin", "password": actual_password})
    assert auth.status_code == 200

    edit = requests.post("http://localhost:8080/api/v2/app/setPreferences", 
                cookies=auth.cookies,
                data={"json": {"web_ui_password": "adminadmin"}})
    assert edit.status_code == 200

    auth = requests.post("http://localhost:8080/api/v2/auth/login", 
                data={"username": "admin", "password": "adminadmin"})
    assert auth.status_code == 200
    print("qbittorrent password changed!")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: tool.py <actual_password>")
    else:
        changePassword(sys.argv[1])
