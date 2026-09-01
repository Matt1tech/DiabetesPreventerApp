$ErrorActionPreference = 'Stop'

$forbiddenTrackedPatterns = @(
    '^\.private/',
    '(^|/)\.env$',
    '(^|/)media/',
    '(^|/)FYPsubmited/',
    '\.(pkl|joblib|sqlite3|sqbpro)$',
    '(^|/)dump\.sql$',
    '(^|/)config\.yml$'
)

$tracked = @(git ls-files)
foreach ($file in $tracked) {
    foreach ($pattern in $forbiddenTrackedPatterns) {
        if ($file -match $pattern) {
            throw "Forbidden public file is tracked: $file"
        }
    }
}

$secretPatterns = @(
    'django-insecure-',
    'Authorization\s*[:=].*Api-Key\s+[A-Za-z0-9._-]{20,}',
    '(?i)(api[_-]?key|secret[_-]?key|password)\s*[:=]\s*["''][^"'']{12,}["'']'
)

$textExtensions = @('.py', '.dart', '.yml', '.yaml', '.json', '.md', '.toml', '.ps1')
foreach ($file in $tracked) {
    if ($file -eq 'scripts/check_public_tree.ps1') { continue }
    if ([System.IO.Path]::GetExtension($file) -notin $textExtensions) { continue }
    $content = Get-Content -LiteralPath $file -Raw -ErrorAction SilentlyContinue
    foreach ($pattern in $secretPatterns) {
        if ($content -match $pattern) {
            throw "Possible committed secret pattern in: $file"
        }
    }
}

Write-Host 'Public-tree checks passed.'
