param(
    [ValidateSet('focused','complete')][string]$Profile = 'focused',
    [ValidateRange(1024,65535)][int]$Port = 7188
)
# Read-only static browsing. Run a Quarto render separately to update the files.
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Join-Path (Split-Path $PSScriptRoot -Parent) "_site-$Profile"))
if (-not (Test-Path -LiteralPath (Join-Path $root 'index.html'))) {
    throw "Render the $Profile profile first."
}
$listener = New-Object Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$types = @{'.html'='text/html; charset=utf-8';'.css'='text/css';'.js'='application/javascript';'.json'='application/json';'.png'='image/png';'.svg'='image/svg+xml';'.woff2'='font/woff2';'.jpg'='image/jpeg';'.ico'='image/x-icon'}
try {
    $listener.Start()
    Write-Output "Static $Profile site: http://localhost:$Port/ (Ctrl+C to stop)"
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        try {
            $relative = [Uri]::UnescapeDataString($context.Request.Url.AbsolutePath).TrimStart('/')
            if (-not $relative) { $relative = 'index.html' }
            $file = [IO.Path]::GetFullPath((Join-Path $root $relative))
            if (-not $file.StartsWith($root + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
                $context.Response.StatusCode = 403
            } elseif (-not [IO.File]::Exists($file)) {
                $context.Response.StatusCode = 404
            } else {
                $extension = [IO.Path]::GetExtension($file).ToLowerInvariant()
                $context.Response.ContentType = if ($types.ContainsKey($extension)) { $types[$extension] } else { 'application/octet-stream' }
                $bytes = [IO.File]::ReadAllBytes($file)
                $context.Response.ContentLength64 = $bytes.Length
                $context.Response.OutputStream.Write($bytes,0,$bytes.Length)
            }
        } finally { $context.Response.Close() }
    }
} finally { $listener.Close() }
