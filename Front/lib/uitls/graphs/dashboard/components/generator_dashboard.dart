import 'package:accessibility_audit/library/pluto_grid/src/helper/filtered_list.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/components/graphs.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/controller/generator_file/pdf_generator.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/models/enum_graph_style.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/models/model_selector_graph.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/models/models_graph.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GeneratorDashboard extends StatefulWidget {
  final List<String> collumns;
  final FilteredList<PlutoRow> row;
  final List<String> collumnsNumber;
  const GeneratorDashboard(
      {super.key,
      required this.collumns,
      required this.row,
      required this.collumnsNumber});



  @override
  State<GeneratorDashboard> createState() => _GeneratorDashboardState();
}

  final RenderPdf pdf = RenderPdf();
  // ignore: unused_element
  late GlobalKey<SfCircularChartState> _circularChartKey;

TextEditingController controllerA = TextEditingController();
TextEditingController controllerB = TextEditingController();
TextEditingController controllerType = TextEditingController();
bool generator = false;
List<ModelGraph> model = [];
int total = 0;

late bool noNumber;


class _GeneratorDashboardState extends State<GeneratorDashboard> {

    List<TextEditingController> txt = [
      controllerA,
      controllerB,
      controllerType
    ];
  
  
void buildGraph(){
 
  if (controllerType.text == "Soma") {
  if (controllerA.text != controllerB.text) {
    List<String> a = [];
    List<int> b = [];
    bool isColumnValid = true;

    // Verifica se todos os valores da coluna B são inteiros
    for (var element in widget.row) {
      var cellValue = element.cells[controllerB.text]!.value;
      if (cellValue is! int) {
        
        isColumnValid = false;
        break; // Sai do loop, pois a coluna não é válida
      }
    }

    if (isColumnValid) {
      for (var element in widget.row) {
        a.add(element.cells[controllerA.text]!.value.toString());
        b.add(element.cells[controllerB.text]!.value);
      }

      Map<String, int> mapa = {};
      for (int i = 0; i < a.length; i++) {
        if (mapa.containsKey(a[i])) {
          mapa[a[i]] = mapa[a[i]]! + b[i];
        } else {
          mapa[a[i]] = b[i];
        }
      }

      model.clear();
      total = 0;
      mapa.forEach((key, value) {
        model.add(ModelGraph(key, value.toDouble())); // Converte para double ao criar o modelo
        total += value;
      });
    } else {
      // Exibe um erro ou executa outra lógica se a coluna não for válida
      debugPrint("A coluna selecionada contém valores não inteiros e foi ignorada.");
    }
  }
}

         
          else {
            
          Map<String, double> map = {};
          total = 0;
          for (var element in widget.row) {
            total += 1;
            if (map.containsKey(
                element.cells[controllerA.text]!.value.toString())) {
              map[element.cells[controllerA.text]!.value.toString()] =
                  map[element.cells[controllerA.text]!.value.toString()]! + 1;
            } else {
              map.addAll(
                  {element.cells[controllerA.text]!.value.toString(): 1});
            }
          }
          model.clear();
          map.forEach((key, value) {
            model.add(ModelGraph(key, value));
          });
        }
         setState(() {
         
          generator = true;
        });
}

@override
void initState() {
  super.initState();
  
  _circularChartKey = GlobalKey();

  // Filtra as colunas para remover aquelas com mais de 500 valores distintos
  widget.collumns.removeWhere((collum) {
    // Verifica se a coluna não é "EPC" ou vazia, e se tem mais de 500 valores distintos
    return collum.isEmpty || 
           widget.row.map((row) => row.cells[collum]!.value).toSet().length > 1000;
  });

   // Filtra as colunas numéricas para garantir que só contenham valores inteiros
  widget.collumnsNumber.removeWhere((collum) {
    for (var element in widget.row) {
      if (element.cells[collum]!.value is! int) {
        return true; // Remove a coluna se algum valor não for inteiro
      }
    }
    return false; // Mantém a coluna se todos os valores forem inteiros
  });

  controllerA.text = widget.collumns[0];
  controllerType.text = "Quantitativo";
  noNumber = widget.collumnsNumber.isEmpty;

  controllerB.text = noNumber ? controllerA.text : widget.collumnsNumber[0];

  buildGraph();

  for (var element in txt) {
    element.addListener(() {
      buildGraph();

      setState(() {
        generator = true;
      });
    });
  }
}


 @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Coluna",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 150,
                          child: DropdownSearch<String>(
                            popupProps:
                                const PopupProps.menu(showSearchBox: false),
                            items: widget.collumns,
                            onChanged: (value) => controllerA.text = value!,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Selecione a coluna",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: PalleteColor.red.withOpacity(.7),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            selectedItem: controllerA.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Tipo",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 150,
                          child: DropdownSearch<String>(
                            popupProps:
                                const PopupProps.menu(showSearchBox: false),
                            items: const ["Quantitativo", "Soma"],
                            onChanged: (value) => controllerType.text = value!,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Selecione o tipo",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: PalleteColor.red.withOpacity(.7),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            selectedItem: controllerType.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    if (controllerType.text == "Soma" && !noNumber)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "  Coluna numérica",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 150,
                            child: DropdownSearch<String>(
                              popupProps:
                                  const PopupProps.menu(showSearchBox: false),
                              items: widget.collumnsNumber,
                              onChanged: (value) => controllerB.text = value!,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Coluna numérica",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PalleteColor.red.withOpacity(.7),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              selectedItem: controllerB.text,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Row(
                  children: [
                    _buildCircularIcon(
                      icon: Icons.pie_chart,
                      selected: ModelSelectorGraph.graph == GraphStyle.pie,
                      onPressed: () => setState(
                          () => ModelSelectorGraph.graph = GraphStyle.pie),
                    ),
                    const SizedBox(width: 7),
                    _buildCircularIcon(
                      icon: FeatherIcons.triangle,
                      selected: ModelSelectorGraph.graph == GraphStyle.pyramid,
                      onPressed: () => setState(
                          () => ModelSelectorGraph.graph = GraphStyle.pyramid),
                    ),
                    const SizedBox(width: 7),
                    _buildCircularIcon(
                      icon: Icons.bar_chart,
                      selected: ModelSelectorGraph.graph == GraphStyle.bar,
                      onPressed: () => setState(
                          () => ModelSelectorGraph.graph = GraphStyle.bar),
                    ),
                    const SizedBox(width: 20),
                   MouseRegion(
      cursor: SystemMouseCursors.click,
     
      child: GestureDetector(
        onTap: () {
          pdf.renderPdf(GraphSelectorWidget.dash, "");
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.filePdf,
              color:PalleteColor.red,
            ),
            const SizedBox(height: 5),
            Text(
              "Exportar",
              style: TextStyle(
                color:PalleteColor.red,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    ),
                  ],
                ),
              ],
            ),
            generator
                ? Expanded(
                    child: GraphSelectorWidget(
                      model: model,
                      t: total.toDouble(),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon({
    required IconData icon,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? PalleteColor.blue : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? PalleteColor.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: selected ? Colors.white : PalleteColor.blue),
        onPressed: onPressed,
      ),
    );
  }
}

