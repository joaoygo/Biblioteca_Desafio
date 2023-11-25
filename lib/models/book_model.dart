class BookModel {
  String id;
  String titulo;
  String autor;
  String imagem;
  String linkDownload;

  BookModel({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.imagem,
    required this.linkDownload,
  });

  BookModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        titulo = json['title'].toString(),
        autor = json['author'].toString(),
        imagem = json['cover_url'].toString(),
        linkDownload = json['download_url'].toString();
}
