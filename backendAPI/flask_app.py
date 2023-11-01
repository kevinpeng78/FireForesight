from flask import Flask, jsonify, request
import rasterio
from rasterio.warp import transform
from geopy.geocoders import Nominatim

app = Flask(__name__)
path = '/home/kevinpeng345/mysite/whp.tif'
geolocator = Nominatim(user_agent='fireforesight')

def getRisk(lat, lon):
    src = rasterio.open(path)
    transformed_coords = transform(src_crs={'init': 'EPSG:4326'},
                                   dst_crs = rasterio.open(path).crs,
                                   xs = [lon], ys = [lat])
    x = transformed_coords[0][0]
    y = transformed_coords[1][0]
    col, row = ~src.transform * (x, y)
    col, row = int(col), int(row)
    inBounds = (0 <= row < src.height) and (0 <= col < src.width)
    pixVal = None
    if(inBounds):
        pixVal = src.read(1)[row, col]
    return pixVal
def getCoord(zip):
    location = geolocator.geocode(str(zip))
    return location.latitude, location.longitude


@app.route('/calculate', methods=['GET'])
def calculate():
    latitude = request.args.get('latitude', type=float)
    longitude = request.args.get('longitude', type=float)
    risk = int(getRisk(latitude, longitude))
    return jsonify({"output": risk})

@app.route('/calculatezip', methods=['GET'])
def calculatezip():
    zip = request.args.get('zip', type=int)
    if zip is None:
        return jsonify({"error": "Missing zip parameter"}), 400
    latitude, longitude = getCoord(zip)
    risk = int(getRisk(latitude, longitude))
    return jsonify({"output": risk})

if __name__ == '__main__':
    app.run(debug=True)