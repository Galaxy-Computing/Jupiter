-- SPDX-FileCopyrightText: 2021 The CC: Tweaked Developers
--
-- SPDX-License-Identifier: MPL-2.0

-- Prints information about CraftOS
term.setTextColor(colors.purple)
print(os.version(1) .. " on " .. _HOST)
term.setTextColor(colors.white)