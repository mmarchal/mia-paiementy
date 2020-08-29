class Vente {

  final String table = 'vente';
  final String columnId = '_id';
  final String columnNom = 'nom';
  final String columnPrix = 'prix';
  final String columnType = 'type';

  int id;
  String nom_produit;
  String prix_produit;
  String type_paiement;

  Vente({this.id, this.nom_produit, this.prix_produit, this.type_paiement});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom_produit': nom_produit,
      'prix_produit': prix_produit,
      "type_paiement" : type_paiement
    };
  }

  Vente.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    nom_produit = map[nom_produit];
    prix_produit = map[prix_produit];
    type_paiement = map[type_paiement];
  }

}