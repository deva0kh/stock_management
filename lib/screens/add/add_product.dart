import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_managements/management_dao.dart';
import 'package:stock_managements/screens/home/home_screen.dart';


class AddProduct extends StatefulWidget {
@override
_AddProductState createState() => _AddProductState();
}
class _AddProductState extends State<AddProduct> {


  double _amount;
  String _url;
  String _name;
  int _quantity;
  String _note;
  bool _supSolde =false;
  int _value = 1;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 40),
                      child: Text(
                        'Add Product',
                        style: TextStyle(
                          fontFamily: 'Cardo',
                          fontSize: 35,
                          color: Color(0xff0C2551),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      //
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, top: 5),
                      child: Text(
                        'Add the product info',
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  //
                  SizedBox(
                    height: 30,
                  ),
                Container(
                    padding: EdgeInsets.only(left: 30,right: 40),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.only(right:88.0),
                            child: TextFormField(

                              validator: (String value){
                                if (value.isEmpty){
                                  return 'Name cannot be empty';
                                }
                                _name=value;
                                return null;
                              },
                              style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                labelText: 'Name :',
                                hintText: 'eg: Achraf Khallouk',
                                counterText: 'Name of the Product',
                              ),
                            ),
                          ),

                          TextFormField(

                            validator: (String value){
                              if (value.isEmpty){
                                return 'Image URL cannot be empty';
                              }else if(value.length<11){
                                return 'Please enter a valid URL';
                              }
                              print(value);
                              _url=value;
                              return null;
                            },

                            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              labelText: 'Image URL :',
                              hintText: 'URL',
                              counterText: 'Please enter a valid URL',


                            ),

                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DropdownButton(

                                  value: _value,
                                  items: [
                                    DropdownMenuItem(
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset('assets/svg/morocco.svg',height: 15,width: 15,),
                                          Text("MAD"),
                                        ],
                                      ),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text("soon .."),
                                      value: 2,
                                    ),

                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  }),
                              Container(width: 15, color: Colors.transparent),
                              new  Flexible(
                                child: TextFormField(

                                  validator: (String value) {

                                    if (value.isEmpty){
                                      return 'Ammount cannot be empty';
                                    }else if( double.parse(value)<1){

                                      return 'error';
                                    }
                                    _amount=double.parse(value);
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    labelText: 'Amount :',
                                    hintText: 'eg: 3000 DH',
                                    suffixText: ' DH',

                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(

                            validator: (String value){
                              if (value.isEmpty){
                                return 'Quantity cannot be empty';
                              }
                              _quantity=int.parse(value);
                              return null;
                            },
                            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              labelText: 'Quantity :',
                              hintText: 'eg: 10',
                              counterText: '.',
                            ),
                          ),
                          TextFormField(
                            maxLength: 30,
                            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                            decoration: InputDecoration(

                                labelText: 'Note :',
                                hintText: 'Create a note for this payment',
                                counterStyle: TextStyle(height: double.minPositive,),
                                counterText: ""

                            ),
                          ),


                        ],
                      ),
                    )
                ),




                  SizedBox(
                    height: 30,
                  ),
                  //
                  Padding(
                   padding: EdgeInsets.only(left: 200),
                    child:
                    FloatingActionButton(

                      onPressed: () async {
                        _supSolde=false;
                        if(_formkey.currentState.validate()){
                         (new ManagementDao().insert(_name, _amount, _url, _quantity));

                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => HomeScreen(),
                           ),
                         );

                        }


                      },

                      child:  Icon(Icons.done),

                    ),
                  ),


                ],
              ),

              ClipPath(
                clipper: OuterClippedPart(),
                child: Container(
                  color: Color(0xff0c2551),
                  width: scrWidth*2,
                  height: scrHeight*1.4,
                ),
              ),
              //
              ClipPath(
                clipper: InnerClippedPart(),
                child: Container(
                  color: Color(0xff0962ff),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class OuterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    //
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    //
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);

    //
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
