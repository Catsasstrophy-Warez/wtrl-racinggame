#
# RVP Unity 2019.4 -> Unity 6 API migration script, PowerShell port.
#
# HONESTY NOTE, READ FIRST: migrate-to-unity6.sh (the bash original) was
# actually run against a disposable RVP checkout and verified clean --
# zero old-pattern hits remaining, zero corruption, a spot-checked diff
# confirming every change was exactly the intended one-line rename
# (racinggameideas/code/prototype/RVP-TRIAGE.md).
#
# THIS PORT HAS NOT BEEN RUN ANYWHERE IN THIS PROJECT. It is a direct
# translation of the same regex logic, written and reasoned through, not
# tested against a real checkout -- the same status as the C# prototype
# code generally (written and reviewed, not compiled/run). Prefer Git
# Bash or WSL running the original .sh script if either is available on
# this machine; use this only when neither is an option, and treat its
# first real run as the actual test of it, the same way the Unity build
# itself is the real test of everything else in this package.
#
# Covers the same 27 confirmed call sites across 13 files as the bash
# original:
#   - Rigidbody.velocity        -> Rigidbody.linearVelocity     (19 sites)
#   - Rigidbody.drag            -> Rigidbody.linearDamping      (1 site)
#   - Rigidbody.angularDrag     -> Rigidbody.angularDamping     (4 sites)
#   - FindObjectOfType<T>()     -> FindFirstObjectByType<T>()   (3 sites)
#
# NOT included: Rigidbody.angularVelocity was NOT renamed in Unity 6 and
# needs no change -- patterns below are written to avoid matching it,
# same as the bash original.
#
# Usage:
#   cd <your RVP checkout>
#   .\migrate-to-unity6.ps1 -TargetDir "Assets\Scripts"
#
# Dry-run first: prints every change it would make, then asks for
# confirmation (Y/N) before touching any file. Only edits *.cs files
# under -TargetDir.

param(
    [string]$TargetDir = "Assets\Scripts"
)

if (-not (Test-Path $TargetDir)) {
    Write-Host "Error: '$TargetDir' not found. Run this from the RVP project root," -ForegroundColor Red
    Write-Host "or pass -TargetDir pointing at the scripts directory." -ForegroundColor Red
    exit 1
}

Write-Host "=== RVP Unity 6 migration (PowerShell port): dry run ===" -ForegroundColor Cyan
Write-Host "Scanning: $TargetDir`n"

# Same patterns as the bash original. .NET regex, not POSIX -- syntax
# differs slightly but the matched text is identical.
$patterns = @{
    '\.velocity\b(?!ChangeMode)' = '.linearVelocity'
    '\.angularDrag\b'            = '.angularDamping'  # must run before the plain .drag pattern below,
                                                         # same ordering note as the bash original --
                                                         # in practice the boundary makes order not
                                                         # actually matter, kept for readability parity
    '\.drag\b'                   = '.linearDamping'
}

$csFiles = Get-ChildItem -Path $TargetDir -Filter "*.cs" -Recurse
$totalHits = 0
$filesSummary = @{}

foreach ($file in $csFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $fileHits = 0

    foreach ($pattern in $patterns.Keys) {
        $matches = [regex]::Matches($content, $pattern)
        if ($matches.Count -gt 0) {
            $replacement = $patterns[$pattern]
            Write-Host "  $($file.FullName): $($matches.Count) occurrence(s) matching '$pattern' -> '$replacement'"
            $fileHits += $matches.Count
        }
    }

    $fotMatches = [regex]::Matches($content, 'FindObjectOfType<')
    if ($fotMatches.Count -gt 0) {
        Write-Host "  $($file.FullName): $($fotMatches.Count) occurrence(s) of FindObjectOfType<T>() -> FindFirstObjectByType<T>()"
        $fileHits += $fotMatches.Count
    }

    if ($fileHits -gt 0) {
        $filesSummary[$file.FullName] = $fileHits
        $totalHits += $fileHits
    }
}

Write-Host "`nTotal: $totalHits call sites across $($filesSummary.Count) file(s) listed above.`n"

$confirm = Read-Host "Apply these changes now? [y/N]"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Aborted. No files changed."
    exit 0
}

Write-Host "`n=== Applying ===" -ForegroundColor Cyan

foreach ($file in $csFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $original = $content

    # angularDrag before drag, matching the bash original's ordering,
    # for parity even though the word-boundary regex makes order not
    # actually matter for correctness here.
    $content = [regex]::Replace($content, '\.velocity\b(?!ChangeMode)', '.linearVelocity')
    $content = [regex]::Replace($content, '\.angularDrag\b', '.angularDamping')
    $content = [regex]::Replace($content, '\.drag\b', '.linearDamping')
    $content = [regex]::Replace($content, 'FindObjectOfType<', 'FindFirstObjectByType<')

    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
    }
}

Write-Host "Done. $totalHits call sites updated across $($filesSummary.Count) file(s)." -ForegroundColor Green
Write-Host ""
Write-Host "This script does NOT touch the tire shaders -- those need Tire-URP.shader,"
Write-Host "pasted in by hand per 46-TONIGHT-BUILD-SESSION.md Step 2."
Write-Host ""
Write-Host "Next: open the project in Unity 6 and let the compiler find anything this"
Write-Host "script missed. Unlike the bash original, THIS RUN IS THE FIRST TIME THIS"
Write-Host "SCRIPT HAS EVER EXECUTED -- verify its output more carefully than you would"
Write-Host "the tested version. A git diff review before committing is strongly" -ForegroundColor Yellow
Write-Host "recommended for this specific run." -ForegroundColor Yellow
