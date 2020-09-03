class Vente {

  int id;
  String date_vente;
  String nom_produit;
  String prix_produit;
  String type_paiement;
  String acheteur;

  @override
  String toString() {
    return "$id;$date_vente;$nom_produit;$prix_produit;$type_paiement;$acheteur;";
  }

  Vente({this.id, this.date_vente, this.nom_produit, this.prix_produit, this.type_paiement, this.acheteur});

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "date_vente": date_vente,
      "nom_produit": nom_produit,
      "prix_produit": prix_produit,
      "type_paiement" : type_paiement,
      "acheteur" : acheteur,
    };
  }

  Vente.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        date_vente = json["date_vente"],
        nom_produit = json["nom_produit"],
        prix_produit = json["prix_produit"],
        type_paiement = json["type_paiement"],
        acheteur = json["acheteur"];

  Vente.fromMap(Map<String, dynamic> map) {
    id = map[id];
    date_vente = map[date_vente];
    nom_produit = map[nom_produit];
    prix_produit = map[prix_produit];
    type_paiement = map[type_paiement];
    acheteur = map[acheteur];
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "date_vente": date_vente,
        "nom_produit": nom_produit,
        "prix_produit": prix_produit,
        "type_paiement" : type_paiement,
        "acheteur" : acheteur,
      };

}