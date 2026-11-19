<?php
require_once 'includes/auth.php';
require_once 'includes/db.php';
require_login();

$pdo = db();

// Premiações calculadas somente com resultados confirmados.
$awards = [];
$awardQueries = [
    'overall' => "SELECT p.nome, p.pais, p.foto, c.nome campeonato, r.total_final valor
                 FROM resultados r JOIN patinadores p ON p.id=r.patinador_id
                 JOIN campeonatos c ON c.id=r.campeonato_id
                 WHERE r.confirmado=1 AND r.total_final IS NOT NULL
                 ORDER BY r.total_final DESC, p.nome ASC LIMIT 1",
    'technical' => "SELECT p.nome, p.pais, p.foto, c.nome campeonato,
                    (COALESCE(r.programa_curto_tes,0)+COALESCE(r.programa_livre_tes,0)) valor
                    FROM resultados r JOIN patinadores p ON p.id=r.patinador_id
                    JOIN campeonatos c ON c.id=r.campeonato_id
                    WHERE r.confirmado=1
                    ORDER BY valor DESC, p.nome ASC LIMIT 1",
    'components' => "SELECT p.nome, p.pais, p.foto, c.nome campeonato,
                     (COALESCE(r.programa_curto_pcs,0)+COALESCE(r.programa_livre_pcs,0)) valor
                     FROM resultados r JOIN patinadores p ON p.id=r.patinador_id
                     JOIN campeonatos c ON c.id=r.campeonato_id
                     WHERE r.confirmado=1
                     ORDER BY valor DESC, p.nome ASC LIMIT 1",
    'consistent' => "SELECT p.nome, p.pais, p.foto, COUNT(*) participacoes,
                     ROUND(AVG(r.total_final),2) valor
                     FROM resultados r JOIN patinadores p ON p.id=r.patinador_id
                     WHERE r.confirmado=1 AND r.total_final IS NOT NULL
                     GROUP BY p.id,p.nome,p.pais,p.foto
                     ORDER BY participacoes DESC, valor DESC, p.nome ASC LIMIT 1",
    'short' => "SELECT p.nome, p.pais, p.foto, c.nome campeonato,
                (COALESCE(r.programa_curto_tes,0)+COALESCE(r.programa_curto_pcs,0)-COALESCE(r.programa_curto_deducoes,0)) valor
                FROM resultados r JOIN patinadores p ON p.id=r.patinador_id
                JOIN campeonatos c ON c.id=r.campeonato_id
                WHERE r.confirmado=1
                ORDER BY valor DESC, p.nome ASC LIMIT 1"
];
foreach ($awardQueries as $key => $sql) {
    $awards[$key] = $pdo->query($sql)->fetch() ?: null;
}

$results = $pdo->query("SELECT r.id,r.total_final,r.atualizado_em,p.nome patinador,p.pais,p.foto,p.disciplina,
                               c.nome campeonato,c.categoria,c.data_inicio,c.data_fim
                        FROM resultados r
                        JOIN patinadores p ON p.id=r.patinador_id
                        JOIN campeonatos c ON c.id=r.campeonato_id
                        WHERE r.confirmado=1
                        ORDER BY c.data_inicio DESC,r.total_final DESC,p.nome ASC")->fetchAll();

$selectedId = isset($_GET['resultado']) ? (int)$_GET['resultado'] : 0;
$sheet = null;
if ($selectedId > 0) {
    $stmt = $pdo->prepare("SELECT r.*,p.nome patinador,p.pais,p.foto,p.disciplina,c.nome campeonato,
                                  c.cidade,c.pais pais_evento,c.data_inicio,c.data_fim,c.categoria
                           FROM resultados r
                           JOIN patinadores p ON p.id=r.patinador_id
                           JOIN campeonatos c ON c.id=r.campeonato_id
                           WHERE r.id=? AND r.confirmado=1 LIMIT 1");
    $stmt->execute([$selectedId]);
    $sheet = $stmt->fetch() ?: null;
}

$fmt = static fn($value) => number_format((float)$value, 2, '.', '');
$pageTitle = 'Prêmios & Súmulas';
require 'includes/header.php';
?>
<div class="page-intro awards-intro">
    <span class="eyebrow">ICE SKATING · SEASON HIGHLIGHTS</span>
    <h1>O brilho por trás de cada <em>apresentação.</em></h1>
    <p>Uma celebração dos destaques da temporada e um espaço para consultar as súmulas detalhadas das apresentações confirmadas.</p>
</div>

<section class="awards-hero">
    <div>
        <span class="eyebrow">HALL OF FAME · ISU</span>
        <h2>Grandes momentos<br>merecem <em>reconhecimento.</em></h2>
        <p>Os prêmios são calculados automaticamente a partir dos resultados confirmados cadastrados no sistema.</p>
        <a class="btn btn-light" href="#premios">Conhecer os destaques ↓</a>
    </div>
    <div class="awards-ornament" aria-hidden="true"><span>✦</span><b>ISU</b><small>EXCELLENCE ON ICE</small></div>
</section>

<div class="section-heading" id="premios">
    <div><span class="eyebrow">SEASON AWARDS</span><h2>Prêmios da temporada</h2></div>
    <span class="season-tag">RESULTADOS CONFIRMADOS</span>
</div>
<div class="award-grid">
    <?php
    $awardMeta = [
        'overall' => ['✦','Maior pontuação','Melhor total combinado'],
        'technical' => ['◈','Destaque técnico','Maior soma de TES'],
        'components' => ['❋','Excelência artística','Maior soma de PCS'],
        'consistent' => ['∞','Consistência','Mais participações confirmadas'],
        'short' => ['✧','Programa curto','Maior nota no segmento curto']
    ];
    foreach ($awardMeta as $key => $meta): $winner = $awards[$key]; ?>
        <article class="award-card <?= $key==='overall'?'award-featured':'' ?>">
            <div class="award-card-top"><span class="award-symbol"><?= e($meta[0]) ?></span><span class="award-kicker">ISU AWARD</span></div>
            <div class="award-label"><?= e($meta[1]) ?></div>
            <?php if ($winner): ?>
                <div class="award-winner-row">
                    <?php if (!empty($winner['foto'])): ?><img src="<?= e($winner['foto']) ?>" alt="Foto de <?= e($winner['nome']) ?>"><?php endif; ?>
                    <div><h3><?= e($winner['nome']) ?></h3><small><?= e($winner['pais']) ?></small></div>
                </div>
                <strong class="award-score"><?= $key==='consistent' ? (int)$winner['participacoes'].' eventos' : $fmt($winner['valor']).' pts' ?></strong>
                <p><?= e($meta[2]) ?><?php if (!empty($winner['campeonato'])): ?> · <?= e($winner['campeonato']) ?><?php endif; ?></p>
            <?php else: ?>
                <div class="award-empty">Aguardando resultados confirmados</div>
                <p><?= e($meta[2]) ?></p>
            <?php endif; ?>
        </article>
    <?php endforeach; ?>
</div>

<div class="section-heading sheet-heading" id="sumulas">
    <div><span class="eyebrow">OFFICIAL SCORE BREAKDOWN</span><h2>Súmulas das apresentações</h2></div>
    <span class="season-tag">DETALHAMENTO DE NOTAS</span>
</div>
<p class="sheet-intro">Selecione uma apresentação para consultar TES, PCS, deduções e o total de cada programa. Somente resultados confirmados aparecem nesta seção.</p>

<?php if ($sheet): ?>
<section class="score-sheet">
    <div class="sheet-titlebar">
        <div><span class="eyebrow">COMPETITION SCORE SHEET</span><h3><?= e($sheet['patinador']) ?></h3><p><?= e($sheet['campeonato']) ?> · <?= e($sheet['disciplina']) ?></p></div>
        <div class="sheet-total"><small>TOTAL FINAL</small><strong><?= $fmt($sheet['total_final']) ?></strong></div>
    </div>
    <div class="sheet-athlete">
        <?php if ($sheet['foto']): ?><img src="<?= e($sheet['foto']) ?>" alt="Foto de <?= e($sheet['patinador']) ?>"><?php endif; ?>
        <div><b><?= e($sheet['pais']) ?></b><small><?= e($sheet['categoria']) ?> · <?= date('d/m/Y',strtotime($sheet['data_inicio'])) ?></small></div>
        <span class="confirmed-tag">✓ CONFIRMADO</span>
    </div>
    <div class="segment-grid">
        <?php
        $segments = [
            ['Programa curto','programa_curto_tes','programa_curto_pcs','programa_curto_deducoes'],
            ['Programa livre','programa_livre_tes','programa_livre_pcs','programa_livre_deducoes']
        ];
        foreach ($segments as $segment):
            $segmentTotal = (float)$sheet[$segment[1]] + (float)$sheet[$segment[2]] - (float)$sheet[$segment[3]];
        ?>
        <article class="segment-card">
            <span class="eyebrow">SEGMENT RESULT</span><h4><?= e($segment[0]) ?></h4>
            <div class="segment-line"><span>TES · Elementos técnicos</span><b><?= $fmt($sheet[$segment[1]]) ?></b></div>
            <div class="segment-line"><span>PCS · Componentes do programa</span><b><?= $fmt($sheet[$segment[2]]) ?></b></div>
            <div class="segment-line deduction"><span>Deduções</span><b>− <?= $fmt($sheet[$segment[3]]) ?></b></div>
            <div class="segment-total"><span>Total do segmento</span><strong><?= $fmt($segmentTotal) ?></strong></div>
        </article>
        <?php endforeach; ?>
    </div>
    <div class="sheet-foot"><span>TES + PCS − deduções = total do segmento</span><a href="premios.php#lista-sumulas">← Voltar à lista</a></div>
</section>
<?php elseif ($selectedId > 0): ?>
    <div class="empty-sheet">Súmula não encontrada ou resultado ainda não confirmado. <a href="premios.php#lista-sumulas">Voltar à lista</a></div>
<?php endif; ?>

<div class="table-card score-list" id="lista-sumulas">
    <div class="table-top"><div><b>Apresentações disponíveis</b><small><?= count($results) ?> resultado(s) confirmado(s)</small></div><span class="season-tag">SÚMULAS</span></div>
    <?php if ($results): ?>
    <div class="table-scroll"><table><thead><tr><th>ATLETA</th><th>CAMPEONATO</th><th>DISCIPLINA</th><th>NOTA FINAL</th><th>SÚMULA</th></tr></thead><tbody>
    <?php foreach ($results as $r): ?>
        <tr><td><div class="sheet-athlete-mini"><?php if ($r['foto']): ?><img src="<?= e($r['foto']) ?>" alt=""><?php endif; ?><b><?= e($r['patinador']) ?></b></div></td><td><?= e($r['campeonato']) ?></td><td><?= e($r['disciplina']) ?></td><td class="score-cell"><?= $fmt($r['total_final']) ?></td><td><a class="sheet-link" href="premios.php?resultado=<?= (int)$r['id'] ?>#sumulas">Ver súmula ↗</a></td></tr>
    <?php endforeach; ?>
    </tbody></table></div>
    <?php else: ?><div class="empty-sheet">Ainda não há resultados confirmados para gerar as súmulas. O administrador pode lançar e confirmar notas na página Administração.</div><?php endif; ?>
</div>
<div class="note-box awards-note"><b>Observação:</b> esta é uma página demonstrativa do projeto. Os prêmios e as súmulas são calculados com os valores cadastrados no banco de dados; não substituem os protocolos oficiais nem o julgamento da ISU.</div>
<?php require 'includes/footer.php'; ?>
