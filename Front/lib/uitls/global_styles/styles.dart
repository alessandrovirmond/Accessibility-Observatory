import 'package:flutter/material.dart';
import '../global_styles/pallete_color.dart';

class MyStyles {
  //Margem da Página
  static const EdgeInsets margin = EdgeInsets.only(
    top: 20,
    left: 20,
    right: 20,
    bottom: 20,
  );

  //Margem da Lista Selects Report
  static const EdgeInsets marginSmall = EdgeInsets.only(
    top: 10,
    left: 10,
    right: 10,
    bottom: 10,
  );

  //Card da Grid Home
  static final BoxDecoration card = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );

  static final BoxDecoration cardTema = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: PalleteColor.red, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );

  static final BoxDecoration cardBlueTema = BoxDecoration(
    color: PalleteColor.blue,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );


  static final BoxDecoration cardred = BoxDecoration(
    color: PalleteColor.red,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: PalleteColor.red,
          offset: Offset(1.0, 0.5),
          blurRadius: 6.0),
    ],
  );

  static final BoxDecoration cardGrey = BoxDecoration(
    color: const Color.fromARGB(255, 231, 230, 230),
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Color.fromARGB(255, 231, 230, 230),
          offset: Offset(1.0, 0.5),
          blurRadius: 6.0),
    ],
  );
  static final BoxDecoration cardRed = BoxDecoration(
    color: PalleteColor.red,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );


  static final BoxDecoration cardWhite = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );

  static final BoxDecoration cardRedShadow = BoxDecoration(
    color: PalleteColor.red,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );

  static final BoxDecoration cardSelecter = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: PalleteColor.red, offset: Offset(1.0, 0.5), blurRadius: 20.0),
    ],
  );
  static final BoxDecoration cardTrasparent = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );
  static final BoxDecoration cardBlue = BoxDecoration(
    color: PalleteColor.blue,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, offset: Offset(1.0, 0.5), blurRadius: 6.0),
    ],
  );

  static BoxDecoration darkCard = BoxDecoration(
    color: Colors.white60,
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: Colors.black26.withOpacity(0.07),
          offset: const Offset(1.0, 0.5),
          blurRadius: 6.0),
    ],
  );

  ///todo TextStyles
  static TextStyle subtitleList = const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: PalleteColor.blue);
  static TextStyle titleGrid =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static TextStyle titleGridTema = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: PalleteColor.red);
  static TextStyle titleGridTemaEscuro = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red.shade800);
  static BoxDecoration boxItemList = BoxDecoration(
    color: Colors.grey.withOpacity(.03),
    border: Border.all(
        color: PalleteColor.blue,
        width: 1.57),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
  );

  static TextStyle titleGridSmall =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 17);
  static TextStyle titleGridWhite = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:12,
      color: Color.fromRGBO(255, 255, 255, 1));
  static TextStyle subtitleGridBlack = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:12,
      color: Colors.black);
  static TextStyle subtitleGrid =
      const TextStyle(fontWeight: FontWeight.w100, fontSize: 18);
  static TextStyle subtitleGridWhite = const TextStyle(
      fontWeight: FontWeight.w100, fontSize: 18, color: Colors.white);
  static TextStyle subsubtitleGrid =
      const TextStyle(color: Color.fromARGB(255, 132, 132, 132), fontSize: 15);
  static TextStyle subBoldBlue = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue);
  static TextStyle subBoldBlackBigOption = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black);
  static TextStyle subBoldBlack = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
  static TextStyle subBoldBlueLight = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: PalleteColor.red);
  static TextStyle ssubBoldBlueLight =
      const TextStyle(fontSize: 12, color: PalleteColor.blue);
  static TextStyle subBoldBlackOption = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
  static TextStyle subBoldWhiteOption = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
  static TextStyle subBoldwhite = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
  static TextStyle subBoldRed = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
  static TextStyle titleGridRed = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20, color: PalleteColor.red);
  static TextStyle titleGridBlack = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black);
}
