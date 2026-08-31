# Генерация иконок расширения "Bookmarks Grid View"
# Дизайн: синий скруглённый квадрат, белая сетка 2x2, закладка в ячейке.
# Запуск: powershell -ExecutionPolicy Bypass -File scripts/generate_icons.ps1

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

$outDir = Join-Path (Join-Path $PSScriptRoot '..') 'icons'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

# Базовый размер для отрисовки (выше -> качественнее сглаживание при уменьшении)
$base = 256
$sizes = 16, 32, 48, 128

$bmp = [System.Drawing.Bitmap]::new([int]$base, [int]$base)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$g.Clear([System.Drawing.Color]::Transparent)

# Палитра
$blue = [System.Drawing.Color]::FromArgb(255, 0, 91, 173)   # #005BAD
$blueLight = [System.Drawing.Color]::FromArgb(255, 0, 123, 255)  # #007BFF (акцент)
$white = [System.Drawing.Color]::White

# Скруглённый прямоугольник (Path)
function New-RoundedRectPath([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = [single]($r * 2)
    $path.AddArc([single]$x, [single]$y, [single]$d, [single]$d, 180, 90)
    $path.AddArc([single]($x + $w - $d), [single]$y, [single]$d, [single]$d, 270, 90)
    $path.AddArc([single]($x + $w - $d), [single]($y + $h - $d), [single]$d, [single]$d, 0, 90)
    $path.AddArc([single]$x, [single]($y + $h - $d), [single]$d, [single]$d, 90, 90)
    $path.CloseFigure()
    return $path
}

# --- Фон: скруглённый синий квадрат с лёгким градиентом ---
$bgRect = [System.Drawing.RectangleF]::new(
    [single]8, [single]8,
    [single]($base - 16), [single]($base - 16))
$bgPath = New-RoundedRectPath $bgRect.X $bgRect.Y $bgRect.Width $bgRect.Height 48

$gradBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $bgRect, $blue, $blueLight, [single]135.0)
$g.FillPath($gradBrush, $bgPath)

# --- Сетка 2x2 поверх фона ---
$inner = [single]($base - 48)        # отступы по 24
$cell = [single](($inner - 16) / 2) # зазор между ячейками 16
$ox = [single](($base - $inner) / 2)
$oy = [single](($base - $inner) / 2)

$gridPen = [System.Drawing.Pen]::new($white, [single]8)
$gridPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$gridPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$gridPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

# Горизонтальная и вертикальная линии сетки
$g.DrawLine($gridPen, [single]($ox + $cell + 8), [single]$oy, [single]($ox + $cell + 8), [single]($oy + $inner))
$g.DrawLine($gridPen, [single]$ox, [single]($oy + $cell + 8), [single]($ox + $inner), [single]($oy + $cell + 8))

# --- Закладка в левой верхней ячейке ---
$bx = [single]($ox + 22)
$by = [single]($oy + 18)
$bw = [single]($cell - 44)
$bh = [single]($cell - 36)

$foldPen = [System.Drawing.Pen]::new($white, [single]14)
$foldPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$foldPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$foldPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

# Контур закладки
$foldPoints = @(
    [System.Drawing.PointF]::new([single]$bx, [single]$by),
    [System.Drawing.PointF]::new([single]$bx, [single]($by + $bh)),
    [System.Drawing.PointF]::new([single]($bx + $bw * 0.5), [single]($by + $bh - $bw * 0.28)),
    [System.Drawing.PointF]::new([single]($bx + $bw), [single]($by + $bh)),
    [System.Drawing.PointF]::new([single]($bx + $bw), [single]$by)
)
$g.DrawLines($foldPen, $foldPoints)

$g.Dispose()

# --- Сохранение в нужных размерах ---
foreach ($size in $sizes) {
    $out = [System.Drawing.Bitmap]::new([int]$size, [int]$size)
    $gg = [System.Drawing.Graphics]::FromImage($out)
    $gg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $gg.Clear([System.Drawing.Color]::Transparent)
    $gg.DrawImage($bmp, 0, 0, [int]$size, [int]$size)
    $gg.Dispose()

    $file = Join-Path $outDir "icon$size.png"
    $out.Save($file, [System.Drawing.Imaging.ImageFormat]::Png)
    $out.Dispose()
    Write-Host "Created: $file"
}

$bmp.Dispose()
Write-Host "Done. Icons saved to: $outDir"