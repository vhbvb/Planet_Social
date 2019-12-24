class BarItems{

  static final explore = BarItem("探索", "assets/1a.png", "assets/1b.png", 0);
  static final planet = BarItem("星球", "assets/2a.png", "assets/2b.png", 1);
  static final message = BarItem("消息", "assets/4a.png", "assets/4b.png", 2);
  static final mine = BarItem("我", "assets/3a.png", "assets/3b.png", 3);

  static List<BarItem> items() => [explore,planet,message,mine];
}

class BarItem
{
  final String title;
  final String selectedImage;
  final String defaultImage;
  final int index;

  BarItem(this.title, this.selectedImage, this.defaultImage, this.index);
}