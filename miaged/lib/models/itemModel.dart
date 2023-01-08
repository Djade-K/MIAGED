import 'dart:io';

class itemModel {
  itemModel(
      this.image,
      this.titre,
      this.Categorie,
      this.Marque,
      this.Prix,
      this.Taille
  );

  final String image;
  final String titre;
  final String Categorie;
  final String Marque;
  final double Prix;
  final String Taille;
}