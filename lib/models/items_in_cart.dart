// ignore_for_file: camel_case_types

class urunler_sepeti {
  final int? sepetId;
  String? ad;
  String? resim;
  String? kategori;
  int? fiyat;
  String? marka;
  String? kullaniciAdi;
  int? siparisAdet;

  urunler_sepeti({
    this.sepetId,
    this.ad,
    this.resim,
    this.kategori,
    this.fiyat,
    this.marka,
    this.kullaniciAdi,
    this.siparisAdet,
  });

  factory urunler_sepeti.fromJson(Map<String, dynamic> json) {
    return urunler_sepeti(
      sepetId: json['sepetId'] != null ? int.parse(json['sepetId'].toString()) : null,
      ad: json['ad'],
      resim: json['resim'],
      kategori: json['kategori'],
      fiyat: json['fiyat'] != null ? int.parse(json['fiyat'].toString()) : null,
      marka: json['marka'],
      kullaniciAdi: json['kullaniciAdi'],
      siparisAdet: json['siparisAdeti'] != null ? int.parse(json['siparisAdeti'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sepet_id": sepetId,
      "ad": ad,
      "resim": resim,
      "kategori": kategori,
      "fiyat": fiyat,
      "marka": marka,
      "kullanici_adi": kullaniciAdi,
      "siparis_adet": siparisAdet,
    };
  }
}
