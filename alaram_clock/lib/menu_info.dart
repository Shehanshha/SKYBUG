import 'package:alaram_clock/enum.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class Menuinfo extends ChangeNotifier{
  MenuType menuType;
  late  String titile;
  late String imageSource;

  Menuinfo(this.menuType,{this.titile='', this.imageSource=''});
  updateMenu(Menuinfo menuinfo){
    if (this.titile.isEmpty) {
      this.titile = menuinfo.titile;
    }
    this.menuType = menuinfo.menuType;
    this.titile = menuinfo.titile;
    this.imageSource = menuinfo.imageSource;

    notifyListeners();
  }
}