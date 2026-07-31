Add-Type -AssemblyName System.Drawing

$outputPath = Join-Path $PSScriptRoot '..\static\images\5-Workshop\data-engineering-pipeline.png'
$bitmap = New-Object System.Drawing.Bitmap 1600, 900
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$graphics.Clear([System.Drawing.Color]::FromArgb(247, 249, 252))

$titleFont = New-Object System.Drawing.Font 'Segoe UI', 30, ([System.Drawing.FontStyle]::Bold)
$subtitleFont = New-Object System.Drawing.Font 'Segoe UI', 15, ([System.Drawing.FontStyle]::Regular)
$boxTitleFont = New-Object System.Drawing.Font 'Segoe UI', 17, ([System.Drawing.FontStyle]::Bold)
$boxTextFont = New-Object System.Drawing.Font 'Segoe UI', 13, ([System.Drawing.FontStyle]::Regular)
$smallFont = New-Object System.Drawing.Font 'Segoe UI', 11, ([System.Drawing.FontStyle]::Regular)
$darkBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(31, 41, 55))
$mutedBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(75, 85, 99))
$whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
$linePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(71, 85, 105)), 4
$linePen.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor

function Draw-Box {
    param(
        [int]$X, [int]$Y, [int]$Width, [int]$Height,
        [string]$Title, [string]$Text,
        [System.Drawing.Color]$Fill, [System.Drawing.Color]$Stroke
    )
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $radius = 18
    $diameter = $radius * 2
    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc($X + $Width - $diameter, $Y, $diameter, $diameter, 270, 90)
    $path.AddArc($X + $Width - $diameter, $Y + $Height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($X, $Y + $Height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    $fillBrush = New-Object System.Drawing.SolidBrush $Fill
    $strokePen = New-Object System.Drawing.Pen $Stroke, 3
    $graphics.FillPath($fillBrush, $path)
    $graphics.DrawPath($strokePen, $path)
    $titleRect = New-Object System.Drawing.RectangleF ($X + 18), ($Y + 15), ($Width - 36), 34
    $textRect = New-Object System.Drawing.RectangleF ($X + 18), ($Y + 54), ($Width - 36), ($Height - 62)
    $graphics.DrawString($Title, $boxTitleFont, $darkBrush, $titleRect)
    $graphics.DrawString($Text, $boxTextFont, $mutedBrush, $textRect)
    $fillBrush.Dispose()
    $strokePen.Dispose()
    $path.Dispose()
}

function Draw-Arrow {
    param([int]$X1, [int]$Y1, [int]$X2, [int]$Y2, [string]$Label = '')
    $graphics.DrawLine($linePen, $X1, $Y1, $X2, $Y2)
    if ($Label) {
        $labelRect = New-Object System.Drawing.RectangleF ((($X1 + $X2) / 2) - 80), ((($Y1 + $Y2) / 2) - 28), 160, 24
        $format = New-Object System.Drawing.StringFormat
        $format.Alignment = [System.Drawing.StringAlignment]::Center
        $graphics.DrawString($Label, $smallFont, $mutedBrush, $labelRect, $format)
        $format.Dispose()
    }
}

$graphics.DrawString('E-commerce Interaction Data Engineering Pipeline', $titleFont, $darkBrush, 70, 35)
$graphics.DrawString('Source-verified local and AWS SAM processing flow', $subtitleFont, $mutedBrush, 73, 86)

Draw-Box 70 170 270 150 'Database export ZIP' "interactions.csv`nProducts.json`nitems.csv ignored" ([System.Drawing.Color]::FromArgb(232, 240, 254)) ([System.Drawing.Color]::FromArgb(66, 133, 244))
Draw-Box 430 170 270 150 'Amazon S3' "incoming/*.zip`nPrivate + SSE-S3`nObjectCreated event" ([System.Drawing.Color]::FromArgb(234, 248, 238)) ([System.Drawing.Color]::FromArgb(52, 168, 83))
Draw-Box 790 150 330 190 'Processing Lambda' "Python 3.13 / arm64`nValidate schema, event, time,`nduplicates and product IDs`nPreserve original IDs" ([System.Drawing.Color]::FromArgb(255, 244, 229)) ([System.Drawing.Color]::FromArgb(245, 158, 11))
Draw-Box 1210 90 310 125 'processed/' "interactions_clean.csv`nML-ready handoff" ([System.Drawing.Color]::FromArgb(238, 242, 255)) ([System.Drawing.Color]::FromArgb(99, 102, 241))
Draw-Box 1210 245 310 125 'rejected/' "Invalid rows`nwith rejection reasons" ([System.Drawing.Color]::FromArgb(254, 242, 242)) ([System.Drawing.Color]::FromArgb(239, 68, 68))
Draw-Box 1210 400 310 145 'reports/' "data_quality_report.json`ndata_quality_report.md`nCounts and ID checks" ([System.Drawing.Color]::FromArgb(250, 245, 255)) ([System.Drawing.Color]::FromArgb(168, 85, 247))

Draw-Arrow 340 245 430 245 'upload'
Draw-Arrow 700 245 790 245 'trigger'
Draw-Arrow 1120 205 1210 150
Draw-Arrow 1120 255 1210 305
Draw-Arrow 1120 305 1210 455

Draw-Box 790 450 330 130 'CloudWatch Logs' "Execution and error logs`n7-day retention" ([System.Drawing.Color]::FromArgb(241, 245, 249)) ([System.Drawing.Color]::FromArgb(100, 116, 139))
Draw-Arrow 955 340 955 450 'logs'

Draw-Box 1210 620 310 155 'Downstream ML' "Clean dataset handoff`nAmazon Personalize optional`nAthena verification optional" ([System.Drawing.Color]::FromArgb(236, 253, 245)) ([System.Drawing.Color]::FromArgb(16, 185, 129))
$routePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(71, 85, 105)), 4
$graphics.DrawLine($routePen, 1520, 150, 1560, 150)
$graphics.DrawLine($routePen, 1560, 150, 1560, 697)
$graphics.DrawLine($linePen, 1560, 697, 1520, 697)
$graphics.DrawString('handoff', $smallFont, $mutedBrush, 1495, 405)

$bandBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(229, 231, 235))
$graphics.FillRectangle($bandBrush, 70, 690, 1050, 120)
$graphics.DrawString('Infrastructure as code', $boxTitleFont, $darkBrush, 95, 713)
$graphics.DrawString('AWS SAM / CloudFormation provisions S3, Lambda, IAM permissions, event notification and log retention.', $boxTextFont, $mutedBrush, (New-Object System.Drawing.RectangleF 95, 754, 1000, 45))
$graphics.DrawString('Responsibility boundary: Data Engineering produces validated artifacts; the ML role owns training and evaluation.', $smallFont, $mutedBrush, 75, 842)

$outputDirectory = Split-Path -Parent $outputPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}
$bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$bandBrush.Dispose()
$routePen.Dispose()
$linePen.Dispose()
$whiteBrush.Dispose()
$darkBrush.Dispose()
$mutedBrush.Dispose()
$titleFont.Dispose()
$subtitleFont.Dispose()
$boxTitleFont.Dispose()
$boxTextFont.Dispose()
$smallFont.Dispose()
$graphics.Dispose()
$bitmap.Dispose()
