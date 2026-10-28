# Recreate the PNG with Windows' built-in drawing library; no downloaded assets.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = Split-Path $PSScriptRoot -Parent
$destination = Join-Path $root 'docs/assets/smart-folder-overview.png'
[IO.Directory]::CreateDirectory((Split-Path $destination)) | Out-Null
$bitmap = New-Object Drawing.Bitmap(1800, 1420)
$g = [Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([Drawing.Color]::White)
$navy = [Drawing.ColorTranslator]::FromHtml('#163749')
$teal = [Drawing.ColorTranslator]::FromHtml('#087E8B')
$muted = [Drawing.ColorTranslator]::FromHtml('#425563')
function Label($text, $x, $y, $width, $height, $size, $color, $bold = $false, $center = $false) {
    $style = if ($bold) { [Drawing.FontStyle]::Bold } else { [Drawing.FontStyle]::Regular }
    $font = New-Object Drawing.Font('Segoe UI', $size, $style, [Drawing.GraphicsUnit]::Pixel)
    $brush = New-Object Drawing.SolidBrush($color)
    $format = New-Object Drawing.StringFormat
    if ($center) { $format.Alignment = [Drawing.StringAlignment]::Center }
    $g.DrawString($text, $font, $brush, (New-Object Drawing.RectangleF($x,$y,$width,$height)), $format)
    $font.Dispose(); $brush.Dispose(); $format.Dispose()
}
function Box($x,$y,$width,$height,$fill,$stroke) {
    $brush = New-Object Drawing.SolidBrush([Drawing.ColorTranslator]::FromHtml($fill))
    $pen = New-Object Drawing.Pen([Drawing.ColorTranslator]::FromHtml($stroke), 3)
    $g.FillRectangle($brush,$x,$y,$width,$height)
    $g.DrawRectangle($pen,$x,$y,$width,$height)
    $brush.Dispose(); $pen.Dispose()
}
function Arrow($x1,$y1,$x2,$y2) {
    $pen = New-Object Drawing.Pen($teal, 5)
    $pen.CustomEndCap = New-Object Drawing.Drawing2D.AdjustableArrowCap(5,7)
    $g.DrawLine($pen,$x1,$y1,$x2,$y2)
    $pen.Dispose()
}
Label 'A SMART FOLDER?' 90 45 1620 75 58 $navy $true $true
Label 'Files + working context + recorded connections' 90 125 1620 55 32 $muted $false $true
Box 100 225 1600 420 '#F1F7F8' '#8AB3BB'
Label 'PROJECT FOLDER' 140 245 1520 50 29 $teal $true $true
$columns = @(
    @{X=160;Title='THE WORK';Body="Documents`nCode`nSources"},
    @{X=690;Title='HOW WE WORK';Body="Instructions`nResponsibilities`nBoundaries"},
    @{X=1220;Title='HOW IT DEVELOPED';Body="Discussions`nDecisions`nOpen questions"}
)
foreach ($column in $columns) {
    Label $column.Title $column.X 325 430 48 28 $navy $true
    Label $column.Body $column.X 390 430 160 32 $muted
}
Label 'Explicit links connect these records' 150 570 1500 50 30 $teal $true $true
Arrow 900 650 900 710
Arrow 850 710 850 650
Box 390 725 1020 125 '#FFFFFF' '#087E8B'
Label 'HUMAN + AI ASSISTANT' 420 760 960 65 39 $navy $true $true
Label 'Where did this idea come from?    What changed - and why?' 150 880 1500 55 29 $muted $false $true
Label 'What should we revisit?' 150 930 1500 50 29 $muted $false $true
Arrow 900 990 900 1040
Box 460 1055 880 105 '#F1F7F8' '#087E8B'
Label 'HUMAN REVIEW & CHOICE' 490 1083 820 60 36 $navy $true $true
Arrow 1340 1108 1660 1108
Arrow 1660 1108 1660 650
Label "Selected updates`nreturn to the folder" 1360 900 270 110 27 $teal $true $true
Label 'People decide what to preserve.' 100 1230 1600 55 33 $navy $true $true
Label 'Checks catch some inconsistencies. The record remains incomplete.' 100 1290 1600 60 29 $muted $false $true
$bitmap.Save($destination,[Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bitmap.Dispose()
Write-Output $destination
