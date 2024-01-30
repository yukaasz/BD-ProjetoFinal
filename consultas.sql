--liste todos os vinhos que tem em cada vinicola da regiao sul
SELECT * FROM vinho, vinicola, regiao 
WHERE nome_regiao = 'Sul' AND
	vinho.vinicola_id = vinicola.vinicola_id AND
	vinicola.regiao_id = regiao.regiao_id;
	
--liste todas as vinicolas que terminam com s
SELECT * FROM vinicola
	WHERE nome_vinicola LIKE '%s'; -- % é substring (alguma coisa + s)
	
--Liste a quantidade de vinhos que tem em cada vinícola 
SELECT vinicola_id, COUNT(vinho_id)
FROM vinho
GROUP BY vinicola_id;

--Liste a quantidade de vinhos que tem em cada vinícola da região SUL
SELECT vinicola.nome_vinicola, COUNT(vinho_id)
FROM vinho, vinicola, regiao
WHERE regiao.nome_regiao = 'Sul' AND
	vinho.vinicola_id = vinicola.regiao_id AND
	vinicola.regiao_id = regiao.regiao_id
GROUP BY vinicola.vinicola_id;

--Liste a quantidade de vinhos que tem em cada vinícola da 
--região SUL para as vinícolas que tem mais de 1 vinho (>1)

SELECT vinicola.nome_vinicola, COUNT(vinho_id)
FROM vinho, vinicola, regiao
WHERE regiao.nome_regiao = 'Sul' AND
	vinho.vinicola_id = vinicola.regiao_id AND
	vinicola.regiao_id = regiao.regiao_id
GROUP BY vinicola.vinicola_id
HAVING count(vinho_id)>1;

--Liste as vinícolas que não tem cadastro de vinhos
SELECT nome_vinicola
FROM vinicola
WHERE vinicola_id NOT IN
	(SELECT vinicola_id FROM vinho);
	
--mesmo de cima
SELECT vinho.vinicola_id, vinicola.nome_vinicola
FROM vinho RIGHT JOIN vinicola ON (vinho.vinicola_id = vinicola.vinicola_id)
WHERE vinho.nome_vinho IS NULL;

--mostrar o id da vinicola e a quantidade de vinhos
SELECT vinicola.vinicola_id, COUNT(vinho_id)
FROM vinho RIGHT JOIN vinicola ON (vinho.vinicola_id = vinicola.vinicola_id)
GROUP BY vinicola.vinicola_id
ORDER BY vinicola.vinicola_id;


--região com mais vinicolas / nao funciona
SELECT nome_regiao
(SELECT max(SELECT vinicola.vinicola_id, COUNT(vinho_id)
FROM vinho RIGHT JOIN vinicola ON (vinho.vinicola_id = vinicola.vinicola_id)
GROUP BY vinicola.vinicola_id AS "quantidade") FROM vinicola) AS "maior quantidade"
FROM regiao; 

