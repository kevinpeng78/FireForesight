import 'package:flutter/material.dart';
import 'requests.dart' as rq;
void main() => runApp(MyApp());

String risk = '';
String riskIndex = '';
enum LoadState {idle, running, complete}
LoadState loadState = LoadState.idle;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireForesight',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: fireForesightHome(),
    );
  }
}

class fireForesightHome extends StatefulWidget {
  @override
  _fireForesightHomeState createState() => _fireForesightHomeState();
}
final _latitudeController = TextEditingController();
final _longitudeController = TextEditingController();
final _zipController = TextEditingController();
class _fireForesightHomeState extends State<fireForesightHome> {
  

  Future getRisk() async {
  String output = '';
    if (_zipController.text == ''){
      output = await rq.getRiskCoord(_latitudeController.text, _longitudeController.text);
    }
    else{
      output = await rq.getRiskZip(_zipController.text);
    }
    return output;
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('FireForesight', style: TextStyle(fontSize: 25)),
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            
            children: <Widget>[
              TextField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(onPressed: (){_latitudeController.clear();}, icon: Icon(Icons.clear))
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 8.0), // Provides spacing between the text fields
              TextField(
                controller: _longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(onPressed: (){_longitudeController.clear();}, icon: Icon(Icons.clear))
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height:8.0),
              Text('OR',style: TextStyle(fontSize: 20)),
              SizedBox(height: 8.0),
              TextField(
                controller: _zipController,
                decoration: InputDecoration(
                  labelText: 'Zip Code',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(onPressed: (){_zipController.clear();}, icon: Icon(Icons.clear))
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
    
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loadState = LoadState.running;
                  });
                  String temp = await getRisk() as String;
                  
                  if (temp == '1')
                    riskIndex = 'Very Low';
                  if (temp == '2')
                    riskIndex = 'Low';
                  if (temp == '3')
                    riskIndex = 'Moderate';
                  if (temp == '4')
                    riskIndex = 'High';
                  if (temp == '5')
                    riskIndex = 'Very High';
                  if (temp == '6')
                    riskIndex = 'Non-burnable';
                  if (temp == '7')
                    riskIndex = 'Water';
                  setState(() {
                    risk = temp;
                    loadState = LoadState.complete;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OutputScreen()));
                },
                child: Text('Find Wildfire Risk'),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Your location\'s wildfire risk is: ',
              style: TextStyle(fontSize: 20)),
              
                ),
              ),
              if (loadState == LoadState.running)
                Column(children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                )
                ]),
              if (loadState == LoadState.complete)
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(risk,
                style: TextStyle(fontSize: 50)),
                
                  ),
                ),
                          
                
              if (loadState == LoadState.complete)
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(riskIndex,
                style: TextStyle(fontSize: 20)),
                  ),
                ),
                          
                
            ],
          ),
        ),
      ),
    );
  }
}
class OutputScreen extends StatelessWidget{
  @override
  Widget build(BuildContext ccontext){
    return Scaffold(
      appBar: AppBar(
        title: Text('Wildfire Risk Result')
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(8.0),
                child:Center(
                  child:Text('The Wildfire Risk for your area',
                    style: TextStyle(fontSize:22))
                )
              ),
              if (_zipController.text == '')
                Padding(padding:  const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('(' + _latitudeController.text + '° N, ' + _longitudeController.text + '° W):' ,style: TextStyle(fontSize:22)
                    )
                  ),
                ),
              if (_latitudeController.text == '' || _longitudeController.text == '')
                Padding(padding:  const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('(' + _zipController.text + '):' ,style: TextStyle(fontSize:22)
                    )
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(risk,
                    style: TextStyle(fontSize: 60)),
                
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(riskIndex,
                style: TextStyle(fontSize: 50)),
                
                  ),
                ),
            ]
        )
      )
    );
  }
}
