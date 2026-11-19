import os
import pymysql
from flask import Flask, render_template, make_response

app = Flask(__name__)


@app.route("/")
def index():
    connection = pymysql.connect(
        unix_socket="/run/mysqld/mysqld.sock",
        user="viikko4reader",
        password=os.environ["DB_PASSWORD"],
        database="viikko2_db"
    )

    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT visits FROM visitor_counter WHERE id = 1"
            )
            visits = cursor.fetchone()[0]
    finally:
        connection.close()

    response = make_response(
        render_template("index.html", visits=visits)
    )
    response.headers["Cache-Control"] = "no-store"
    return response
