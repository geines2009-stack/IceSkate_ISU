-- Atualização para quem JÁ importou o banco.sql anterior.
-- Faça backup do banco antes de executar este arquivo no phpMyAdmin.
USE iceskate_isu;

ALTER TABLE equipes MODIFY sigla VARCHAR(8) NOT NULL;
UPDATE equipes
SET nome = 'Russian Figure Skating Federation · AIN1',
    sigla = 'AIN1',
    descricao = 'Grupo de atletas russas identificado como AIN1 nesta plataforma. A designação é apenas organizacional e não representa, por si só, elegibilidade oficial da ISU.'
WHERE pais = 'Rússia';

-- Insere cada atleta somente se ainda não existir.
INSERT INTO patinadores (nome,pais,equipe_id,disciplina,treinador,conquistas,biografia,foto)
SELECT dados.nome,'Rússia',e.id,'Individual feminino',dados.treinador,dados.conquistas,dados.biografia,dados.foto
FROM equipes e
JOIN (
  SELECT 'Anna Shcherbakova' nome,'Eteri Tutberidze' treinador,'Campeã olímpica de 2022 e campeã mundial de 2021.' conquistas,'Patinadora russa conhecida pela consistência técnica e pela execução de saltos quádruplos.' biografia,'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900' foto
  UNION ALL SELECT 'Kamila Valieva','Eteri Tutberidze','Campeã europeia de 2022.','Patinadora russa que ganhou destaque internacional por sua capacidade técnica e apresentações expressivas.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'
  UNION ALL SELECT 'Alexandra Ignatova (Trusova)','Eteri Tutberidze','Medalhista olímpica de prata em 2022.','Conhecida pela grande dificuldade técnica e pela execução de múltiplos saltos quádruplos.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'
  UNION ALL SELECT 'Evgenia Medvedeva','Brian Orser','Bicampeã mundial e medalhista olímpica.','Patinadora reconhecida pela interpretação musical, qualidade de movimentos e consistência competitiva.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'
  UNION ALL SELECT 'Adeliia Petrosian','Eteri Tutberidze','Destaque da nova geração da patinação russa.','Patinadora russa da nova geração, conhecida pela dificuldade técnica de seus programas.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'
  UNION ALL SELECT 'Alina Zagitova','Eteri Tutberidze','Campeã olímpica de 2018 e campeã mundial de 2019.','Patinadora russa conhecida pela velocidade, precisão técnica e presença artística.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'
  UNION ALL SELECT 'Yulia Lipnitskaya','Eteri Tutberidze','Campeã olímpica por equipes em 2014 e campeã europeia.','Patinadora russa lembrada pela flexibilidade, velocidade e apresentação no programa de equipes dos Jogos de 2014.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'
  UNION ALL SELECT 'Aliona Kostornaia','Eteri Tutberidze','Campeã europeia de 2020.','Patinadora russa conhecida pela qualidade dos eixos, fluidez e componentes artísticos.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'
  UNION ALL SELECT 'Elizaveta Tuktamysheva','Alexei Mishin','Campeã mundial de 2015 e campeã europeia de 2015.','Patinadora russa experiente, reconhecida pela longevidade competitiva e pelo triplo Axel.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'
  UNION ALL SELECT 'Sofia Akatieva','Eteri Tutberidze','Campeã mundial júnior de 2022.','Patinadora russa da nova geração, conhecida pela dificuldade técnica dos programas.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'
) AS dados
WHERE e.pais='Rússia'
AND NOT EXISTS (SELECT 1 FROM patinadores p WHERE p.nome=dados.nome AND p.equipe_id=e.id);

-- O ranking usa apenas resultados confirmados. Não cria pontuações fictícias.
-- Ao confirmar/editar um resultado no painel, a classificação reflete o novo total automaticamente.
