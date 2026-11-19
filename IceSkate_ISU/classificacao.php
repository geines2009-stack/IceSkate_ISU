
<?php
require_once 'includes/auth.php';
require_once 'includes/db.php';

require_login();

$sql = "
    SELECT *
    FROM (
        SELECT
            p.id,
            p.nome,
            p.pais,
            p.disciplina,
            p.foto,
            e.sigla,
            MAX(
                CASE
                    WHEN r.confirmado = 1 THEN r.total_final
                END
            ) AS melhor,
            COUNT(
                CASE
                    WHEN r.confirmado = 1 THEN r.id
                END
            ) AS provas
        FROM patinadores p
        LEFT JOIN equipes e
            ON e.id = p.equipe_id
        LEFT JOIN resultados r
            ON r.patinador_id = p.id
        GROUP BY
            p.id,
            p.nome,
            p.pais,
            p.disciplina,
            p.foto,
            e.sigla
    ) AS ranking
    ORDER BY
        (ranking.melhor IS NULL),
        ranking.melhor DESC,
        ranking.nome ASC
";

$rows = db()->query($sql)->fetchAll();

$pageTitle = 'Ranking';

require 'includes/header.php';
?>

<div class="page-intro">
    <span class="eyebrow">WORLD STANDINGS · SEASON 2026/27</span>

    <h1>Ranking de <em>atletas.</em></h1>

    <p>
        Classificação atualizada automaticamente com os resultados
        confirmados cadastrados pelo administrador.
        Atletas sem resultado confirmado aparecem no fim da tabela.
    </p>
</div>

<div class="table-card">

    <div class="table-top">
        <div>
            <b>Classificação geral</b>
            <small>
                Somente resultados confirmados contam para provas
                e melhor total.
            </small>
        </div>

        <span class="season-tag">ISU SCORING</span>
    </div>

    <div class="table-scroll">

        <table>
            <thead>
                <tr>
                    <th>POS.</th>
                    <th>ATLETA</th>
                    <th>PAÍS</th>
                    <th>DISCIPLINA</th>
                    <th>PROVAS</th>
                    <th>MELHOR TOTAL</th>
                </tr>
            </thead>

            <tbody>

                <?php foreach ($rows as $i => $r): ?>

                    <tr>
                        <td>
                            <span class="position <?= $i < 3 ? 'podium' : '' ?>">
                                <?= str_pad($i + 1, 2, '0', STR_PAD_LEFT) ?>
                            </span>
                        </td>

                        <td>
                            <a class="table-athlete"
                               href="patinador.php?id=<?= (int)$r['id'] ?>">

                                <img src="<?= e($r['foto']) ?>" alt="">

                                <b><?= e($r['nome']) ?></b>
                            </a>
                        </td>

                        <td><?= e($r['sigla'] ?? '—') ?></td>

                        <td><?= e($r['disciplina']) ?></td>

                        <td><?= (int)$r['provas'] ?></td>

                        <td class="score-cell">
                            <?= $r['melhor'] !== null
                                ? number_format((float)$r['melhor'], 2, '.', '')
                                : '—' ?>
                        </td>
                    </tr>

                <?php endforeach; ?>

            </tbody>
        </table>

    </div>
</div>

<p class="note">
    * Ranking interno da demonstração. O ranking mundial oficial
    da ISU utiliza critérios e períodos próprios.
</p>

<?php require 'includes/footer.php'; ?>
