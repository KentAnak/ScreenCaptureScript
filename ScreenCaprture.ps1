Add-Type -AssemblyName System.Windows.Forms
[Console]::WindowWidth = 100

#### Please specify 3 parameters.
$waitSecond = 4 #Specify the wait time.
$screenNo = 0 #If multiple displays are connected, specify the number.
$scaleFactor = 1 #Set the scale factor for a high DPI display.

Write-Host "Capture interval is $waitSecond seconds (+ image processing time)."
$screens = [System.Windows.Forms.Screen]::AllScreens
$chosenScreen = $screens[$screenNo] 
Write-Host "Screen $screenNo is chosen."
$screenLines = $chosenScreen -split " "
$screenLines = $screenLines -join "`n"
Write-Host $screenLines

if ($scaleFactor -gt 1) {
    Write-Host "High-resolution display: Using scaled bounds."
    $bounds = $chosenScreen.Bounds
    $bounds.Width = [int]($bounds.Width * $scaleFactor)
    $bounds.Height = [int]($bounds.Height * $scaleFactor)
    $bounds.X = [int]($bounds.X * $scaleFactor)
    $bounds.Y = [int]($bounds.Y * $scaleFactor)
} else {
    Write-Host "Regular display detected: Using regular bounds."
    $bounds = $chosenScreen.Bounds
}
Write-Host "Bounds*Scalse=$bounds"

while ($true) {
    Write-Host "Capturing screenshot at $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))..."
    $bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    $filename = "screenshot_$((Get-Date).ToString('yyyyMMdd_HHmmss')).png"
    $bitmap.Save($filename, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Screenshot saved as $filename"
    Start-Sleep -Seconds $waitSecond
}
