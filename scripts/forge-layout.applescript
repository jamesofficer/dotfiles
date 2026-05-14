-- forge-layout.applescript
-- Creates a 3-pane Ghostty layout for instant-forge-ui:
--   default:  neovim (left), claude (right-top), pnpm start (right-bottom)
--   --left:   claude (left-top), pnpm start (left-bottom), neovim (right)
--
-- Prerequisites:
--   - Ghostty 1.3.0+
--   - macOS Accessibility permissions for Ghostty
--
-- Usage:
--   osascript ~/scripts/forge-layout.applescript
--   osascript ~/scripts/forge-layout.applescript --left

on run argv
	set leftMode to false
	repeat with arg in argv
		if (arg as string) is "--left" then set leftMode to true
	end repeat

	tell application "Ghostty"
		activate
	end tell

	delay 0.5

	tell application "System Events"
		tell process "Ghostty"
			-- Rename tab to "forge" (Cmd+R = prompt_tab_title)
			keystroke "r" using {command down}
			delay 0.3
			keystroke "forge"
			key code 36 -- Enter
			delay 0.3

			if leftMode then
				-- Start in single pane. Split right -> focus moves to right pane (becomes neovim).
				keystroke "d" using {command down}
				delay 0.5

				-- In right pane: run neovim
				keystroke "cd ~/Code/instant-forge-ui && nv"
				key code 36 -- Enter
				delay 0.3

				-- Goto left pane (Cmd+Option+Left)
				key code 123 using {command down, option down}
				delay 0.3

				-- Split down -> focus moves to left-bottom (pnpm)
				keystroke "d" using {command down, shift down}
				delay 0.5

				-- In left-bottom pane: run pnpm start
				keystroke "cd ~/Code/instant-forge-ui && pnpm i && pnpm start"
				key code 36 -- Enter
				delay 0.3

				-- Goto left-top pane (Cmd+Option+Up)
				key code 126 using {command down, option down}
				delay 0.3

				-- In left-top pane: run claude
				keystroke "cd ~/Code/instant-forge-ui && claude"
				key code 36 -- Enter
			else
				-- Default: stacked panes on the right.
				-- Split right to create right-top pane
				keystroke "d" using {command down}
				delay 0.5

				-- In right-top pane. Split down to create right-bottom pane.
				keystroke "d" using {command down, shift down}
				delay 0.5

				-- In right-bottom pane: run pnpm start
				keystroke "cd ~/Code/instant-forge-ui && pnpm i && pnpm start"
				key code 36 -- Enter
				delay 0.3

				-- Goto right-top pane (Cmd+Option+Up)
				key code 126 using {command down, option down}
				delay 0.3

				-- In right-top pane: run claude
				keystroke "cd ~/Code/instant-forge-ui && claude"
				key code 36 -- Enter
				delay 0.3

				-- Goto left pane (Cmd+Option+Left)
				key code 123 using {command down, option down}
				delay 0.3

				-- In left pane: run neovim
				keystroke "cd ~/Code/instant-forge-ui && nv"
				key code 36 -- Enter
			end if
		end tell
	end tell
end run
