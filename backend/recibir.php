<?php
/**
 * BeeStation Estudio — endpoint mínimo que recibe JSON y lo guarda en un archivo.
 * No usa base de datos a propósito: cuanto menos, menos se rompe en el aula.
 */

declare(strict_types=1);

// XAMPP viene con serialize_precision=100, que imprime 62.1000000000000014...
// -1 = la representacion mas corta que revierte exacto (62.1).
ini_set('serialize_precision', '-1');
ini_set('precision', '-1');

header('Content-Type: application/json; charset=utf-8');

// Campos que aceptamos. Si llega otro, se ignora en vez de rechazar todo.
$permitidos = ['sensor', 'temperatura', 'humedad', 'peso', 'presion', 'co2', 'luz', 'sonido', 'nota'];

$cuerpo = file_get_contents('php://input');
$datos  = json_decode($cuerpo, true);

if (!is_array($datos)) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'El cuerpo no es un JSON valido'], JSON_UNESCAPED_UNICODE);
    exit;
}

$limpio = [];
foreach ($permitidos as $clave) {
    if (!isset($datos[$clave])) {
        continue;
    }
    $valor = $datos[$clave];
    if (is_int($valor) || is_float($valor) || (is_string($valor) && is_numeric($valor))) {
        // Redondeamos a 3 decimales: evita basura de coma flotante en el JSON
        // (depende de serialize_precision del php.ini de cada equipo).
        $limpio[$clave] = is_int($valor) ? $valor : round($valor + 0, 3);
    } elseif (is_string($valor)) {
        $limpio[$clave] = mb_substr($valor, 0, 60, 'UTF-8');
    }
}

if ($limpio === []) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Ningun campo reconocido. Envia: ' . implode(', ', $permitidos)], JSON_UNESCAPED_UNICODE);
    exit;
}

$limpio['fecha'] = date('Y-m-d');
$limpio['hora']  = date('H:i:s');

$ruta  = __DIR__ . '/datos/lecturas.json';
$tope  = 200; // nunca guardamos mas de 200 lecturas

$fp = fopen($ruta, 'c+');
if ($fp === false) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'No se pudo abrir datos/lecturas.json'], JSON_UNESCAPED_UNICODE);
    exit;
}

flock($fp, LOCK_EX);
$crudo  = stream_get_contents($fp);
$lista  = $crudo ? json_decode($crudo, true) : [];
if (!is_array($lista)) {
    $lista = [];
}

$lista[] = $limpio;
if (count($lista) > $tope) {
    $lista = array_slice($lista, -$tope);
}

ftruncate($fp, 0);
rewind($fp);
fwrite($fp, json_encode($lista, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
fflush($fp);
flock($fp, LOCK_UN);
fclose($fp);

http_response_code(201);
echo json_encode([
    'ok'       => true,
    'recibido' => $limpio,
    'total'    => count($lista),
    'archivo'  => 'datos/lecturas.json',
], JSON_UNESCAPED_UNICODE);
