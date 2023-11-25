from flask import Flask, redirect, url_for, request, render_template
import os

# Get the current working directory
cwd = os.getcwd()

# Print the current working directory
print(cwd)
app = Flask(__name__)

global lastWarHeight
global lastBat
global lastSosEn
global lastHealthEn
global lastLightEn

lastWarHeight = "N/A"
lastBat = "N/A"
lastSosEn = "N/A"
lastHealthEn = "N/A"
lastLightEn = "N/A"

@app.route('/success/<name>')
def success(name):
   return 'welcome %s' % name

@app.route('/view',methods = ['GET'])
def view():
   if request.method == 'GET':
      return render_template(
        'view.html',
        warHeight = lastWarHeight,
        batPerc=lastBat,
        sosE = lastSosEn,
        healthE = lastHealthEn,
        lightE = lastLightEn
    )


@app.route('/send',methods = ['POST', 'GET'])
def sendData():
   if request.method == 'POST':
        global lastWarHeight
        global lastBat
        global lastSosEn
        global lastHealthEn
        global lastLightEn
        lastWarHeight = request.json['wardrobeHeight']
        lastBat = request.json['battery']
        lastSosEn = request.json['sosEn']
        lastHealthEn = request.json['healthEn']
        lastLightEn = request.json['lightEn']
        return "OK "
      #user = request.form['nm']
      #return redirect(url_for('success',name = user))
   else:
      return "Get For Bat"
if __name__ == '__main__':
   app.run( host = '10.71.71.118', debug = True)