class Vente {

  String nom_produit;
  String prix_produit;
  String type_paiement;
  String acheteur;

  @override
  String toString() {
    return '$nom_produit;$prix_produit;$type_paiement;$acheteur;';
  }

  Vente({this.nom_produit, this.prix_produit, this.type_paiement, this.acheteur});

  Map<String, dynamic> toMap() {
    return {
      'nom_produit': nom_produit,
      'prix_produit': prix_produit,
      "type_paiement" : type_paiement,
      "acheteur" : acheteur,
    };
  }

  Vente.fromMap(Map<String, dynamic> map) {
    nom_produit = map[nom_produit];
    prix_produit = map[prix_produit];
    type_paiement = map[type_paiement];
    acheteur = map[acheteur];
  }

}