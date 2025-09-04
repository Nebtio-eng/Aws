import time
import main_1
import pymysql
import threading
from flask import Flask, request, jsonify
global temperature, humidity, rain, soil
app = Flask(__name__)
latest_direction = "Clear"

def get_db_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='root',
        port=3306,
        db='lanslide',
        charset='utf8'
    )
# Route to add readings
@app.route('/test', methods=['POST'])
def test():
    val = request.get_data().decode()
    res = val.split(',')

    # Extracting data and converting to appropriate types
    temperature = float(res[0])  # Assuming temperature can have decimal places
    humidity = float(res[1])  # Assuming humidity can have decimal places
    soil = float(res[2])  # Assuming soil is an integer value
    rain = float(res[3])  # Assuming rain measurements can have decimal places
    rain2 = float(res[4])
    rain3 = float(res[5])
    rain4 = float(res[6])
    tilt = float(res[7])  # Assuming tilt is an integer value

    print("temperature:", temperature)
    print("humidity:", humidity)
    print("soil:", soil)
    print("rain1:", rain)
    print("rain2:", rain2)
    print("rain3:", rain3)
    print("rain4:", rain4)
    print("tilt:", tilt)

    # Inserting data into database
    with get_db_connection() as con:
        with con.cursor() as cmd:
            query = "INSERT INTO readings (id, temp, hum, soil, rain, rain2, rain3, rain4, tilt) VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s)"
            cmd.execute(query, (temperature, humidity, soil, rain, rain2, rain3, rain4, tilt))
            con.commit()

            # Checking conditions and sending notifications
            if temperature > 30:
                notification_query = "INSERT INTO notifications (id, description, date, time) VALUES (NULL, %s, CURDATE(), CURTIME())"
                cmd.execute(notification_query, ("High Temperature Alert: " + str(temperature) + "°C",))
                con.commit()
                print("High temperature!")

            if soil > 80.00:
                notification_query = "INSERT INTO notifications (id, description, date, time) VALUES (NULL, %s, CURDATE(), CURTIME())"
                cmd.execute(notification_query, ("chance for flood: " + str(soil),))
                con.commit()
                print("chance for flood !")

            if tilt > 70:
                notification_query = "INSERT INTO notifications (id, description, date, time) VALUES (NULL, %s, CURDATE(), CURTIME())"
                cmd.execute(notification_query, ("Landslide detected",))
                con.commit()
                print("Landslide detected!")

    return jsonify({"message": "Data added successfully"})


def detect():
    print("Detecting...")

    # Fetch the latest sensor values from the database
    with get_db_connection() as con:
        with con.cursor() as cmd:
            cmd.execute("SELECT temp, hum, soil, rain FROM readings ORDER BY id DESC LIMIT 1")
            result = cmd.fetchone()

            if result:
                temperature, humidity, soil, rain = result  # Unpacking values from database
            else:
                print("No readings available in database")
                return

    # Ensure values are correct before using them
    print(f"Temperature: {temperature}, Humidity: {humidity}, Rain: {rain}, Soil: {soil}")

    # Call ML Model with sensor values
    prediction = main_1.load_data(temperature, humidity, rain, soil)
    print(f"Prediction: {prediction}")

    # Store prediction result in the database
    with get_db_connection() as con:
        with con.cursor() as cmd:
            if prediction == 'Landslide':
                cmd.execute("INSERT INTO notifications (id, description, date, time) VALUES (NULL, %s, CURDATE(), CURTIME())",
                            ("Landslide predicted",))
                print("Landslide predicted!")
            else:
                cmd.execute("INSERT INTO notifications (id, description, date, time) VALUES (NULL, %s, CURDATE(), CURTIME())",
                            ("No landslide predicted",))
                print("No landslide predicted!")
            con.commit()


def main():
    threading.Thread(target=connect).start()  # Start Flask server in a separate thread
    print("Server started...")

    while True:
        time.sleep(10)  # Run detection every 10 seconds
        print("Running detection...")
        detect()




@app.route('/notifications', methods=['GET'])
def get_notifications():
    with get_db_connection() as con:
        with con.cursor() as cmd:
            query = "SELECT description, date, time FROM notifications ORDER BY id DESC"
            cmd.execute(query)
            notifications = cmd.fetchall()

            notification_list = [
                {"description": row[0], "date": str(row[1]), "time": str(row[2])} for row in notifications
            ]
    return jsonify({"notifications": notification_list})

# Route to fetch the latest readings
@app.route('/readings', methods=['GET'])
def readings():
    try:
        with get_db_connection() as con:
            with con.cursor() as cmd:
                query = "SELECT temp, hum, soil, tilt FROM readings ORDER BY id DESC LIMIT 1"
                cmd.execute(query)
                result = cmd.fetchone()

                if result:
                    response = {
                        "temperature": result[0],  # Correct index
                        "humidity": result[1],     # Correct index
                        "soil": result[2],         # Correct index
                        "tilt": result[3],         # Corrected from result[7] to result[3]
                    }
                    print(response)
                    return jsonify(response), 200
                else:
                    return jsonify({"message": "No data available"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/update-directions', methods=['POST'])
def update_directions():
    global latest_direction
    data = request.get_json()
    if "direction" in data:
        latest_direction = data["direction"]
        print(f"Updated Direction: {latest_direction}")
        return jsonify({"message": "Direction updated successfully"}), 200
    return jsonify({"error": "Invalid data"}), 400

@app.route('/get-directions', methods=['GET'])
def get_directions():

    global latest_direction



    return jsonify({"direction": latest_direction}), 200


def connect():
    app.run(host='0.0.0.0', port=5000)

if __name__ == '__main__':
    main()