class Vente {

  String date_vente;
  String nom_produit;
  String prix_produit;
  String type_paiement;
  String acheteur;

  @override
  String toString() {
    return '$date_vente;$nom_produit;$prix_produit;$type_paiement;$acheteur;';
  }

  Vente({this.date_vente, this.nom_produit, this.prix_produit, this.type_paiement, this.acheteur});

  Map<String, dynamic> toMap() {
    return {
      'date_vente': date_vente,
      'nom_produit': nom_produit,
      'prix_produit': prix_produit,
      "type_paiement" : type_paiement,
      "acheteur" : acheteur,
    };
  }

  Vente.fromMap(Map<String, dynamic> map) {
    date_vente = map[date_vente];
    nom_produit = map[nom_produit];
    prix_produit = map[prix_produit];
    type_paiement = map[type_paiement];
    acheteur = map[acheteur];
  }

}