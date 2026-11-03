from flask import Flask, render_template

app = Flask(__name__, static_url_path="/viikko2/static")

@app.route("/viikko2/")
def index():
    return render_template("index.html")