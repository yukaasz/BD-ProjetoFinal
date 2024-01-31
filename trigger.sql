-- Trigger em E_adicionada para atualizar a quantidade de musicas da playlist, assim como sua duracao total

CREATE TRIGGER t_atualiza_playlist
AFTER INSERT OR DELETE OR UPDATE ON E_adicionada
FOR EACH ROW
EXECUTE PROCEDURE atualiza_playlist();

CREATE OR REPLACE FUNCTION atualiza_playlist()
RETURNS TRIGGER AS $$
DECLARE duracao_musica INT;
BEGIN
    IF(TG_OP = 'INSERT') THEN
        UPDATE Playlist SET qnt_musicas = qnt_musicas + 1 -- Atualiza a quantidade de musicas na playlist
        WHERE nome_usuario = NEW.nome_usuario
        AND nome_playlist = NEW.nome_playlist;
        SELECT duracao FROM Musica WHERE New.ID_musica = ID_musica INTO duracao_musica; -- Armazena a duracao da musica em uma variavel local
        UPDATE Playlist SET duracao_playlist = duracao_playlist + duracao_musica -- Atualiza a duracao total da playlist
		WHERE nome_playlist = NEW.nome_playlist
		AND nome_usuario = NEW.nome_usuario;
    ELSEIF(TG_OP = 'DELETE') THEN
        UPDATE Playlist SET qnt_musicas = qnt_musicas - 1 
        WHERE nome_usuario = OLD.nome_usuario 
		AND nome_playlist = OLD.nome_playlist;
        SELECT duracao FROM Musica WHERE OLD.ID_musica = ID_musica INTO duracao_musica;
        UPDATE Playlist SET duracao_playlist = duracao_playlist - duracao_musica
		WHERE nome_playlist = OLD.nome_playlist 
		AND nome_usuario = OLD.nome_usuario;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;