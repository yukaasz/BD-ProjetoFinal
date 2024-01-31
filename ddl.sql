CREATE DATABASE Spobrefy; 

CREATE TABLE Usuario(
    nome_usuario 		  varchar(100) PRIMARY KEY,
    sexo		          varchar(20) DEFAULT 'Nao Especificado' CHECK (sexo IN ('Feminino', 'Masculino', 'Nao Especificado')),
    pais	              varchar(20) NOT NULL,
    email                 varchar(100) NOT NULL,
    senha                 varchar(20) NOT NULL,
    data_nascimento       DATE NOT NULL, CHECK (data_nascimento > '1873-01-01' AND data_nascimento <= '2008-01-01')
);
 
CREATE TABLE Playlist(
    nome_usuario          varchar(100),
    nome_playlist         varchar(100),
    qnt_musicas           int DEFAULT 0 NOT NULL, CHECK(qnt_musicas >= 0 AND qnt_musicas <= 1000),
    duracao_playlist      int DEFAULT 0 NOT NULL, CHECK(duracao_playlist >= 0 AND duracao_playlist <= 780000),
    data_criacao          DATE NOT NULL, CHECK(data_criacao <= CURRENT_DATE),

    PRIMARY KEY(nome_usuario, nome_playlist),
    FOREIGN KEY(nome_usuario) REFERENCES Usuario(nome_usuario)
        ON UPDATE CASCADE -- cascade pois se a chave primária (nome_usuario) da relação Usuario muda, então a chave estrangeira (nome_usuario) de Playlist deve fazer referência à uma tupla válida
        ON DELETE CASCADE -- cascade pois playlist é uma entidade fraca, se o usuario que criou a playlist for apagado, então a playlist que faz referência a esse usuário também deve ser apagada para não violar a restrição referencial
);

CREATE TABLE Artista(
    ID_artista            int PRIMARY KEY,
    nome_artista          varchar(100) NOT NULL,
    pais_origem           varchar(50),
    ano_de_nascimento     int CHECK(ano_de_nascimento > 1300)
);

CREATE TABLE Musica(
    ID_musica             int PRIMARY KEY,
    nome_musica           varchar(100) NOT NULL,
    duracao               int NOT NULL, CHECK(duracao > 0 AND duracao <= 780),
    genero_musical        varchar(100) NOT NULL, CHECK(genero_musical IN ('Bossa Nova', 'Clássica', 'Country', 'Eletrônica', 'Gospel', 'Hip-hop', 'Indie', 'MPB', 'Pop', 'Rock')),
    ano_publicacao        int NOT NULL, CHECK (ano_publicacao <= EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TABLE Telefone(
    nome_usuario          varchar(100),
    telefone              varchar(14),

    PRIMARY KEY(nome_usuario, telefone),
    FOREIGN KEY(nome_usuario) REFERENCES Usuario(nome_usuario)
        ON UPDATE CASCADE -- cascade pois se a chave primária (nome_usuario) da relação Usuario muda, então a chave estrangeira (nome_usuario) da relação Telefone deve fazer referência à uma tupla válida, caso contrário violará a restrição de integridade referencial
        ON DELETE CASCADE -- cascade pois se a chave primária (nome_usuario) da relacao Usuario for excluída, então a chave estrangeira (nome_usuario) de Telefone estará fazendo referência a uma tupla válida, violado a restrição de integridade referencial
);

CREATE TABLE E_adicionada(
    ID_musica             int,
    nome_usuario          varchar(100),
    nome_playlist         varchar(100),
    data_adicao           DATE NOT NULL, CHECK(data_adicao <= CURRENT_DATE),
    
    PRIMARY KEY(ID_musica, nome_usuario, nome_playlist),
    FOREIGN KEY(ID_musica) REFERENCES Musica(ID_musica)
        ON UPDATE CASCADE -- cascade, pois se o ID de uma música é alterada, então a chave estrangeira deve acompanhar esta mudança para que a restrição referencial seja mantida
        ON DELETE CASCADE, -- cascade pois se o ID_musica de Musica for excluido, então a adição também tem que ser excluida, pois não da pra adicionar uma música que não existe
    FOREIGN KEY(nome_usuario, nome_playlist) REFERENCES Playlist(nome_usuario, nome_playlist)
        ON UPDATE CASCADE -- cascade pois se a chave primária de Playlist (nome_usuario, nome_playlist) muda, então a chave estrangeira de E_adicionada deve acompanhar esta mudança
        ON DELETE CASCADE -- cascade pois se a playlist deixa de existir, então a chave estrangeira de E_adicionada não fará referência a uma tupla válida. 
);

CREATE TABLE Favorita(
    nome_usuario_favorita varchar(100),
    nome_usuario_criador  varchar(100),
    nome_playlist         varchar(100),

    PRIMARY KEY(nome_usuario_favorita, nome_usuario_criador, nome_playlist),
    FOREIGN KEY(nome_usuario_favorita) REFERENCES Usuario(nome_usuario)
        ON UPDATE CASCADE -- cascade pois se o nome do usuário muda, o nome do usuário que favorita deve acompanhar essa mudança para a tupla continuar válida
        ON DELETE CASCADE, -- cascade pois se eu apago o usuário que favorita, deve excluir a relação pois a tupla deixaria de existir
    FOREIGN KEY(nome_usuario_criador, nome_playlist) REFERENCES Playlist(nome_usuario, nome_playlist)
        ON UPDATE CASCADE -- cascade pois se o nome da playlist ou do usuário muda, o atributos primários nome_usuario e nome_playlist, também devem seguir essa mudança para a tupla continuar válida
        ON DELETE CASCADE -- cascade, pois se a playlist for excluída, não faz sentido um usuário favoritar uma tupla que não existe
);

CREATE TABLE Curte(
    ID_musica             int,
    nome_usuario          varchar(100),

    PRIMARY KEY(ID_musica, nome_usuario),
    FOREIGN KEY(ID_musica) REFERENCES Musica(ID_musica)
        ON UPDATE CASCADE -- cascade, pois se a chave primária da relação Musica muda, então a relação Curte deve acompanhar tal mudança a fim de não violar a restrição referencial
        ON DELETE CASCADE,-- cascade, pois se uma tupla da relação Curte faz referência música que não existe, a própria tupla de Curte não existe e deve ser deletada
    FOREIGN KEY(nome_usuario) REFERENCES Usuario(nome_usuario)
        ON UPDATE CASCADE -- cascade, pois se um usuario tem sua chave primária alterada, as tuplas que referênciam este usuário em Curte não estariam corretas, violando a integridade referencial
        ON DELETE CASCADE -- cascade, pois se um usuário é removido do sistema, entao não é possível haver curtidas feitas por este usuário, e, portanto, não devem haver tuplas em Curte que referenciam este usuário
);

CREATE TABLE Escreve(
    ID_artista            int,
    ID_musica             int,

    PRIMARY KEY(ID_artista, ID_musica),
    FOREIGN KEY(ID_artista) REFERENCES Artista(ID_artista)
        ON UPDATE CASCADE  -- cascade pois se a chave primária de artista muda, então a relação Escreve deve acompanhar tal mudança para evitar violação de restrição referencial
        ON DELETE CASCADE, -- cascade, pois se um artista for removido do sistema, então não há referência valida de Escreve para Artista.
    FOREIGN KEY(ID_musica) REFERENCES Musica(ID_musica)
        ON UPDATE CASCADE -- cascade, pois se a chave primária de Musica for alterada então Escreve deve acompanhar tal mudança, para não haver violação de restrição referencial
        ON DELETE CASCADE -- cascade, pois se uma música é removida do bd, então não há artista quem escreva tal musica, e, portanto, não há relação Escreve.
);

CREATE TRIGGER t_atualiza_playlist
AFTER INSERT OR DELETE OR UPDATE ON E_adicionada
FOR EACH ROW
EXECUTE PROCEDURE atualiza_playlist();

CREATE OR REPLACE FUNCTION atualiza_playlist()
RETURNS TRIGGER AS $$
DECLARE duracao_musica INT;
BEGIN
    IF(TG_OP = 'INSERT') THEN
        UPDATE Playlist SET qnt_musicas = qnt_musicas + 1 
        WHERE nome_usuario = NEW.nome_usuario AND
        nome_playlist = NEW.nome_playlist;

        SELECT duracao FROM Musica WHERE New.ID_musica = ID_musica
        UPDATE Playlist SET duracao_playlist = duracao_playlist + NEW.duracao 



END;
$$ LANGUAGE plpgsql;