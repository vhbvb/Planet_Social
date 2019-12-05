class BarItems{

  static explore() => BarItem("探索", "assets/图标1a.png", "assets/图标1b.png", 0);
  static planet() => BarItem("星球", "assets/图标2a.png", "assets/图标2b.png", 1);
  static message() => BarItem("消息", "assets/图标3a.png", "assets/图标3b.png", 2);
  static mine() => BarItem("我", "assets/图标3a.png", "assets/图标3b.png", 3);

  static List<BarItem> items() => [explore(),planet(),message(),mine()];
}

class BarItem
{
  final String title;
  final String selectedImage;
  final String defaultImage;
  final int index;

  BarItem(this.title, this.selectedImage, this.defaultImage, this.index);
}