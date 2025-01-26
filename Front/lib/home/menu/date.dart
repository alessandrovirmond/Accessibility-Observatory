import 'package:accessibility_audit/report/repository/state_repository.dart';
import 'package:accessibility_audit/uitls/global_pages_utils/loading/global_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Date extends StatefulWidget {
  const Date({super.key});

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  final StateRepository repo = StateRepository();
  String date = "";
  bool isLoading = true;

  getDate() async {
    try {
      String fetchedDate = await repo.getDate();
      setState(() {
        print(date);
        date = formatToBrazilianDate( fetchedDate);
        isLoading = false; // Atualiza o estado para indicar que os dados foram carregados
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Mesmo que ocorra um erro, devemos parar o carregamento
      });
      print('Erro ao buscar a data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    // Mostra um indicador de carregamento enquanto a data está sendo buscada
    if (isLoading) {
      return Center(child: const GlobalPageLoading());
    }

    // Exibe a data quando ela está disponível
    return Text("Última atualização: " + date , style: TextStyle(color: Colors.white),);
  }
}

String formatToBrazilianDate(String isoDate) {
  // Converte o formato ISO 8601 para um objeto DateTime
  DateTime dateTime = DateTime.parse(isoDate);

  // Formata para o padrão brasileiro
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  return formattedDate;
}
