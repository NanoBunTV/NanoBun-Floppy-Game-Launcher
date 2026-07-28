#Requires -Version 7.4

# ----------------------------------------------------------------------------
# ----------------------- Copyright (C) 2026 NanoBunTV -----------------------
# ----------------------------------------------------------------------------
# - This program is free software: you can redistribute it and/or modify it --
# - under the terms of the GNU Affero General Public License as published by -
# ------ the Free Software Foundation, either version 3 of the License, ------
# ------------------ or (at your option) any later version. ------------------
# ----------------------------------------------------------------------------
# ----- This program is distributed in the hope that it will be useful, ------
# ------ but WITHOUT ANY WARRANTY; without even the implied warranty of ------
# ----------- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. -----------
# ------- See the GNU Affero General Public License for more details. --------
# ----------------------------------------------------------------------------
# - You should have received a copy of the GNU Affero General Public License -
# -- along with this program. If not, see <https://www.gnu.org/licenses/>. ---
# ----------------------------------------------------------------------------

$batFile = "A:\autorun.bat"

while ($true) {
    # Wait until the batch file exists
    while (-not (Test-Path -LiteralPath $batFile -PathType Leaf)) {
        Start-Sleep -Milliseconds 1000
    }

    # File was found, so launch it
    try {
        Start-Process -FilePath $batFile
        Write-Host "autorun.bat found and launched."
    }
    catch {
        Write-Warning "Failed to launch autorun.bat: $($_.Exception.Message)"
    }

    # Wait here while the file remains present.
    # This prevents launching it repeatedly.
    while (Test-Path -LiteralPath $batFile -PathType Leaf) {
        Start-Sleep -Milliseconds 1000
    }

    # The file is no longer present, so the outer loop starts checking again.
    Write-Host "autorun.bat is no longer present. Watching for it again..."
}

exit