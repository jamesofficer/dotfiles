-- dev-layout.applescript
-- Creates a 3-pane Ghostty layout for logro, with each pane attached to a
-- persistent zmx session:
--   default:  logro.code/nvim (left), logro.ai/claude (right-top), logro.dev/pnpm start:sim (right-bottom)
--   --left:   logro.ai (left-top), logro.dev (left-bottom), logro.code (right)
--
-- zmx attach is an upsert: if the session already exists (e.g. after closing
-- Ghostty) it reattaches with state restored and ignores the command; if not
-- (e.g. after a reboot) it creates the session running the command. So this
-- script is safe to re-run any time.
--
-- Prerequisites:
--   - Ghostty 1.3.0+
--   - zmx (brew install neurosnap/tap/zmx)
--   - macOS Accessibility permissions for Ghostty
--
-- Usage:
--   osascript ~/scripts/dev-layout.applescript
--   osascript ~/scripts/dev-layout.applescript --left

on run argv
	set leftMode to false
	repeat with arg in argv
		if (arg as string) is "--left" then set leftMode to true
	end repeat

	-- cd first so a newly created session inherits the right start dir;
	-- commands are spelled out (no shell aliases) because zmx spawns them directly
	set codeCmd to "cd ~/Code/logro && zmx attach logro.code nvim"
	set aiCmd to "cd ~/Code/logro && zmx attach logro.ai claude"
	set devCmd to "cd ~/Code/logro/packages/app && zmx attach logro.dev pnpm run start:sim"

	tell application "Ghostty"
		activate
	end tell

	delay 0.5

	tell application "System Events"
		tell process "Ghostty"
			-- Rename tab to "logro" (Cmd+R = prompt_tab_title)
			keystroke "r" using {command down}
			delay 0.3
			keystroke "logro"
			key code 36 -- Enter
			delay 0.3

			if leftMode then
				-- Start in single pane. Split right -> focus moves to right pane (becomes neovim).
				keystroke "d" using {command down}
				delay 0.5

				-- In right pane: attach code session (nvim)
				keystroke codeCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto left pane (Cmd+Option+Left)
				key code 123 using {command down, option down}
				delay 0.3

				-- Split down -> focus moves to left-bottom (dev server)
				keystroke "d" using {command down, shift down}
				delay 0.5

				-- In left-bottom pane: attach dev session (pnpm start:sim)
				keystroke devCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto left-top pane (Cmd+Option+Up)
				key code 126 using {command down, option down}
				delay 0.3

				-- In left-top pane: attach ai session (claude)
				keystroke aiCmd
				key code 36 -- Enter
			else
				-- Default: stacked panes on the right.
				-- Split right to create right-top pane
				keystroke "d" using {command down}
				delay 0.5

				-- In right-top pane. Split down to create right-bottom pane.
				keystroke "d" using {command down, shift down}
				delay 0.5

				-- In right-bottom pane: attach dev session (pnpm start:sim)
				keystroke devCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto right-top pane (Cmd+Option+Up)
				key code 126 using {command down, option down}
				delay 0.3

				-- In right-top pane: attach ai session (claude)
				keystroke aiCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto left pane (Cmd+Option+Left)
				key code 123 using {command down, option down}
				delay 0.3

				-- In left pane: attach code session (nvim)
				keystroke codeCmd
				key code 36 -- Enter
			end if
		end tell
	end tell
end run
