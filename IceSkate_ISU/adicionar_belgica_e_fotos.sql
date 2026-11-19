-- Atualizacao de atletas e fotografias ISU
-- Execute depois de importar banco.sql.
USE iceskate_isu;

-- Garante a equipe da Bélgica sem duplicar caso já exista.
INSERT INTO equipes (nome,pais,sigla,descricao,logo)
SELECT 'Belgian Figure Skating','Bélgica','BEL','Federação belga de patinação artística.','🇧🇪'
WHERE NOT EXISTS (SELECT 1 FROM equipes WHERE pais='Bélgica');

SET @belgica = (SELECT id FROM equipes WHERE pais='Bélgica' LIMIT 1);

-- Jade Hovine: perfil individual feminino.
INSERT INTO patinadores (nome,pais,equipe_id,disciplina,idade,treinador,conquistas,biografia,foto)
SELECT 'Jade Hovine','Bélgica',@belgica,'Individual feminino',22,'Cédric Tour; Rodolphe Maréchal',
'Participou do Campeonato Europeu de 2025 e do Mundial de 2026.',
'Patinadora belga. Perfil e fotografia consultados na International Skating Union (ISU).',
'https://isu-d8g8b4b7ece7aphs.a03.azurefd.net/isudamcontainer/CMS/Fansite/Figure-Skating/2024-2025/Skater-Portraits/jade-hovine.jpg'
WHERE NOT EXISTS (SELECT 1 FROM patinadores WHERE nome='Jade Hovine');

-- Sofiia Beznosikova e Max Leleu são cadastrados como uma dupla de dança no gelo,
-- seguindo o modelo já utilizado no banco para duplas. A ISU informa que representaram
-- a Bélgica até o outono de 2025; o perfil atual da ISU mostra AZE.
INSERT INTO patinadores (nome,pais,equipe_id,disciplina,idade,treinador,conquistas,biografia,foto)
SELECT 'Sofiia Beznosikova & Max Leleu','Bélgica',@belgica,'Dança no gelo',NULL,
'Elizaveta Nemtseva; Igor Shpilband; Pasquale Camerlengo',
'11º lugar no Campeonato Mundial Júnior de 2025.',
'Dupla de dança no gelo que representou a Bélgica até o outono de 2025, conforme biografia da ISU.',
'https://isu-d8g8b4b7ece7aphs.a03.azurefd.net/isudamcontainer/CMS/Fansite/Figure-Skating/2024-2025/Skater-Portraits/sofiia-beznosikova.jpg'
WHERE NOT EXISTS (SELECT 1 FROM patinadores WHERE nome='Sofiia Beznosikova & Max Leleu');

-- Fonte da foto de Max Leleu (a URL oficial existe, mas o servidor ISU apresentou timeout
-- durante a conferência; por isso a dupla usa provisoriamente o retrato oficial de Sofiia).
-- Perfil oficial: https://isu-skating.com/en/figure-skating/skaters/pairs/sofiia-beznosikova-max-leleu/
-- Perfil Jade: https://isu-skating.com/en/figure-skating/skaters/jade-hovine/
