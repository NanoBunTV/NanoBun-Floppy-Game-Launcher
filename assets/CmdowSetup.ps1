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

Add-MpPreference -ExclusionPath 'C:\Windows\cmdow.exe'
Start-Sleep -Seconds 1
Invoke-WebRequest -Uri "https://github.com/ritchielawrence/cmdow/raw/master/bin/Release/cmdow.exe" -OutFile "C:\Windows\cmdow.exe"

exit