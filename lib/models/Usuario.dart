class Usuario {
  String id;
  String nome;
  String email;
  String senha;

  Usuario({
    this.nome = "",
    this.senha = "",
    this.email = "",
  });

  Usuario.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.nome = json['nome'];
    this.email = json['email'];
    this.senha = json['senha'];
  }

  Map<String, dynamic> toJson() => {
        "nome": nome ?? "null",
        "senha": senha ?? "null",
        "email": email ?? "null",
      };
}
