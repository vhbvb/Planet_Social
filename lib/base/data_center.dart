import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/user_model.dart';

class DataSource {
  static final center = DataSource();

  final planets = [];
  final users = [];
  final posts = [];
  final exploreItems = [];

  updateExplore(Function(Map<String, dynamic>) finished) {
    ApiService.shared.getExploreItems((u, p, error) {
      if (error == null) {
        planets.clear();
        planets.addAll(p);
        users.clear();
        users.addAll(u);

        exploreItems.clear();
        exploreItems.addAll(planets);
        exploreItems.addAll(users);
        finished(null);
      } else {
        finished(error);
        // PSAlert.show(context, "星星获取失败", error.toString());
      }
    });
  }

  getUser(String uid, Function(User, Map<String, dynamic> error) result) {
    for (var item in users) {
      if (item.userId == uid) {
        result(item, null);
        return;
      }
    }

    ApiService.shared.getUser(uid, (user, error) {
      if (user != null) {
        users.add(user);
      }
      result(user, error);
    });
  }

  getPlanet(String pid, Function(Planet, Map<String, dynamic> error) callback) {
    for (var item in planets) {
      if (item.id == pid) {
        callback(item, null);
        return;
      }
    }

    ApiService.shared.getPlanet(pid, (planet, error) {
      if (planet != null) {
        planets.add(planet);
      }
      callback(planet, error);
    });
  }
}
