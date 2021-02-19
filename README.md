# stock_management

A stock management Flutter application.

## Introduction

This project (school project) contains an applcation that manage products in a local SQLite Database, where you can both see add and subtract(buy) products from database, wich I will be explaining in this document, the application also retrieve data from a public API (trefle.io) wich contains all the info on different plants(if you are a fan of plants or want to make an application on plants I highly recomend visiting the website), in this project I only took the commun name of the plants and the image, And also when the app first load it only search through the first page of the data and with the possibiliy to load more with lazy loding(more on that later).

## II- Class Diagram

## III- Screens

### Home Page:

The Home page consist of the topBar of course containing a button that still doesn't have a functionality,a search bar and two Rows and their labels and finally a custom bottom Navbar that can take you to HomePage by clicking on the little star shape, and to the page that allow us to add products by clicking on the 3 dots,and for the Rows the first Row as its label said contain products retrieved from the SQLite database, the images are images from URLs so we need to make sure that we are conected to the internet for them to show up, I didn't choose to copy the images to the phone and used it as server because that to me is not a realistic solution since it will affect the performance highly,especially if we got a lot of products to mange, therefore I only stored the image URL and access it when needed.We retrieve the data from SQLite database using a simple function wich returns a futur cotaining a list of Products:
      
      getAll() async{
      var database=await openDatabase('stock_management.db');
      var records= await database.query("Product");

      List<Product> list =
      records.isNotEmpty ? records.map((c) => Product.fromMap(c)).toList() : [];
      return list;
    }


And for the second Row with the labels Save the planet,it contains the Plants that we reretrieved from the trefle API as stated in the Introduction, the app only retrieve the first page of the product onLoad u can see it as we call the function getSavePlanetData with pageNumber equal to one, and we can change the page number to load more during the lazyLoading so the app won't crash. 
    
       getSavePlanetData(int pageNumber,int pageSize) async {

        final url = "${BASE_URL}?token=$API_KEY&page=$pageNumber&size=$pageSize";
        List<Plant> list;

        try {

        var response = await  http.get(url);
        if (response.statusCode == HttpStatus.ok) {
          var data = json.decode(response.body);

          var rest = data["data"] as List;

          list = rest.map<Plant>((json) => Plant.fromJson(json)).toList();
          return list;

        } else {
          print("Failed http call."); // Perhaps handle it somehow
        }
      } catch (exception) {
        print(exception.toString());
      }
      return null;

     }
    
The function will return a future containing the data in list of our Model Plant, or it will return a null in case it couln't access the API, (the base_url,is the url used, wich is declared separately, the API_KEY contain the key that trefle.io gives you once you are a member of the website).

The Model:

       class Plant {
        int id;
        String name;
        String image;


        Plant({
          this.id,
          this.name ,
          this.image
        });


Both Rows use a FutureBuilder to display the data,the futureBuilder use getSavePlanetData function as future and I tried to take all state into consideration(like if the data still looading, no data,no connection...). and finally I display the results in a list of Customised Widget (FeaturePlantCard), and the same goes for the first row the only different between the two is that we use a different function as future of course and a different customised Widger.

           FutureBuilder(
             future: (new ManagementDao()).getSavePlanetData(1, 1),
              // ignore: missing_return
              builder: (BuildContext coontext,AsyncSnapshot snapshot){
              var data = snapshot.data;
              switch (snapshot.connectionState) {
              case ConnectionState.none:
              return new Text('Input a URL to start');
              case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
              case ConnectionState.active:
              return new Text('');
              case ConnectionState.done:
              if (snapshot.hasError) {
              return new Text(
              'no connection to the internet',
              style: TextStyle(color: Colors.red),
              );
              } else {
                List<Widget> plantList = new List<Widget>();
                for(var plant in data){
                  plantList.add(
                      FeaturePlantCard(
                      image: plant.image,
                      press: () {
                        showAlertDialog(context,plant.name);
                      },
                    ),
                  );
                }

            return new Row(children: plantList);
    }
    }
             }
            ),//*//

![Screenshot 2021-02-19 at 12 44 22 AM](https://user-images.githubusercontent.com/58625156/108436150-d1e84400-7242-11eb-9b91-20cb7d46b1a7.png)

And finally concernig the home page we can see the products details page once we click on the product, and for the Plants we can see their name by clicking on the image and a popup will show containing the commun name of the products. 


<img width="390" alt="Screenshot 2021-02-19 at 1 30 05 AM" src="https://user-images.githubusercontent.com/58625156/108439441-2d1d3500-7249-11eb-8e7e-a62ad2ab53c1.png">


NB:Check trefle.io for more info

### Detail Page:

The detail page contain the product info with a buy button, once we clicked on the product that we want i the HomePage, we send the id of that product to our detail page and retreive the necessary data from the SQLite database, using a function that I called getProduct,the function take the id of the product as a parameter and return a Future containing the product that we want. 

    Future<Product> getProduct(int id) async {
      var database=await openDatabase('stock_management.db');
      List<Map> results = await database.query("Product",
          columns: ["id", "name", "price","quantity", "image"],
          where: 'id = ?',
          whereArgs: [id]);

      if (results.length > 0) {
      print(results);
        return new Product.fromMap(results.first);
      }


    return null;
    }

We use as in the HomePage a Future builder to retrive the Future and use it, once it is ready. 
On the page under the image and the icon we can see the different information that we retrieved, and a buy button wich will be the button that subtract products from the database, once we click on the button a warning will show up telling the user if he is sure that he want continue, and once we click on confirm we call a function that will update the table on the databse and reduce the quantity of the product and redirect us to the HomePage showing a toast message confirming the validation.:

    Future<int> updatePQty(int id) async {
      var database=await openDatabase('stock_management.db');
      return await database.rawUpdate(
          'UPDATE Product SET quantity = quantity-1 WHERE id = $id'
      );
    }
    
 ![Screenshot 2021-02-19 at 1 52 24 AM](https://user-images.githubusercontent.com/58625156/108441094-5095af00-724c-11eb-9a4a-4eb40ea54d28.png)
 

### Add Product Page:

The add Product Page(as we said we can access it by clicking on the 3 dots on the bottom Navbar in HomePage) is a simple Form with some styling and some of course restriction like all the inputs souldn't be empty except for the Note, the amount and quantity could not be smaller than 1 wich is ovious we don't want to enter a 0 product to our database, this is an example of a formInput that contains different info like name, the validator that we ser, labelText...etc :

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

 If we tried to validate the form without respecting the restriction error messages shows(we can specify the error message as in the previous we used Ammount cannot be empty ...etc), and once we use all correct information the app redirect the user to the Homepage and we see the product that we added in the HomePage and verify the details on the detail page.
 
 ![Screenshot 2021-02-19 at 2 24 56 AM](https://user-images.githubusercontent.com/58625156/108443523-d9164e80-7250-11eb-9962-e69c5819d0d6.png)
 
 As we can see once we confirm the insertion with valid data the app redirect us to the homePage and we can swipe to see if the product is added and also see and verify its details(price, name, quantity and of course the image that we can verify it together with the name in the homepage)
 
 PS: Feel free to use the application
 PS2: I have left all the possible SQLite methodes inside the managementDAO but it is all in comments.
 PS3: Thanks Yash Moon and LutterWay for showing some of this design on their channels. 
 
 
 
