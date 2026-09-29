<?php
declare(strict_types=1);
$ruta = __DIR__ . '/datos/lecturas.json';
$lecturas = [];
if (is_readable($ruta)) {
    $crudo = file_get_contents($ruta);
    $tmp = $crudo ? json_decode($crudo, true) : [];
    if (is_array($tmp)) {
        $lecturas = $tmp;
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>BeeStation · Dashboard</title>
<style>
  :root { --fondo:#0f172a; --tarjeta:#1e293b; --texto:#e2e8f0; --tenue:#94a3b8; --mIEL:#f59e0b; --verde:#22c55e; --azul:#38bdf8; }
  * { box-sizing:border-box; }
  body { margin:0; font:16px/1.5 system-ui,-apple-system,Segoe UI,Roboto,sans-serif;
         background:var(--fondo); color:var(--texto); padding:24px; }
  h1 { font-size:22px; margin:0 0 4px; }
  .sub { color:var(--tenue); font-size:14px; margin-bottom:24px; }
  .karts { display:flex; gap:16px; flex-wrap:wrap; margin-bottom:24px; }
  .karta { background:var(--tarjeta); border-radius:12px; padding:16px 20px; min-width:150px; flex:1; }
  .karta .v { font-size:34px; font-weight:700; }
  .karta .l { color:var(--tenue); font-size:13px; text-transform:uppercase; letter-spacing:.05em; }
  .karta.t .v { color:var(--azul); }
  .karta.h .v { color:var(--verde); }
  .karta.n .v { color:var(--mIEL); }
  .panel { background:var(--tarjeta); border-radius:12px; padding:20px; }
  canvas { width:100%; height:280px; display:block; }
  .pie { display:flex; gap:20px; flex-wrap:wrap; margin-top:14px; font-size:13px; color:var(--tenue); }
  .pie b { color:var(--texto); font-weight:600; }
  .punto { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
  .estado { font-size:13px; color:var(--tenue); margin-top:16px; }
  .vacio { color:var(--tenue); text-align:center; padding:60px 0; }
</style>
</head>
<body>
  <h1>🐝 BeeStation — Dashboard</h1>
  <div class="sub">Datos del ESP32 virtual (Wokwi) recibidos por <code>recibir.php</code></div>

  <div class="karts">
    <div class="karta t"><div class="l">Temperatura</div><div class="v" id="k-temp">—</div></div>
    <div class="karta h"><div class="l">Humedad</div><div class="v" id="k-hum">—</div></div>
    <div class="karta n"><div class="l">Lecturas</div><div class="v" id="k-n">0</div></div>
  </div>

  <div class="panel">
    <canvas id="grafica" width="900" height="280"></canvas>
    <div class="pie">
      <span><span class="punto" style="background:#38bdf8"></span>Temperatura (°C)</span>
      <span><span class="punto" style="background:#22c55e"></span>Humedad (%)</span>
      <span id="ultimo"></span>
    </div>
    <div class="estado" id="estado">Cargando…</div>
  </div>

<script>
const cv = document.getElementById('grafica');
const ctx = cv.getContext('2d');
let datos = [];

function leer() {
  fetch('datos/lecturas.json?t=' + Date.now())
    .then(r => r.ok ? r.json() : [])
    .then(d => { datos = Array.isArray(d) ? d : []; pintar(); })
    .catch(() => { document.getElementById('estado').textContent =
      'No se pudo leer datos/lecturas.json. ¿Está corriendo iniciar.sh?'; });
}

function pintar() {
  document.getElementById('k-n').textContent = datos.length;

  if (datos.length) {
    const ult = datos[datos.length - 1];
    document.getElementById('k-temp').textContent = (ult.temperatura ?? '—') + ' °C';
    document.getElementById('k-hum').textContent  = (ult.humedad  ?? '—') + ' %';
    document.getElementById('ultimo').textContent  = 'Último: ' + (ult.hora ?? '');
    document.getElementById('estado').textContent  = 'Actualizando cada 2 s · ' + datos.length + ' lecturas';
  }

  const serie = datos.filter(d => d.temperatura != null && d.humedad != null);
  if (!serie.length) {
    document.getElementById('estado').textContent =
      'Sin lecturas todavía. Ejecuta e03-datos y asegúrate de que devuelva HTTP 201.';
    return;
  }

  const W = cv.width, H = cv.height, pad = 40;
  ctx.clearRect(0, 0, W, H);
  ctx.fillStyle = '#0f172a';
  ctx.fillRect(0, 0, W, H);

  // eje Y 0..100 (cubre °C y %)
  ctx.strokeStyle = '#334155';
  ctx.fillStyle = '#64748b';
  ctx.font = '12px system-ui';
  ctx.lineWidth = 1;
  for (let v = 0; v <= 100; v += 25) {
    const y = H - pad - (v / 100) * (H - pad * 2);
    ctx.beginPath(); ctx.moveTo(pad, y); ctx.lineTo(W - 10, y); ctx.stroke();
    ctx.fillText(v, 8, y + 4);
  }

  const n = serie.length;
  const paso = n > 1 ? (W - pad - 10) / (n - 1) : 0;
  const px = i => pad + i * paso;
  const py = v => H - pad - (Math.max(0, Math.min(100, v)) / 100) * (H - pad * 2);

  function linea(campo, color) {
    ctx.strokeStyle = color; ctx.lineWidth = 2.5;
    ctx.beginPath();
    serie.forEach((d, i) => {
      const y = py(Number(d[campo]));
      i === 0 ? ctx.moveTo(px(i), y) : ctx.lineTo(px(i), y);
    });
    ctx.stroke();
    ctx.fillStyle = color;
    serie.forEach((d, i) => {
      ctx.beginPath(); ctx.arc(px(i), py(Number(d[campo])), 3, 0, Math.PI * 2); ctx.fill();
    });
  }

  linea('temperatura', '#38bdf8');
  linea('humedad', '#22c55e');
}

pintar();
setInterval(leer, 2000);
</script>
</body>
</html>
