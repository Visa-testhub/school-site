import os
from pathlib import Path

import pymysql
from flask import Flask, render_template

app = Flask(__name__, static_url_path="/viikko2/static")


def get_db_connection():
    # Systemd provides the database password as a credential.
    credentials_dir = Path(os.environ["CREDENTIALS_DIRECTORY"])
    password = (credentials_dir / "db_password").read_text(
        encoding="utf-8"
    ).strip()

    return pymysql.connect(
        unix_socket="/run/mysqld/mysqld.sock",
        user="viikko2_app",
        password=password,
        database="viikko2_db",
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor
    )


@app.route("/viikko2/")
def index():
    with get_db_connection() as connection:
        with connection.cursor() as cursor:

            # Increment the visitor counter.
            cursor.execute("""
                UPDATE visitor_counter
                SET visits = visits + 1
                WHERE id = 1
            """)

            # Read the updated counter value.
            cursor.execute("""
                SELECT visits
                FROM visitor_counter
                WHERE id = 1
            """)

            result = cursor.fetchone()

        # Save the change permanently.
        connection.commit()

    return render_template("index.html", visits=result["visits"])