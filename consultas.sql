--Quais playlists forma criadas entre junho/2020 a agosto/2020
--Membro proponente: Daniella
SELECT nome_playlist FROM playlist 
WHERE data_criacao BETWEEN <data_inicial> AND <data_final>;

--Qual o gênero musical mais curtido por país?
--Membro proponente: Daniella
SELECT pais, genero_musical
FROM Usuario NATURAL JOIN Curte NATURAL JOIN Musica
GROUP BY genero_musical, pais
HAVING COUNT(genero_musical) = (SELECT MAX(conta)
									  FROM (SELECT pais, COUNT(genero_musical) AS conta
											FROM Usuario NATURAL JOIN Curte NATURAL JOIN Musica
											GROUP BY genero_musical, pais) t 
									  WHERE t.pais = Usuario.pais)
ORDER BY pais ASC, genero_musical ASC;

--Qual a data com o maior número de adições de músicas na playlist ‘Faxinah’?
--Membro proponente: Daniella
SELECT data_adicao, COUNT(data_adicao) AS quantidade
FROM E_adicionada
WHERE nome_playlist = <Nome da playlist>
GROUP BY data_adicao
HAVING COUNT(data_adicao) = (SELECT MAX(conta)
                             FROM (SELECT COUNT(data_adicao) AS conta
                                   FROM E_adicionada
								   WHERE nome_playlist = <Nome da playlist>
								   GROUP BY data_adicao));

--Quantas pessoas do sexo feminino curtem músicas de um determinado gênero musical? 
--Membro proponente: Lara
SELECT COUNT(nome_usuario) AS quantidade
FROM Usuario
WHERE sexo = 'Feminino'
AND nome_usuario IN (SELECT nome_usuario 
		   			 FROM Curte, Musica
		   			 WHERE Curte.id_musica = Musica.id_musica
		   			 AND Musica.genero_musical = <genero_musical>)


--Qual a playlist mais longa de um dado usuário?
--Membro proponente: Lara
SELECT nome_playlist 
FROM Playlist
WHERE duracao_playlist IN (SELECT MAX(duracao_playlist) 
						   FROM Playlist 
						   WHERE nome_usuario = <nome_usuario>)


--Quais músicas curtidas pelo usuário ‘Lucas’ não estão em nenhuma playlist?
--Membro proponente: Lucas


--Qual o gênero musical que prevalece nas músicas da artista Billie Eilish?
--Membro proponente: Lucas

--Quantas músicas do artista ‘Ed Sheeran’ estão presentes nas playlists ‘Eternas’, 'Faxinah' e 'Pra ouvir no banho'?
--Membro proponente: Renan

SELECT nome_playlist, COUNT(ID_musica) AS qnt_EdSheeran
FROM E_adicionada NATURAL JOIN Musica NATURAL JOIN Escreve
WHERE ID_artista = 03
AND nome_playlist IN ('Eternas', 'Faxinah', 'Pra ouvir no banho')
GROUP BY ID_artista, nome_playlist;

SELECT nome_playlist, COUNT(ID_musica) AS qnt_EdSheeran
FROM E_adicionada NATURAL JOIN Musica NATURAL JOIN Escreve
WHERE ID_artista = 03
AND nome_playlist IN (<nome_playlist1>, <nome_playlist2> , <nome_playlist_n>)
GROUP BY ID_artista, nome_playlist;

--Qual o tempo total de músicas curtidas pelos usuários ‘Yugo’, 'Ronaldinho' e 'Ana Castela'?
--Membro proponente: Renan

SELECT nome_usuario, (tempo_total/3600 || ':' || (tempo_total%3600)/60 || ':' || tempo_total%60) AS tempo_curtida_total
FROM (
	SELECT nome_usuario, SUM(duracao) AS tempo_total
	FROM Usuario NATURAL JOIN Curte NATURAL JOIN Musica
	WHERE nome_usuario IN ('Yugo', 'Ronaldinho', 'Ana Castela')
	GROUP BY nome_usuario
);

--Quantas músicas das bandas ‘The Beatles’, ‘Imagine Dragons’ e ‘Arctic Monkeys’ foram adicionadas à playlist ‘Eternas’ na data de criação desta mesma playlist?
--Membro proponente: Renan

SELECT nome_artista, COUNT(ID_musica) AS qnt
FROM Artista 
NATURAL JOIN Escreve NATURAL JOIN Musica NATURAL JOIN E_adicionada NATURAL JOIN Playlist 
WHERE nome_artista IN('The Beatles', 'Imagine Dragons', 'Arctic Monkeys')
AND nome_playlist = 'Eternas'
AND data_adicao = data_criacao
GROUP BY nome_artista;