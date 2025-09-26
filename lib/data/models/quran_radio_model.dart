import 'package:equatable/equatable.dart';

class QuranRadioModel extends Equatable {
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

  @override
  List<Object?> get props => [radios];
}

class RadioChannel extends Equatable {
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

  @override
  List<Object?> get props => [id, name, url];

  @override
  String toString() {
    return "{$id,$name,$url}";
  }
}
