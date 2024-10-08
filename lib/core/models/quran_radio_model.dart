class QuranRadioModel {
  List<RadioChannel>? radios;

  QuranRadioModel({
    this.radios,
  });

  QuranRadioModel.fromJson(dynamic json) {
    if (json['radios'] != null) {
      radios = [];
      json['radios'].forEach((v) {
        radios?.add(RadioChannel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (radios != null) {
      map['radios'] = radios?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RadioChannel {
  num? id;
  String? name;
  String? url;

  RadioChannel({
    this.id,
    this.name,
    this.url,
  });

  RadioChannel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['url'] = url;
    return map;
  }
}
