CREATE DATABASE IF NOT EXISTS iceskate_isu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE iceskate_isu;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS resultados; DROP TABLE IF EXISTS patinadores; DROP TABLE IF EXISTS campeonatos; DROP TABLE IF EXISTS equipes; DROP TABLE IF EXISTS usuarios;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE usuarios (id INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(100) NOT NULL,email VARCHAR(150) NOT NULL UNIQUE,senha VARCHAR(255) NOT NULL,perfil ENUM('admin','visualizador') NOT NULL DEFAULT 'visualizador',criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB;
CREATE TABLE equipes (id INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(100) NOT NULL,pais VARCHAR(80) NOT NULL,sigla VARCHAR(8) NOT NULL,descricao TEXT,logo VARCHAR(500),UNIQUE KEY uq_pais(pais)) ENGINE=InnoDB;
CREATE TABLE patinadores (id INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(130) NOT NULL,pais VARCHAR(80) NOT NULL,equipe_id INT NULL,disciplina ENUM('Individual feminino','Individual masculino','Duplas','Dança no gelo') NOT NULL,idade TINYINT UNSIGNED NULL,treinador VARCHAR(120),conquistas TEXT,biografia TEXT,foto VARCHAR(500),ativo TINYINT(1) NOT NULL DEFAULT 1,FOREIGN KEY(equipe_id) REFERENCES equipes(id) ON DELETE SET NULL) ENGINE=InnoDB;
CREATE TABLE campeonatos (id INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(150) NOT NULL,cidade VARCHAR(100),pais VARCHAR(80),data_inicio DATE NOT NULL,data_fim DATE NOT NULL,categoria VARCHAR(80) DEFAULT 'ISU Grand Prix',status ENUM('Agendado','Em andamento','Finalizado') DEFAULT 'Agendado',descricao TEXT) ENGINE=InnoDB;
CREATE TABLE resultados (id INT AUTO_INCREMENT PRIMARY KEY,patinador_id INT NOT NULL,campeonato_id INT NOT NULL,programa_curto_tes DECIMAL(7,2) DEFAULT NULL,programa_curto_pcs DECIMAL(7,2) DEFAULT NULL,programa_curto_deducoes DECIMAL(5,2) DEFAULT 0,programa_livre_tes DECIMAL(7,2) DEFAULT NULL,programa_livre_pcs DECIMAL(7,2) DEFAULT NULL,programa_livre_deducoes DECIMAL(5,2) DEFAULT 0,total_final DECIMAL(8,2) DEFAULT NULL,confirmado TINYINT(1) NOT NULL DEFAULT 0,atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,UNIQUE KEY uq_resultado(patinador_id,campeonato_id),FOREIGN KEY(patinador_id) REFERENCES patinadores(id) ON DELETE CASCADE,FOREIGN KEY(campeonato_id) REFERENCES campeonatos(id) ON DELETE CASCADE) ENGINE=InnoDB;
-- Senhas iniciais: admin123 e viewer123 (troque após o primeiro acesso).
INSERT INTO usuarios(nome,email,senha,perfil) VALUES
('ISU Administration','admin@isu.org','$2y$12$EqkVqsMHdjDlmwtIbd5MDetWQiQXfJMwo9IPDLItdlIf6fpF3QcYi','admin'),
('Acesso de Visualização','viewer@isu.org','$2y$12$ndqohRYIYEC1A8kp2whL.ekFfRzt47YCnQ4jo5.Gf2BMC1VswUvZy','visualizador');
INSERT INTO equipes(nome,pais,sigla,descricao,logo) VALUES
('Japan Skating Federation','Japão','JPN','Federação japonesa, referência mundial em patinação individual e duplas.','🇯🇵'),
('U.S. Figure Skating','Estados Unidos','USA','Federação nacional dos Estados Unidos, com tradição em todas as disciplinas.','🇺🇸'),
('Skate Canada','Canadá','CAN','Federação canadense, reconhecida especialmente pela dança no gelo.','🇨🇦'),
('Russian Figure Skating Federation · AIN1','Rússia','AIN1','Grupo de atletas russas identificado como AIN1 nesta plataforma. A designação é apenas organizacional e não representa, por si só, elegibilidade oficial da ISU.','🇷🇺'),
('Federazione Italiana Sport del Ghiaccio','Itália','ITA','Federação italiana com atletas de destaque em dança no gelo e provas individuais.','🇮🇹'),
('Fédération Française des Sports de Glace','França','FRA','Federação francesa, com tradição técnica e artística.','🇫🇷'),
('Korean Skating Union','Coreia do Sul','KOR','Federação sul-coreana, com presença crescente no cenário internacional.','🇰🇷'),
('Georgian Figure Skating Federation','Geórgia','GEO','Federação em ascensão no circuito internacional.','🇬🇪'),
('Belgian Figure Skating','Bélgica','BEL','Federação belga com representantes de destaque no individual.','🇧🇪');
INSERT INTO patinadores(nome,pais,equipe_id,disciplina,idade,treinador,conquistas,biografia,foto) VALUES
('Ilia Malinin','Estados Unidos',2,'Individual masculino',21,'Rafael Arutyunyan','Campeão mundial; conhecido pelo salto quádruplo Axel.','Um dos nomes mais inovadores da patinação masculina, conhecido pela dificuldade técnica e potência nos saltos.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Amber Glenn','Estados Unidos',2,'Individual feminino',26,'Benoit Richaud','Campeã nacional dos Estados Unidos.','Patinadora norte-americana conhecida por sua velocidade, presença de pista e repertório técnico.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Kaori Sakamoto','Japão',1,'Individual feminino',26,'Sonoko Nakano','Tricampeã mundial.','Referência japonesa em potência, qualidade de patinação e consistência competitiva.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Yuma Kagiyama','Japão',1,'Individual masculino',23,'Masakazu Kagiyama','Medalhista olímpico e mundial.','Atleta japonês reconhecido pela qualidade dos movimentos, fluidez e execução técnica.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Riku Miura & Ryuichi Kihara','Japão',1,'Duplas',24,'Bruno Marcotte','Campeões mundiais de duplas.','Dupla japonesa de destaque internacional, conhecida pela força dos elementos e sincronia.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Madison Chock & Evan Bates','Estados Unidos',2,'Dança no gelo',34,'Marie-France Dubreuil','Campeões mundiais de dança no gelo.','Dupla norte-americana reconhecida pela interpretação musical e composição coreográfica.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Loena Hendrickx','Bélgica',9,'Individual feminino',27,'Joris Brasseur','Medalhista mundial e europeia.','Patinadora belga conhecida pela expressividade e qualidade artística.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Adam Siao Him Fa','França',6,'Individual masculino',25,'Benoit Richaud','Medalhista mundial e europeu.','Patinador francês conhecido por sua presença artística e elementos de alta dificuldade.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Charlène Guignard & Marco Fabbri','Itália',5,'Dança no gelo',37,'Barbara Fusar-Poli','Medalhistas mundiais e europeus.','Dupla italiana de dança no gelo com grande experiência no circuito internacional.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Anastasiia Gubanova','Geórgia',8,'Individual feminino',23,'Eteri Tutberidze','Campeã europeia.','Representante da Geórgia no individual feminino, com destaque em competições europeias.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Anna Shcherbakova','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Campeã olímpica de 2022 e campeã mundial de 2021.','Patinadora russa conhecida pela consistência técnica e pela execução de saltos quádruplos.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Kamila Valieva','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Campeã europeia de 2022.','Patinadora russa que ganhou destaque internacional por sua capacidade técnica e apresentações expressivas.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Alexandra Ignatova (Trusova)','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Medalhista olímpica de prata em 2022.','Conhecida pela grande dificuldade técnica e pela execução de múltiplos saltos quádruplos.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Evgenia Medvedeva','Rússia',4,'Individual feminino',NULL,'Brian Orser','Bicampeã mundial e medalhista olímpica.','Patinadora reconhecida pela interpretação musical, qualidade de movimentos e consistência competitiva.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Adeliia Petrosian','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Destaque da nova geração da patinação russa.','Patinadora russa da nova geração, conhecida pela dificuldade técnica de seus programas.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Alina Zagitova','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Campeã olímpica de 2018 e campeã mundial de 2019.','Patinadora russa conhecida pela velocidade, precisão técnica e presença artística.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Yulia Lipnitskaya','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Campeã olímpica por equipes em 2014 e campeã europeia.','Patinadora russa lembrada pela flexibilidade, velocidade e apresentação no programa de equipes dos Jogos de 2014.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Aliona Kostornaia','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Campeã europeia de 2020.','Patinadora russa conhecida pela qualidade dos eixos, fluidez e componentes artísticos.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900'),
('Elizaveta Tuktamysheva','Rússia',4,'Individual feminino',NULL,'Alexei Mishin','Campeã mundial de 2015 e campeã europeia de 2015.','Patinadora russa experiente, reconhecida pela longevidade competitiva e pelo triplo Axel.','https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900'),
('Sofia Akatieva','Rússia',4,'Individual feminino',NULL,'Eteri Tutberidze','Campeã mundial júnior de 2022.','Patinadora russa da nova geração, conhecida pela dificuldade técnica dos programas.','https://images.unsplash.com/photo-1518611012118-696072aa579a?w=900');
INSERT INTO campeonatos(nome,cidade,pais,data_inicio,data_fim,categoria,status,descricao) VALUES
('ISU Grand Prix de France','Angers','França','2026-10-23','2026-10-25','ISU Grand Prix','Finalizado','Etapa do circuito Grand Prix de patinação artística.'),
('Skate Canada International','Kelowna','Canadá','2026-10-30','2026-11-01','ISU Grand Prix','Finalizado','Etapa canadense do circuito Grand Prix.'),
('Cup of China','Shenzhen','China','2026-11-06','2026-11-08','ISU Grand Prix','Finalizado','Etapa chinesa do circuito Grand Prix.'),
('Skate America','Everett, Washington','Estados Unidos','2026-11-13','2026-11-15','ISU Grand Prix','Finalizado','Etapa norte-americana do circuito Grand Prix.'),
('Finlandia Trophy','Helsinque','Finlândia','2026-11-20','2026-11-21','ISU Grand Prix','Agendado','Etapa finlandesa do circuito Grand Prix.'),
('NHK Trophy','Tóquio','Japão','2026-11-27','2026-11-29','ISU Grand Prix','Agendado','Etapa japonesa do circuito Grand Prix.'),
('ISU Grand Prix Final','Chongqing','China','2026-12-10','2026-12-12','Final do Grand Prix','Agendado','Final que reúne os melhores classificados do circuito.'),
('World Figure Skating Championships','A definir','A definir','2027-03-17','2027-03-21','Campeonato Mundial','Agendado','Campeonato mundial da ISU.'),
('Golden Spin of Zagreb','Zagreb','Croácia','2026-12-02','2026-12-05','Challenger Series','Agendado','Competição internacional do circuito Challenger.'),
('Denis Ten Memorial Challenge','Almaty','Cazaquistão','2026-10-01','2026-10-04','Challenger Series','Finalizado','Competição internacional em homenagem a Denis Ten.');
-- Resultados fictícios para demonstração do cálculo e da classificação.
INSERT INTO resultados(patinador_id,campeonato_id,programa_curto_tes,programa_curto_pcs,programa_curto_deducoes,programa_livre_tes,programa_livre_pcs,programa_livre_deducoes,total_final,confirmado) VALUES
(1,4,58.40,44.20,0,112.60,89.10,1,303.30,1),
(3,1,39.50,36.80,0,78.20,75.40,0,229.90,1),
(4,2,55.20,42.60,0,105.40,83.20,0,286.40,1),
(6,3,48.70,39.50,0,76.80,63.40,0,228.40,1),
(8,4,51.10,39.20,0,98.40,78.60,0,267.30,1),
(2,4,37.80,34.90,0,72.30,70.10,0,215.10,0);
