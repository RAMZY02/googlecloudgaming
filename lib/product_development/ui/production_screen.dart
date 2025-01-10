import 'package:flutter/material.dart';
import 'package:steppa/product_development/controllers/design_controller.dart';
import 'package:steppa/product_development/controllers/material_controller.dart';
import 'package:steppa/product_development/controllers/production_controller.dart';
import 'package:steppa/product_development/ui/design_lists_screen.dart';
import 'package:steppa/product_development/ui/materials_storage_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/production_progress_screen.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({Key? key}) : super(key: key);

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  List<dynamic> availableDesigns = [];
  List<dynamic> selectedDesignData = [];
  List<dynamic> selectedMaterialData = [];
  final DesignController _designController = DesignController();
  final MaterialController _materialController = MaterialController();
  final ProductionController _productionController = ProductionController();

  final List<int> shoeSizes = [40, 41, 42, 43, 44, 45];

  String? selectedDesign;
  int? selectedSize;
  int quantity = 1;
  Map<String, int> materialsPerShoe = {};

  Map<String, String> calculateMaterials() {
    return materialsPerShoe.map((material, amount) {
      final total = amount;
      return MapEntry(material, "$total pcs");
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllAcceptedDesigns();
  }

  Future<void> _fetchAllAcceptedDesigns() async {
    try {
      final resData = await _designController.fetchAllAcceptedDesigns();
      setState(() {
        availableDesigns = resData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch accepted designs: $e')),
      );
    }
  }

  Future<void> _fetchSelectedDesigns(int id) async {
    try {
      final resDesign = await _designController.fetchSelectedDesigns(id);
      final resMats = await _materialController.fetchSelectedDesignMaterials(id);
      setState(() {
        selectedDesignData = resDesign;
        selectedMaterialData = resMats;

        if(selectedMaterialData.length == 3){
          addMaterial(selectedMaterialData[0].name, selectedMaterialData[0].id == "MAT0001" || selectedMaterialData[0].id == "MAT0002" ? quantity * 1 : quantity * 4);
          addMaterial(selectedMaterialData[1].name, selectedMaterialData[1].id == "MAT0001" || selectedMaterialData[1].id == "MAT0002" ? quantity * 1 : quantity * 4);
          addMaterial(selectedMaterialData[2].name, selectedMaterialData[2].id == "MAT0001" || selectedMaterialData[2].id == "MAT0002" ? quantity * 1 : quantity * 4);
        }
        else if(selectedMaterialData.length == 4){
          addMaterial(selectedMaterialData[0].name, selectedMaterialData[0].id == "MAT0001" || selectedMaterialData[0].id == "MAT0002" ? quantity * 1 : quantity * 2);
          addMaterial(selectedMaterialData[1].name, selectedMaterialData[1].id == "MAT0001" || selectedMaterialData[1].id == "MAT0002" ? quantity * 1 : quantity * 2);
          addMaterial(selectedMaterialData[2].name, selectedMaterialData[2].id == "MAT0001" || selectedMaterialData[2].id == "MAT0002" ? quantity * 1 : quantity * 2);
          addMaterial(selectedMaterialData[3].name, selectedMaterialData[3].id == "MAT0001" || selectedMaterialData[3].id == "MAT0002" ? quantity * 1 : quantity * 2);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch accepted designs: $e')),
      );
    }
  }

  void addMaterial(String materialName, int count) {
    if (materialsPerShoe.containsKey(materialName)) {
      // Jika sudah ada, update jumlahnya
      materialsPerShoe[materialName] = materialsPerShoe[materialName]! + count;
    } else {
      // Jika belum ada, tambah material baru dengan nilai count
      materialsPerShoe[materialName] = count;
    }
  }

  @override
  Widget build(BuildContext context) {
    final calculatedMaterials = calculateMaterials();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Production Planner"),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Product Research & Development',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Design Workspace'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductDevelopmentScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending),
              title: const Text('Pending Designs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PendingDesignsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Design Lists'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DesignListsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.factory),
              title: const Text('Production Planner'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductionScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text('Production Progress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductionProgressScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Raw Materials Storage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaterialsStorageScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Back To Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose The Design",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedDesign,
              hint: const Text("Select a design"),
              isExpanded: true,
              items: availableDesigns
                  .map((design) => DropdownMenuItem(
                value: design.id.toString(),
                child: Text(design.name),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDesign = value;
                  materialsPerShoe.clear();
                  int selectedid = int.parse(value!);
                  _fetchSelectedDesigns(selectedid);
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              "Select Shoe Size",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: selectedSize,
              hint: const Text("Select a size"),
              isExpanded: true,
              items: shoeSizes.map((size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text(size.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSize = value;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              "Set Quantity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: quantity > 1
                      ? () {
                    setState(() {
                      quantity--;
                      if(selectedMaterialData.length == 3){
                        addMaterial(selectedMaterialData[0].name, selectedMaterialData[0].id == "MAT0001" || selectedMaterialData[0].id == "MAT0002" ? -1 : -4);
                        addMaterial(selectedMaterialData[1].name, selectedMaterialData[1].id == "MAT0001" || selectedMaterialData[1].id == "MAT0002" ? -1 : -4);
                        addMaterial(selectedMaterialData[2].name, selectedMaterialData[2].id == "MAT0001" || selectedMaterialData[2].id == "MAT0002" ? -1 : -4);
                      }
                      else if(selectedMaterialData.length == 4){
                        addMaterial(selectedMaterialData[0].name, selectedMaterialData[0].id == "MAT0001" || selectedMaterialData[0].id == "MAT0002" ? -1 : -2);
                        addMaterial(selectedMaterialData[1].name, selectedMaterialData[1].id == "MAT0001" || selectedMaterialData[1].id == "MAT0002" ? -1 : -2);
                        addMaterial(selectedMaterialData[2].name, selectedMaterialData[2].id == "MAT0001" || selectedMaterialData[2].id == "MAT0002" ? -1 : -2);
                        addMaterial(selectedMaterialData[3].name, selectedMaterialData[3].id == "MAT0001" || selectedMaterialData[3].id == "MAT0002" ? -1 : -2);
                      }
                    });
                  }
                      : null,
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () {
                    setState(() {
                      quantity++;
                      if(selectedMaterialData.length == 3){
                        addMaterial(selectedMaterialData[0].name, selectedMaterialData[0].id == "MAT0001" || selectedMaterialData[0].id == "MAT0002" ? 1 : 4);
                        addMaterial(selectedMaterialData[1].name, selectedMaterialData[1].id == "MAT0001" || selectedMaterialData[1].id == "MAT0002" ? 1 : 4);
                        addMaterial(selectedMaterialData[2].name, selectedMaterialData[2].id == "MAT0001" || selectedMaterialData[2].id == "MAT0002" ? 1 : 4);
                      }
                      else if(selectedMaterialData.length == 4){
                        addMaterial(selectedMaterialData[0].name, selectedMaterialData[0].id == "MAT0001" || selectedMaterialData[0].id == "MAT0002" ? 1 : 2);
                        addMaterial(selectedMaterialData[1].name, selectedMaterialData[1].id == "MAT0001" || selectedMaterialData[1].id == "MAT0002" ? 1 : 2);
                        addMaterial(selectedMaterialData[2].name, selectedMaterialData[2].id == "MAT0001" || selectedMaterialData[2].id == "MAT0002" ? 1 : 2);
                        addMaterial(selectedMaterialData[3].name, selectedMaterialData[3].id == "MAT0001" || selectedMaterialData[3].id == "MAT0002" ? 1 : 2);
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Materials Needed:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...calculatedMaterials.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("- ${entry.key}: ${entry.value}"),
              );
            }).toList(),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDesign = null;
                        selectedSize = null;
                        selectedDesignData.clear();
                        selectedMaterialData.clear();
                        materialsPerShoe.clear();
                        quantity = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: selectedDesign != null && selectedSize != null ?
                        () async {
                        try {
                          bool enoughMats = true;
                          for(int i = 0; i < selectedMaterialData.length; i++){
                            String neededmats = selectedMaterialData[i].name;
                            if(selectedMaterialData[i].stok_qty < materialsPerShoe[neededmats]!){
                              enoughMats = false;
                              break;
                            }
                          }

                          if(enoughMats) {
                            await _productionController.submitProduction(
                              designId: selectedDesignData[0].id,
                              expectedQty: quantity,
                              status: "Ongoing",
                              productionSize: selectedSize.toString(),
                            );

                            for(int i = 0; i < selectedMaterialData.length; i++){
                              String neededmats = selectedMaterialData[i].name;
                              await _materialController.updateMaterial(selectedMaterialData[i].id, materialsPerShoe[neededmats]!);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'Production Plan Uploaded Successfully!')),
                            );

                            // Reset form setelah berhasil submit
                            setState(() {
                              selectedDesign = null;
                              selectedSize = null;
                              selectedDesignData.clear();
                              selectedMaterialData.clear();
                              materialsPerShoe.clear();
                              quantity = 1;
                            });
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'Some Materials Are Not Enough!')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to upload production plan: $e')),
                          );
                        }
                      }
                    : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
