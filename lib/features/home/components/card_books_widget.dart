import 'package:flutter/material.dart';

class CardBooksWidget extends StatelessWidget {
  final String nome;
  final String autor;
  final String imagem;
  final bool isFavorited;
  final VoidCallback onTapFav;
  const CardBooksWidget({
    Key? key,
    required this.nome,
    required this.autor,
    required this.imagem,
    this.isFavorited = false,
    required this.onTapFav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imagem),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 235),
                    blurRadius: 1,
                    offset: Offset(3, 3),
                  )
                ]),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imagem),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -10,
                  child: IconButton(
                    onPressed: onTapFav,
                    icon: Icon(
                      isFavorited
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isFavorited ? Colors.red : Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          nome,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          autor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
