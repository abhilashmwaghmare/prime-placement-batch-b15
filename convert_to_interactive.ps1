# PowerShell script to convert scenario files to interactive markdown

$scenarioDir = "c:\Users\Dell\Desktop\Prime Placement Batch B15\DevOps-Scenarios"
$files = Get-ChildItem -Path $scenarioDir -Filter "*.md" -Exclude "README.md"

$template = @"
<details>
<summary><b>Step 1: Diagnostics</b></summary>

[Commands for initial diagnosis]

</details>

<details>
<summary><b>Step 2: Root Cause Identification</b></summary>

[Commands to identify root cause]

</details>

<details>
<summary><b>Step 3: Resolution</b></summary>

[Steps to resolve the issue]

</details>
"@

Write-Host "Found $($files.Count) scenario files"
Write-Host "Files to process:"
$files | ForEach-Object { Write-Host "  - $($_.Name)" }
