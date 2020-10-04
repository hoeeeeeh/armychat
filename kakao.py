from flask import Flask, jsonify,request
import time
app = Flask(__name__)
@app.route("/", methods=["POST"])
def response():
    query = dict(request.form)['query']
    res = query + " " + time.ctime()
    print(query)
    return jsonify({'response' : res})
    #return jsonify({"response" : res})
if __name__=="__main__":
    app.run(host="0.0.0.0",port=5000)