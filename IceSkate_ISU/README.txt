ICESKATE ISU — SISTEMA DE PATINAÇÃO ARTÍSTICA NO GELO
====================================================

REQUISITOS
- XAMPP (Apache, PHP 8+ e MySQL/MariaDB)
- Navegador atualizado

INSTALAÇÃO
1. Extraia a pasta IceSkate_ISU para C:\xampp\htdocs\
2. Abra o XAMPP e inicie Apache e MySQL.
3. Acesse http://localhost/phpmyadmin
4. Importe o arquivo banco.sql (ele cria o banco iceskate_isu e as tabelas).
5. Confira os dados de conexão em config.php. No XAMPP padrão, root sem senha.
6. Acesse http://localhost/IceSkate_ISU/login.php

CONTAS DE DEMONSTRAÇÃO
Administrador ISU
E-mail: admin@isu.org
Senha: admin123

Visualizador
E-mail: viewer@isu.org
Senha: viewer123

IMPORTANTE: troque as senhas e configure credenciais fortes antes de colocar o sistema em hospedagem pública. As contas são somente para demonstração escolar.

FUNCIONALIDADES
- Login único com perfil administrador ISU e visualizador.
- Controle de acesso no servidor: visualizador não acessa administração.
- Painel com panorama da temporada, calendário e destaques.
- Ranking de patinadores usando apenas resultados confirmados.
- Página criativa Prêmios & Súmulas: prêmios automáticos de maior total, destaque técnico (TES), excelência artística (PCS), consistência e programa curto. Inclui súmulas detalhadas por atleta e campeonato, com TES, PCS, deduções e total de cada segmento. Os dados são consultados diretamente do banco e consideram somente resultados confirmados.
- Diretório e perfil individual de atletas, histórico, país e federação.
- Cadastro de equipes/federações, atletas e campeonatos.
- Lançamento, confirmação e edição de resultados por atleta/campeonato.
- Exclusão de atletas, equipes e campeonatos (com vínculos protegidos por chaves estrangeiras).
- Pesquisa de atletas.

CÁLCULO DE PONTUAÇÃO (MODELO ISU)
Em cada segmento (programa curto e programa livre):
Pontuação do segmento = TES + PCS - deduções
Pontuação final = total do programa curto + total do programa livre
TES representa o Total Element Score (elementos técnicos, incluindo valores-base e GOE).
PCS representa o Program Component Score (componentes do programa).
O GOE oficial é atribuído em escala de -5 a +5. Os componentes são avaliados pelos juízes e recebem fatores conforme as regras da ISU.

Neste projeto escolar, o administrador informa os totais TES e PCS já apurados em cada segmento e as deduções. O sistema calcula a soma final. Ele não substitui o sistema oficial de julgamento da ISU nem calcula automaticamente o GOE por elemento, os fatores de cada disciplina ou o painel de juízes.

SEGURANÇA IMPLEMENTADA
- Senhas armazenadas com password_hash() e verificadas com password_verify().
- Consultas parametrizadas via PDO/prepared statements.
- Sessões com strict mode, cookies HttpOnly e SameSite=Lax.
- Regeneração do ID da sessão após login.
- Proteção CSRF em formulários POST.
- Verificação de sessão em páginas internas.
- Verificação de perfil no servidor para todas as ações administrativas.
- Saída HTML escapada com htmlspecialchars().
- Validação de identificadores e lista permitida para exclusões.
- Chaves estrangeiras e regras de exclusão no MySQL.

OBSERVAÇÕES
- Os resultados inseridos no banco são números fictícios para demonstrar o funcionamento do ranking.
- Os perfis de atletas são exemplos informativos; confirme biografias, equipes e dados antes de uso público.
- As fotografias externas são imagens ilustrativas de patinação/esporte, não necessariamente retratos dos atletas nomeados. Para uso real, substitua por imagens licenciadas/autorizadas.
- O calendário inicial foi preenchido como exemplo com eventos conhecidos (Grand Prix, Skate America, Cup of China, NHK Trophy, Finlandia Trophy, Grand Prix Final, Golden Spin e Denis Ten Memorial Challenge).
