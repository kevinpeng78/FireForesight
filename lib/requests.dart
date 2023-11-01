import 'dart:convert';

import 'package:http/http.dart' as http;

getRiskCoord(lat, long)async{
  http.Response call = await http.get(Uri.parse('https://kevinpeng345.pythonanywhere.com/calculate?latitude=' + lat + '&longitude=-' + long));
  var output = jsonDecode(call.body);
  return output['output'].toString();
}

getRiskZip(zip)async{
  http.Response call = await http.get(Uri.parse('https://kevinpeng345.pythonanywhere.com/calculatezip?zip=' + zip));
  var output = jsonDecode(call.body);
  return output['output'].toString();
}