--Quais playlists forma criadas entre junho/2020 a agosto/2020
--Membro proponente: Daniella
SELECT nome_playlist FROM playlist 
WHERE data_criacao BETWEEN <inicio_intervalo> AND <fim_intervalo>;

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

SELECT Musica.nome_musica
FROM Musica
LEFT JOIN Curte ON Musica.ID_musica = Curte.ID_musica
LEFT JOIN E_adicionada ON Musica.ID_musica = E_adicionada.ID_musica
LEFT JOIN Playlist ON E_adicionada.nome_usuario = Playlist.nome_usuario AND E_adicionada.nome_playlist = Playlist.nome_playlist
WHERE Curte.nome_usuario = <nome_usuario> AND Playlist.nome_usuario IS NULL;


--Qual o gênero musical que prevalece nas músicas da artista Billie Eilish?
--Membro proponente: Lucas

SELECT genero_musical, COUNT(*) AS quantidade
FROM Musica
JOIN Escreve ON Musica.ID_musica = Escreve.ID_musica
JOIN Artista ON Escreve.ID_artista = Artista.ID_artista
WHERE Artista.nome_artista = <nome_artista>
GROUP BY genero_musical
ORDER BY quantidade DESC
LIMIT 1;

--Quantas músicas de um determinado artista estão presentes em uma playlist? (sumarização)
--Membro proponente: Renan
SELECT nome_playlist, COUNT(ID_musica) AS qnt
FROM E_adicionada NATURAL JOIN Musica NATURAL JOIN Escreve
WHERE ID_artista = <ID_artista>
AND nome_playlist IN (<nome_playlist_n>)
GROUP BY ID_artista, nome_playlist;

--Qual o tempo total de músicas curtidas por um usuário? (sumarização)
--Membro proponente: Renan
SELECT nome_usuario, (tempo_total/3600 || ':' || (tempo_total%3600)/60 || ':' || tempo_total%60) AS tempo_curtida_total
FROM (
	SELECT nome_usuario, SUM(duracao) AS tempo_total
	FROM Usuario NATURAL JOIN Curte NATURAL JOIN Musica
	WHERE nome_usuario IN (<nome_usuario_n>)
	GROUP BY nome_usuario
);

--Quantas músicas de um determinado artista foram adicionadas a uma playlist na data de criação desta mesma playlist? (sumarização)
--Membro proponente: Renan
SELECT nome_artista, COUNT(ID_musica) AS qnt
FROM Artista 
NATURAL JOIN Escreve NATURAL JOIN Musica NATURAL JOIN E_adicionada NATURAL JOIN Playlist 
WHERE nome_artista IN(<nome_artista_n>)
AND nome_playlist = <nome_playlist>
AND data_adicao = data_criacao
GROUP BY nome_artista;