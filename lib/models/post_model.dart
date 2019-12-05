import 'package:planet_social/models/user_model.dart';

class Post{

  String createAt = "2019-01-01";
  User owner = User();
  String content = "Ant Design是一个服务于企业级产品的设计体系，基于『确定』和『自然』的设计价值观和模块化的解决方案，让设计者专注于更好的用户体验。";
  List images = ["http://e.hiphotos.baidu.com/image/pic/item/4610b912c8fcc3cef70d70409845d688d53f20f7.jpg",
  "http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367aa7f3cc7424738bd4b31ce525.jpg",
  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574856271208&di=8326ac61fadff1902a9d4014aca6ec80&imgtype=0&src=http%3A%2F%2Fdesk-fd.zol-img.com.cn%2Ft_s960x600c5%2Fg4%2FM04%2F04%2F03%2FCg-4WVQSY5GIXCJfAAgcMfHEIBEAARXwQHY7j8ACBxJ524.jpg"];

  String star = "经木水火土星星星";
  String starId;

  int comments = 212121;
}