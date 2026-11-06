# Unify top navigation across all pages (ASCII-only source, Cyrillic built from code points)

function U([int[]]$cp) { -join ($cp | ForEach-Object { [char]$_ }) }

$ruBlog    = U 0x0411, 0x043b, 0x043e, 0x0433                      # Blog (RU)
$ruAuto    = U 0x0410, 0x0432, 0x0442, 0x043e, 0x043c, 0x0430, 0x0442, 0x0438, 0x0437, 0x0430, 0x0446, 0x0438, 0x044f  # Automation (RU)
$ruContact = U 0x041a, 0x043e, 0x043d, 0x0442, 0x0430, 0x043a, 0x0442, 0x044b  # Contacts (RU)

$ind12 = ' ' * 12
$ind16 = ' ' * 16

$enNav = @(
    "$ind12<nav class=`"main-nav`">"
    "$ind16<a href=`"/blog`" class=`"nav-link`">Blog</a>"
    "$ind16<a href=`"/automation.html`" class=`"nav-link`">Automation</a>"
    "$ind16<a href=`"/#contacts`" class=`"nav-link`">Contact</a>"
    "$ind16<a href=`"/ru/`" class=`"nav-link`" style=`"font-weight: bold; color: var(--text-secondary); margin-left: 15px;`">RU</a>"
    "$ind12</nav>"
) -join "`r`n"

$ruNav = @(
    "$ind12<nav class=`"main-nav`">"
    "$ind16<a href=`"/ru/blog`" class=`"nav-link`">$ruBlog</a>"
    "$ind16<a href=`"/ru/automation.html`" class=`"nav-link`">$ruAuto</a>"
    "$ind16<a href=`"/ru/#contacts`" class=`"nav-link`">$ruContact</a>"
    "$ind16<a href=`"/`" class=`"nav-link`" style=`"font-weight: bold; color: var(--text-secondary); margin-left: 15px;`">EN</a>"
    "$ind12</nav>"
) -join "`r`n"

$enc = New-Object System.Text.UTF8Encoding($false)
$root = Get-Location

$enFiles = @('index.html', 'automation.html',
    'blog/index.html', 'blog/reviving-android-cooling-monitor-via-ieee-12207.html',
    'blog/how-i-rewrote-an-android-payment-module.html', 'blog/golden_corn_or_sms.html',
    'blog/from-12-second-friction-to-instant-checkout.html')

$ruFiles = @('ru/index.html', 'ru/automation.html',
    'ru/blog/index.html', 'ru/blog/reviving-android-cooling-monitor-via-ieee-12207.html',
    'ru/blog/how-i-rewrote-an-android-payment-module.html', 'ru/blog/golden_corn_or_sms.html',
    'ru/blog/from-12-second-friction-to-instant-checkout.html')

$regex = [regex]'(?s)[ \t]*<nav class="main-nav">.*?</nav>'

foreach ($f in $enFiles) {
    $p = Join-Path $root $f
    $t = [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)
    if (-not $regex.IsMatch($t)) { "EN MISSING NAV: $f"; continue }
    $t = $regex.Replace($t, $enNav.Replace('$', '$$'), 1)
    [System.IO.File]::WriteAllText($p, $t, $enc)
    "EN updated: $f"
}

foreach ($f in $ruFiles) {
    $p = Join-Path $root $f
    $t = [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)
    if (-not $regex.IsMatch($t)) { "RU MISSING NAV: $f"; continue }
    $t = $regex.Replace($t, $ruNav.Replace('$', '$$'), 1)
    [System.IO.File]::WriteAllText($p, $t, $enc)
    "RU updated: $f"
}
