Add-Type -AssemblyName System.Drawing

$resDir = Join-Path $PSScriptRoot 'zuno_app\android\app\src\main\res'

$densities = @{
    'mipmap-mdpi'    = 48
    'mipmap-hdpi'    = 72
    'mipmap-xhdpi'   = 96
    'mipmap-xxhdpi'  = 144
    'mipmap-xxxhdpi' = 192
}

foreach ($folder in $densities.Keys) {
    $size = $densities[$folder]
    $dir = Join-Path $resDir $folder
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    # Rounded-rect path helper
    $radius = [int]($size * 0.22)
    $rect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($rect.X, $rect.Y, $radius, $radius, 180, 90)
    $path.AddArc($rect.Right - $radius, $rect.Y, $radius, $radius, 270, 90)
    $path.AddArc($rect.Right - $radius, $rect.Bottom - $radius, $radius, $radius, 0, 90)
    $path.AddArc($rect.X, $rect.Bottom - $radius, $radius, $radius, 90, 90)
    $path.CloseAllFigures()

    # Cyber gradient background: purple -> cyan -> pink
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, `
        [System.Drawing.Color]::FromArgb(255, 108, 92, 231), `
        [System.Drawing.Color]::FromArgb(255, 0, 245, 212), 45)
    $g.FillPath($brush, $path)

    # Draw bold "Z" letter centered
    $fontSize = [int]($size * 0.55)
    $font = New-Object System.Drawing.Font('Segoe UI', $fontSize, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rectF = New-Object System.Drawing.RectangleF(0, 0, $size, $size)
    $g.DrawString('Z', $font, $textBrush, $rectF, $sf)

    $outPath = Join-Path $dir 'ic_launcher.png'
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $g.Dispose(); $bmp.Dispose(); $path.Dispose(); $brush.Dispose(); $font.Dispose(); $textBrush.Dispose(); $sf.Dispose()
    Write-Host "Created $outPath ($size x $size)"
}

Write-Host 'Done generating launcher icons.'
