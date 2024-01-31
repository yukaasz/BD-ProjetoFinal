--Quais playlists forma criadas entre junho/2020 a agosto/2020
--Membro proponente: Daniella
SELECT nome_playlist FROM playlist 
WHERE data_criacao BETWEEN '2020-06-01' AND '2020-08-31';

--Qual o gênero musical mais curtido por país?
--Membro proponente: Daniella


--Qual a data com o maior número de adições de músicas na playlist ‘Faxinah’?
--Membro proponente: Daniella
select data_adicao, COUNT(data_adicao) AS quantidade
from E_adicionada
WHERE nome_playlist = 'Faxinah'
GROUP BY data_adicao
HAVING COUNT(data_adicao) = (SELECT MAX(conta)
                             FROM (SELECT COUNT(data_adicao) AS conta
                                   FROM E_adicionada
								   WHERE nome_playlist = 'Faxinah'
								   GROUP BY data_adicao));

--Quantas pessoas do sexo feminino curtem músicas do gênero musical pop? 
--Membro proponente: Lara


-- Qual a playlist mais longa do usuário ‘Larinha’?
--Membro proponente: Lara


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

--Qual o tempo total de músicas curtidas pelos usuários ‘Yugo’, 'Ronaldinho' e 'Ana Castela'?
--Membro proponente: Renan

SELECT nome_usuario, (tempo_total/3600 || ':' || (tempo_total%3600)/60 || ':' || tempo_total%60) AS tempo_curtida_total
FROM (
	SELECT nome_usuario, SUM(duracao) AS tempo_total
	FROM Usuario NATURAL JOIN Curte NATURAL JOIN Musica
	GROUP BY nome_usuario
	HAVING nome_usuario IN ('Yugo', 'Ronaldinho', 'Ana Castela')
);

--Quantas músicas das bandas ‘The Beatles’, ‘Imagine Dragons’ e ‘Arctic Monkeys’ foram adicionadas à playlist ‘Eternas’ na data de criação desta mesma playlist?
--Membro proponente: Renan

SELECT nome_artista, COUNT(ID_musica) AS qnt_musicas_data_criacao_playlist
FROM Artista 
NATURAL JOIN Escreve NATURAL JOIN Musica NATURAL JOIN E_adicionada NATURAL JOIN Playlist 
WHERE nome_artista IN('The Beatles', 'Imagine Dragons', 'Arctic Monkeys')
AND nome_playlist = 'Eternas'
AND data_adicao = data_criacao
GROUP BY Artista.nome_artista;