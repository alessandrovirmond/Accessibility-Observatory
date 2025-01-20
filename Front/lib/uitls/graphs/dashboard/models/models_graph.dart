


class ModelGraph{

  final String name;
  final double value;


  ModelGraph(this.name, this.value);




  Map<String,double> toMap(){
    return {name:value};
  }


  


}