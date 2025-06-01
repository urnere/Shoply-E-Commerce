class urunler {
  final int? id;
  final String? ad;
  final String? resim;
  final String? kategori;
  final int? fiyat;
  final String? marka;

  urunler({
    this.id,
    this.ad,
    this.resim,
    this.kategori,
    this.fiyat,
    this.marka,
  });

  factory urunler.fromJson(Map<String, dynamic> json) => urunler(
    id: json["id"],
    ad: json["ad"],
    resim: json["resim"],
    kategori: json["kategori"],
    fiyat: json["fiyat"],
    marka: json["marka"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ad": ad,
    "resim": resim,
    "kategori": kategori,
    "fiyat": fiyat,
    "marka": marka,
  };
}