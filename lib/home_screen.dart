import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final List<Uint8List> _savedImages = [];
final List<Uint8List> _capturedImages = [];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Gallery ',style: TextStyle(color: Colors.white),)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 200 ,
              height: 200 ,
               
              decoration: BoxDecoration(
                color: Colors.grey, 
                image:  _capturedImages.isNotEmpty
                    ? DecorationImage(
                        image: MemoryImage( _capturedImages.last),
                        fit: BoxFit.cover,
                      )
                    :  _savedImages.isNotEmpty
                        ? DecorationImage(
                            image: MemoryImage(_savedImages.last),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage('assets/images/preview.png'),
                            fit: BoxFit.cover,
                          ),
                    
              ),       
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                
                children: [
                  GestureDetector(       
                    onTap: () {                        
                      select_image();
                    },
        
                    child: const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  Icon(Icons.camera_alt,color: Colors.blue,size: 50 ,),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: (){
                        saveAndDisplayGrid();
                                                                                                
                      }, child: const Text('SAVE',style: TextStyle(color: Colors.white),)),
                    )
                ],
              ),
            ),
        
            if (_savedImages.isNotEmpty)
            Expanded(
              child: GridView.builder(
              
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                
                ),
                itemCount: _savedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 20 ,
                    height: 20 ,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: MemoryImage(_savedImages[index]),                         
                        fit: BoxFit.cover,),
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


void select_image()async{
    Uint8List img= await pick_image(ImageSource.camera);
    if(img!=null){
      setState(() {
       _capturedImages.add(img);
       
      });
    }
  }
  
Future<void> saveDataToFile(Uint8List data) async {

  Directory directory = await getApplicationDocumentsDirectory();

    // Specify the folder name
    String folderPath = '${directory.path}/newfolder';
    Directory(folderPath).createSync(recursive: true);

     // Append a timestamp to the file name
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath = '$folderPath/example_$timestamp.png';

    // Write data to the file
    File file = File(filePath);
    await file.writeAsBytes(data);

    print('Data saved to: $filePath');

  
}

 Future<void> saveAndDisplayGrid() async {
   if (_capturedImages.isNotEmpty) {
      await saveDataToFile(_capturedImages.last);
      setState(() {
        _savedImages.add(_capturedImages.last);
        _capturedImages.clear(); // Clear captured images after saving
      });
    } else {
      print('No image to save.');
    }
  }




   pick_image(ImageSource source)async {
   final ImagePicker imagePicker=ImagePicker();
   XFile? _file=await imagePicker.pickImage(source: source);
   if(_file!=null){
    return await _file.readAsBytes();
   }
   else{ 
    print('no images');
    return null;
   }
  } 

  

}